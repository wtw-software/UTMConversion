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
    
    func testCLLocationCoordinate2D_utmCoordinate() {
        let osloUTM = oslo.utmCoordinate()
        XCTAssertEqualWithAccuracy(osloUTM.northing, 6643010.0, accuracy: 0.00001);
        XCTAssertEqualWithAccuracy(osloUTM.easting, 598430.0, accuracy: 0.00001);
        XCTAssertEqual(osloUTM.zone, 32)
        XCTAssertEqual(osloUTM.hemisphere, .northern)
        
        let trondheimUTM = trondheim.utmCoordinate()
        XCTAssertEqualWithAccuracy(trondheimUTM.northing, 7034313, accuracy: 0.00001)
        XCTAssertEqualWithAccuracy(trondheimUTM.easting, 569612, accuracy: 0.00001)
        XCTAssertEqual(trondheimUTM.zone, 32)
        XCTAssertEqual(trondheimUTM.hemisphere, .northern)
        
        let johannesburgUTM = johannesburg.utmCoordinate()
        XCTAssertEqualWithAccuracy(johannesburgUTM.northing, 7100115, accuracy: 0.00001)
        XCTAssertEqualWithAccuracy(johannesburgUTM.easting, 603914, accuracy: 0.00001)
        XCTAssertEqual(johannesburgUTM.zone, 35)
        XCTAssertEqual(johannesburgUTM.hemisphere, .southern)
    }
    
    func testCLLocation_utmCoordinate() {
        let osloUTM = osloLocation.utmCoordinate()
        XCTAssertEqualWithAccuracy(osloUTM.northing, 6643010.0, accuracy: 0.00001);
        XCTAssertEqualWithAccuracy(osloUTM.easting, 598430.0, accuracy: 0.00001);
        XCTAssertEqual(osloUTM.zone, 32)
        XCTAssertEqual(osloUTM.hemisphere, .northern)
        
        let trondheimUTM = trondheimLocation.utmCoordinate()
        XCTAssertEqualWithAccuracy(trondheimUTM.northing, 7034313, accuracy: 0.00001)
        XCTAssertEqualWithAccuracy(trondheimUTM.easting, 569612, accuracy: 0.00001)
        XCTAssertEqual(trondheimUTM.zone, 32)
        XCTAssertEqual(trondheimUTM.hemisphere, .northern)
        
        let johannesburgUTM = johannesburgLocation.utmCoordinate()
        XCTAssertEqualWithAccuracy(johannesburgUTM.northing, 7100115, accuracy: 0.00001)
        XCTAssertEqualWithAccuracy(johannesburgUTM.easting, 603914, accuracy: 0.00001)
        XCTAssertEqual(johannesburgUTM.zone, 35)
        XCTAssertEqual(johannesburgUTM.hemisphere, .southern)
    }
    
    func testUTMCoordinate_coordinate() {
        let oslo = osloUTM.coordinate()
        XCTAssertEqual(oslo.latitude, 59.912814611065265)
        XCTAssertEqual(oslo.longitude, 10.760192985178369)
        
        let trondheim = trondheimUTM.coordinate()
        XCTAssertEqual(trondheim.latitude, 63.430493678423012)
        XCTAssertEqual(trondheim.longitude, 10.394966844991798)
        
        let utmJohannesburg = UTMCoordinate(northing: 7100115, easting: 603914, zone: 35, hemisphere: .southern)
        let johannesburg = utmJohannesburg.coordinate()
        XCTAssertEqual(johannesburg.latitude, -26.214767103043133)
        XCTAssertEqual(johannesburg.longitude, 28.040197220939884)
    }
    
    func testUTMCoordinate_location() {
        let oslo = osloUTM.location()
        XCTAssertEqual(oslo.coordinate.latitude, 59.912814611065265)
        XCTAssertEqual(oslo.coordinate.longitude, 10.760192985178369)
        
        let trondheim = trondheimUTM.location()
        XCTAssertEqual(trondheim.coordinate.latitude, 63.430493678423012)
        XCTAssertEqual(trondheim.coordinate.longitude, 10.394966844991798)
        
        let johannesburg = johannesburgUTM.location()
        XCTAssertEqual(johannesburg.coordinate.latitude, -26.214767103043133)
        XCTAssertEqual(johannesburg.coordinate.longitude, 28.040197220939884)
    }
    
}


private let oslo = CLLocationCoordinate2D(latitude: 59.912814611065265, longitude: 10.760192985178369)
private let trondheim = CLLocationCoordinate2D(latitude: 63.430493678423012, longitude: 10.394966844991798)
private let johannesburg = CLLocationCoordinate2D(latitude: -26.214767103043133, longitude: 28.040197220939884)

private let osloUTM = UTMCoordinate(northing: 6643010, easting: 598430, zone: 32, hemisphere: .northern)
private let trondheimUTM = UTMCoordinate(northing: 7034313, easting: 569612, zone: 32, hemisphere: .northern)
private let johannesburgUTM = UTMCoordinate(northing: 7100115, easting: 603914, zone: 35, hemisphere: .southern)

private let osloLocation = CLLocation(latitude: 59.912814611065265, longitude: 10.760192985178369)
private let trondheimLocation = CLLocation(latitude: 63.430493678423012, longitude: 10.394966844991798)
private let johannesburgLocation = CLLocation(latitude: -26.214767103043133, longitude: 28.040197220939884)
