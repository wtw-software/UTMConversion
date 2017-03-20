//
//  CLLocation+UTMCoordinate.swift
//  UTMConversion
//
//  Created by Peter Ringset on 17/03/2017.
//  Copyright © 2017 Peter Ringset. All rights reserved.
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

public extension CLLocation {
    
    /**
        Calculates the UTM coordinate of the receiver
     
        - Parameter datum: The datum to use, defaults to WGS84 which should be fine for most applications
     
     */
    public func utmCoordinate(datum: UTMDatum = UTMDatum.wgs84) -> UTMCoordinate {
        let coordinate = self.coordinate
        let zone = coordinate.zone
        return TMCoordinate(coordinate: coordinate, centralMeridian: zone.centralMeridian, datum: datum).utmCoordinate(zone: zone, hemisphere: coordinate.hemisphere)
    }
    
}
