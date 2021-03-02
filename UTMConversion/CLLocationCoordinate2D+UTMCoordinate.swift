import Foundation
import CoreLocation

public extension CLLocationCoordinate2D {
    
    
    /**
     Calculates the UTM coordinate of the receiver
     
     - Parameter datum: The datum to use, defaults to WGS84 which should be fine for most applications
     
     */
    func utmCoordinate(datum: UTMDatum = UTMDatum.wgs84) -> UTMCoordinate {
        let zone = self.zone
        return TMCoordinate(coordinate: self, centralMeridian: zone.centralMeridian, datum: datum).utmCoordinate(zone: zone, hemisphere: hemisphere)
    }
    
    
    /**
     The UTM grid zone
     */
    var zone: UTMGridZone {
        return UTMGridZone(floor((longitude + 180.0) / 6)) + 1;
    }
    
    /**
     The UTM hemisphere
     */
    var hemisphere: UTMHemisphere {
        return latitude < 0 ? .southern : .northern
    }
    
}
