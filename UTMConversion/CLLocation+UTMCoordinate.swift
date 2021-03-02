import CoreLocation
import Foundation

public extension CLLocation {
    
    /**
        Calculates the UTM coordinate of the receiver
     
        - Parameter datum: The datum to use, defaults to WGS84 which should be fine for most applications
     
     */
    func utmCoordinate(datum: UTMDatum = UTMDatum.wgs84) -> UTMCoordinate {
        let coordinate = self.coordinate
        let zone = coordinate.zone
        return TMCoordinate(coordinate: coordinate, centralMeridian: zone.centralMeridian, datum: datum).utmCoordinate(zone: zone, hemisphere: coordinate.hemisphere)
    }
    
}
