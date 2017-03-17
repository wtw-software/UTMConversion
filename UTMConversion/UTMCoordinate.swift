//
//  UTMCoordinate.swift
//  UTMConversion
//
//  Created by Peter Ringset on 17/03/2017.
//  Copyright © 2017 Peter Ringset. All rights reserved.
//

import CoreLocation
import Foundation

public typealias UTMGridZone = UInt

extension UTMGridZone {
    var centralMeridian: Double {
        return toRadians(degrees: -183.0 + (Double(self) * 6.0));
    }
}

public enum UTMHemisphere {
    case northern
    case southern
}

public struct UTMDatum {
    public let equitorialRadius: Double
    public let polarRadius: Double
    
    public static let wgs84 = UTMDatum(equitorialRadius: 6378137, polarRadius: 6356752.3142) // WGS84
}

public struct UTMCoordinate {
    
    public let northing: Double
    public let easting: Double
    public let zone: UTMGridZone
    public let hemisphere: UTMHemisphere
    
    public init(northing: Double, easting: Double, zone: UTMGridZone, hemisphere: UTMHemisphere) {
        self.northing = northing
        self.easting = easting
        self.zone = zone
        self.hemisphere = hemisphere
    }
    
    public func coordinate(datum: UTMDatum = UTMDatum.wgs84) -> CLLocationCoordinate2D {
        return TMCoordinate(utmCoordinate: self).coordinate(centralMeridian: zone.centralMeridian, datum: datum)
    }
    
}
