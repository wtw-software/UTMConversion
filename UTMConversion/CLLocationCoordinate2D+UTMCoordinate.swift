//
//  CLLocationCoordinate2D+UTMCoordinate.swift
//  UTMConversion
//
//  Created by Peter Ringset on 17/03/2017.
//  Copyright © 2017 Peter Ringset. All rights reserved.
//

import Foundation
import CoreLocation

public extension CLLocationCoordinate2D {
    
    public func utmCoordinate(datum: UTMDatum = UTMDatum.wgs84) -> UTMCoordinate {
        let zone = self.zone
        return TMCoordinate(coordinate: self, centralMeridian: zone.centralMeridian, datum: datum).utmCoordinate(zone: zone, hemisphere: hemisphere)
    }
    
    var zone: UTMGridZone {
        return UTMGridZone(floor((longitude + 180.0) / 6)) + 1;
    }
    
    var hemisphere: UTMHemisphere {
        return latitude < 0 ? .southern : .northern
    }
    
}
