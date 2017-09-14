//
//  UTMCoordinate.swift
//  UTMConversion
//
//  Created by Peter Ringset on 17/03/2017.
//  Copyright © 2017 WTW AS. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import CoreLocation
import Foundation

/** UTM grid zone is a positive number between 1 and 60 */
public typealias UTMGridZone = UInt

/** Extension to calculate the central meridian of the receiver */
extension UTMGridZone {
    
    /** Calculate the central meridian of the receiver */
    var centralMeridian: Double {
        return toRadians(degrees: -183.0 + (Double(self) * 6.0));
    }
}

/** 
    UTM hemisphere, an enum used to represent the two hemispheres on the earth
 
    - northern: The northern hemisphere
    - southern: The southern hemisphere
 */
public enum UTMHemisphere {
    case northern
    case southern
}

/**
    Geodetic datum to define the size of the earth, given as equitorial and polar radius.
 */
public struct UTMDatum {
    /** The radius around the equator */
    public let equitorialRadius: Double
    
    /** The radius of the poles */
    public let polarRadius: Double
    
    /** WGS84 is the most commonly used datum of the earth */
    public static let wgs84 = UTMDatum(equitorialRadius: 6378137, polarRadius: 6356752.3142) // WGS84
}

/**
    Universal Transverse Mercator (UTM) coordinate which divies the earth into 60 different zones. The coordinates northing and easting are relative to the specified zone, and are also relative to the hemisphere.
 */
public struct UTMCoordinate {
    
    /** Northing, corresponds to the latitude */
    public let northing: Double
    
    /** Easting, corresponds to longitude */
    public let easting: Double
    
    /** Zone, a positive integer between 1 and 60 */
    public let zone: UTMGridZone
    
    /** Hemisphere, northern or southern */
    public let hemisphere: UTMHemisphere
    
    /**
        Initializes a UTM coordinate with the specified parameters
     */
    public init(northing: Double, easting: Double, zone: UTMGridZone, hemisphere: UTMHemisphere) {
        self.northing = northing
        self.easting = easting
        self.zone = zone
        self.hemisphere = hemisphere
    }
    
    /**
        Calculates the latitude/longitude coordinate of the receiver
     
        - Parameter datum: The datum to use, defaults to WGS84 which should be fine for most applications
     */
    public func coordinate(datum: UTMDatum = UTMDatum.wgs84) -> CLLocationCoordinate2D {
        return TMCoordinate(utmCoordinate: self).coordinate(centralMeridian: zone.centralMeridian, datum: datum)
    }
    
    /**
        Calculates the location (CLLocation) coordinate of the receiver
     
        - Parameter datum: The datum to use, defaults to WGS84 which should be fine for most applications
     */
    public func location(datum: UTMDatum = UTMDatum.wgs84) -> CLLocation {
        let coordinateStruct = coordinate(datum: datum)
        return CLLocation(latitude: coordinateStruct.latitude, longitude: coordinateStruct.longitude)
    }
    
}
