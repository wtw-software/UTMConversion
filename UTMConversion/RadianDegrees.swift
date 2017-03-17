//
//  RadianDegrees.swift
//  UTMConversion
//
//  Created by Peter Ringset on 16/03/2017.
//  Copyright © 2017 WTW. All rights reserved.
//

import Foundation

func toDegrees(radians: Double) -> Double {
    return radians * 180 / M_PI
}

func toRadians(degrees: Double) -> Double {
    return degrees / 180 * M_PI
}
