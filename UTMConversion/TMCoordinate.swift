import CoreLocation
import Foundation

let utmScaleFactor = 0.9996

func toDegrees(radians: Double) -> Double {
    return radians * 180 / Double.pi
}

func toRadians(degrees: Double) -> Double {
    return degrees / 180 * Double.pi
}

/**
    Internal struct used to represent Transverse Mercator coordinates. This struct is used as an intermediate representation of the location, in order to convert between Universal Transverse Mercator (UTM) coordinates, and latitude and longitude.
 */
struct TMCoordinate {
    let northing: Double
    let easting: Double
    
    init(utmCoordinate: UTMCoordinate) {
        easting = (utmCoordinate.easting - 500000.0) / utmScaleFactor;
        northing = {
            /* If in southern hemisphere, adjust y accordingly. */
            if case .southern = utmCoordinate.hemisphere {
                return (utmCoordinate.northing - 10000000.0) / utmScaleFactor
            }
            return utmCoordinate.northing / utmScaleFactor
        }()
    }
    
    /**
        Init with a CLLocationCoordinate
     
        - Parameter coordinate: The coordinate to init with
        - Parameter centralMeridian: The central meridian of the earth
        - Parameter datum: The datum to use
     */
    init(coordinate: CLLocationCoordinate2D, centralMeridian: Double, datum: UTMDatum) {
        let phi = toRadians(degrees: coordinate.latitude) // Latitude in radians
        let lambda = toRadians(degrees: coordinate.longitude) // Longitude in radians
        
        let equitorialRadus = datum.equitorialRadius
        let polarRadius = datum.polarRadius
        
        /* Precalculate ep2 */
        let ep2 = (pow(equitorialRadus, 2.0) - pow(polarRadius, 2.0)) / pow(polarRadius, 2.0)
        
        /* Precalculate nu2 */
        let nu2 = ep2 * pow(cos(phi), 2.0)
        
        /* Precalculate N */
        let N = pow(equitorialRadus, 2.0) / (polarRadius * sqrt(1 + nu2))
        
        /* Precalculate t */
        let t = tan(phi)
        let t2 = t * t
        
        /* Precalculate l */
        let l = lambda - centralMeridian
        
        /* Precalculate coefficients for l**n in the equations below
         so a normal human being can read the expressions for easting
         and northing
         -- l**1 and l**2 have coefficients of 1.0 */
        let l3coef = 1.0 - t2 + nu2
        let l4coef = 5.0 - t2 + 9 * nu2 + 4.0 * (nu2 * nu2)
        let l5coef = 5.0 - 18.0 * t2 + (t2 * t2) + 14.0 * nu2 - 58.0 * t2 * nu2
        let l6coef = 61.0 - 58.0 * t2 + (t2 * t2) + 270.0 * nu2 - 330.0 * t2 * nu2
        let l7coef = 61.0 - 479.0 * t2 + 179.0 * (t2 * t2) - (t2 * t2 * t2)
        let l8coef = 1385.0 - 3111.0 * t2 + 543.0 * (t2 * t2) - (t2 * t2 * t2)
        
        // Compute the ellipsoidal distance from the equator to a point at a given latitude in meters
        let arcLengthOfMeridian: (Double, UTMDatum) -> Double = { latitudeInRadians, datum in
            let equitorialRadus = datum.equitorialRadius
            let polarRadius = datum.polarRadius
            
            /* Precalculate n */
            let n = (equitorialRadus - polarRadius) / (equitorialRadus + polarRadius)
            
            /* Precalculate alpha */
            let alpha = ((equitorialRadus + polarRadius) / 2.0) * (1.0 + (pow(n, 2.0) / 4.0) + (pow(n, 4.0) / 64.0))
            
            /* Precalculate beta */
            let beta = (-3.0 * n / 2.0) + (9.0 * pow(n, 3.0) / 16.0) + (-3.0 * pow(n, 5.0) / 32.0)
            
            /* Precalculate gamma */
            let gamma = (15.0 * pow(n, 2.0) / 16.0) + (-15.0 * pow(n, 4.0) / 32.0)
            
            /* Precalculate delta */
            let delta = (-35.0 * pow(n, 3.0) / 48.0) + (105.0 * pow(n, 5.0) / 256.0)
            
            /* Precalculate epsilon */
            let epsilon = (315.0 * pow(n, 4.0) / 512.0)
            
            /* Now calculate the sum of the series and return */
            let result = alpha * (latitudeInRadians + (beta * sin(2.0 * latitudeInRadians)) + (gamma * sin(4.0 * latitudeInRadians)) + (delta * sin(6.0 * latitudeInRadians)) + (epsilon * sin(8.0 * latitudeInRadians)))
            
            return result
        }
        
        /* Calculate easting (x) */
        easting = N * cos(phi) * l + (N / 6.0 * pow(cos(phi), 3.0) * l3coef * pow(l, 3.0)) + (N / 120.0 * pow(cos(phi), 5.0) * l5coef * pow(l, 5.0)) + (N / 5040.0 * pow(cos(phi), 7.0) * l7coef * pow(l, 7.0))
        
        /* Calculate northing (y) */
        northing = arcLengthOfMeridian(phi, datum) + (t / 2.0 * N * pow(cos(phi), 2.0) * pow(l, 2.0)) + (t / 24.0 * N * pow(cos(phi), 4.0) * l4coef * pow(l, 4.0)) + (t / 720.0 * N * pow(cos(phi), 6.0) * l6coef * pow(l, 6.0)) + (t / 40320.0 * N * pow(cos(phi), 8.0) * l8coef * pow(l, 8.0))
    }
    
    /**
        Create an UTMCoordinate from the receiver
     
        - Parameter zone: The UTMGridZone to use
        - Parameter hemisphere: Choose if the coordinate should be relative to the northern of southern hemisphere
     
     */
    func utmCoordinate(zone: UTMGridZone, hemisphere: UTMHemisphere) -> UTMCoordinate {
        let x = easting * utmScaleFactor + 500000.0;
        let y: Double = {
            let scaled = northing * utmScaleFactor
            if scaled < 0.0 {
                return scaled + 10000000.0
            }
            return scaled
        }()
        
        return UTMCoordinate(northing: y, easting: x, zone: zone, hemisphere: hemisphere)
    }
    
    /**
        Converts easting and northing coordinates in the Transverse Mercator projection to a latitude/longitude pair. Note that Transverse Mercator is not the same as UTM a scale factor is required to convert between them.
     
        - Parameter centralMeridian: The central meridian of the earth
        - Parameter datum: The datum to use
     
     */
    func coordinate(centralMeridian: Double, datum: UTMDatum) -> CLLocationCoordinate2D {
        /* The local variables Nf, nuf2, tf, and tf2 serve the same purpose as N, nu2, t, and t2 in MapLatLonToXY, but they are computed with respect to the footpoint latitude phif. x1frac, x2frac, x2poly, x3poly, etc. are to enhance readability and to optimize computations. */

        let x = easting
        let y = northing
        
        let equitorialRadus = datum.equitorialRadius
        let polarRadius = datum.polarRadius
        
        /* Get the value of phif, the footpoint latitude. */
        let phif = footpointLatitude(northing: y, datum: datum)
        
        /* Precalculate ep2 */
        let ep2 = (pow(equitorialRadus, 2.0) - pow(polarRadius, 2.0)) / pow(polarRadius, 2.0)
        
        /* Precalculate cos (phif) */
        let cf = cos(phif)
        
        /* Precalculate nuf2 */
        let nuf2 = ep2 * pow(cf, 2.0)
        
        /* Precalculate Nf and initialize Nfpow */
        let Nf = pow(equitorialRadus, 2.0) / (polarRadius * sqrt(1 + nuf2))
        var Nfpow = Nf
        
        /* Precalculate tf */
        let tf = tan(phif)
        let tf2 = tf * tf
        let tf4 = tf2 * tf2
        
        /* Precalculate fractional coefficients for x**n in the equations
         below to simplify the expressions for latitude and longitude. */
        let x1frac = 1.0 / (Nfpow * cf)
        
        Nfpow *= Nf   /* now equals Nf**2) */
        let x2frac = tf / (2.0 * Nfpow)
        
        Nfpow *= Nf   /* now equals Nf**3) */
        let x3frac = 1.0 / (6.0 * Nfpow * cf)
        
        Nfpow *= Nf   /* now equals Nf**4) */
        let x4frac = tf / (24.0 * Nfpow)
        
        Nfpow *= Nf   /* now equals Nf**5) */
        let x5frac = 1.0 / (120.0 * Nfpow * cf)
        
        Nfpow *= Nf   /* now equals Nf**6) */
        let x6frac = tf / (720.0 * Nfpow)
        
        Nfpow *= Nf   /* now equals Nf**7) */
        let x7frac = 1.0 / (5040.0 * Nfpow * cf)
        
        Nfpow *= Nf   /* now equals Nf**8) */
        let x8frac = tf / (40320.0 * Nfpow)
        
        /* Precalculate polynomial coefficients for x**n.
         -- x**1 does not have a polynomial coefficient. */
        let x2poly = -1.0 - nuf2
        let x3poly = -1.0 - 2 * tf2 - nuf2
        let x4poly = 5.0 + 3.0 * tf2 + 6.0 * nuf2 - 6.0 * tf2 * nuf2 - 3.0 * (nuf2 * nuf2) - 9.0 * tf2 * (nuf2 * nuf2)
        let x5poly = 5.0 + 28.0 * tf2 + 24.0 * tf4 + 6.0 * nuf2 + 8.0 * tf2 * nuf2
        let x6poly = -61.0 - 90.0 * tf2 - 45.0 * tf4 - 107.0 * nuf2 + 162.0 * tf2 * nuf2
        let x7poly = -61.0 - 662.0 * tf2 - 1320.0 * tf4 - 720.0 * (tf4 * tf2)
        let x8poly = 1385.0 + 3633.0 * tf2 + 4095.0 * tf4 + 1575 * (tf4 * tf2)
        
        /* Calculate latitude */
        let latitudeRadians = phif + x2frac * x2poly * (x * x) + x4frac * x4poly * pow(x, 4.0) + x6frac * x6poly * pow(x, 6.0) + x8frac * x8poly * pow(x, 8.0)
        
        /* Calculate longitude */
        let longitudeRadians = centralMeridian + x1frac * x + x3frac * x3poly * pow(x, 3.0) + x5frac * x5poly * pow(x, 5.0) + x7frac * x7poly * pow(x, 7.0)
        
        return CLLocationCoordinate2D(latitude: toDegrees(radians: latitudeRadians), longitude: toDegrees(radians: longitudeRadians))
    }
    
    /**
        Computes the footpoint latitude for use in converting transverse Mercator coordinates to ellipsoidal coordinates.
     
        - Parameter northingInMeters: The northing value
        - Parameter datum: The datum to use
     
     */
    private func footpointLatitude(northing: Double, datum: UTMDatum) -> Double {
        let equitorialRadus = datum.equitorialRadius
        let polarRadius = datum.polarRadius
        
        /* Precalculate n (Eq. 10.18) */
        let n = (equitorialRadus - polarRadius) / (equitorialRadus + polarRadius)
        
        /* Precalculate alpha_ (Eq. 10.22) */
        /* (Same as alpha in Eq. 10.17) */
        let alpha = ((equitorialRadus + polarRadius) / 2.0) * (1 + (pow(n, 2.0) / 4) + (pow(n, 4.0) / 64))
        
        /* Precalculate y (Eq. 10.23) */
        let y = northing / alpha
        
        /* Precalculate beta (Eq. 10.22) */
        let beta = (3.0 * n / 2.0) + (-27.0 * pow(n, 3.0) / 32.0) + (269.0 * pow(n, 5.0) / 512.0)
        
        /* Precalculate gamma (Eq. 10.22) */
        let gamma = (21.0 * pow(n, 2.0) / 16.0) + (-55.0 * pow(n, 4.0) / 32.0)
        
        /* Precalculate delta (Eq. 10.22) */
        let delta = (151.0 * pow(n, 3.0) / 96.0) + (-417.0 * pow(n, 5.0) / 128.0)
        
        /* Precalculate epsilon (Eq. 10.22) */
        let epsilon = (1097.0 * pow(n, 4.0) / 512.0)
        
        /* Now calculate the sum of the series (Eq. 10.21) */
        let footprintLatitudeInRadians = y + (beta * sin(2.0 * y)) + (gamma * sin(4.0 * y)) + (delta * sin(6.0 * y)) + (epsilon * sin(8.0 * y))
        
        return footprintLatitudeInRadians
    }
    
}
