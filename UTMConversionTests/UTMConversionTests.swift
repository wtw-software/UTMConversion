//
//  UTMConversionTests.swift
//  UTMConversionTests
//
//  Created by Peter Ringset on 17/03/2017.
//  Copyright © 2017 Peter Ringset. All rights reserved.
//

import CoreLocation
import UTMConversion
import XCTest

class UTMConversionTests: XCTestCase {
    
    func testCLLocationCoordinate2DConvertToUTMCoordinate() {
        let oslo = CLLocationCoordinate2D(latitude: 59.912814611065265, longitude: 10.760192985178369)
        let utmOslo = oslo.utmCoordinate()
        XCTAssertEqualWithAccuracy(utmOslo.northing, 6643010.0, accuracy: 0.00001);
        XCTAssertEqualWithAccuracy(utmOslo.easting, 598430.0, accuracy: 0.00001);
        XCTAssertEqual(utmOslo.zone, 32)
        XCTAssertEqual(utmOslo.hemisphere, .northern)
        
        let trondheim = CLLocationCoordinate2D(latitude: 63.430493678423012, longitude: 10.394966844991798)
        let utmTrondheim = trondheim.utmCoordinate()
        XCTAssertEqualWithAccuracy(utmTrondheim.northing, 7034313, accuracy: 0.00001)
        XCTAssertEqualWithAccuracy(utmTrondheim.easting, 569612, accuracy: 0.00001)
        XCTAssertEqual(utmTrondheim.zone, 32)
        XCTAssertEqual(utmTrondheim.hemisphere, .northern)
        
        let johannesburg = CLLocationCoordinate2D(latitude: -26.214767103043133, longitude: 28.040197220939884)
        let utmJohannesburg = johannesburg.utmCoordinate()
        XCTAssertEqualWithAccuracy(utmJohannesburg.northing, 7100115, accuracy: 0.00001)
        XCTAssertEqualWithAccuracy(utmJohannesburg.easting, 603914, accuracy: 0.00001)
        XCTAssertEqual(utmJohannesburg.zone, 35)
        XCTAssertEqual(utmJohannesburg.hemisphere, .southern)
    }
    
    func testUTMCoordinateConvertToCLLocationCoordinate2D() {
        let utmOslo = UTMCoordinate(northing: 6643010, easting: 598430, zone: 32, hemisphere: .northern)
        let oslo = utmOslo.coordinate()
        XCTAssertEqual(oslo.latitude, 59.912814611065265)
        XCTAssertEqual(oslo.longitude, 10.760192985178369)
        
        let utmTrondheim = UTMCoordinate(northing: 7034313, easting: 569612, zone: 32, hemisphere: .northern)
        let trondheim = utmTrondheim.coordinate()
        XCTAssertEqual(trondheim.latitude, 63.430493678423012)
        XCTAssertEqual(trondheim.longitude, 10.394966844991798)
        
        let utmJohannesburg = UTMCoordinate(northing: 7100115, easting: 603914, zone: 35, hemisphere: .southern)
        let johannesburg = utmJohannesburg.coordinate()
        XCTAssertEqual(johannesburg.latitude, -26.214767103043133)
        XCTAssertEqual(johannesburg.longitude, 28.040197220939884)
    }
    
}
