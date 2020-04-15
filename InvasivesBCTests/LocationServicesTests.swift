//
//  LocationServicesTests.swift
//  InvasivesBCTests
//
//  Created by Amir Shayegh on 2020-04-14.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import XCTest
import MapKit
@testable import InvasivesBC

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

class LocationServicesTests: XCTestCase {
    func testAlbersToLatLong() throws{
        let longitude = -119.472548
        let latitude = 49.905577
        let albersX = 1468294.70085
        let albersY = 564887.24757
        let coordinates = AlbersCoordinate(x: albersX, y: albersY)
        let expectedResult = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let converted = coordinates.toLatLong()
        XCTAssertEqual(converted.latitude.rounded(toPlaces: 6), expectedResult.latitude, "Conversion from Albers to Lat")
        XCTAssertEqual(converted.longitude.rounded(toPlaces: 6), expectedResult.longitude, "Conversion from Albers to Long")
    }
    
    func testLatLongToAlbers() throws {
        let longitude = -119.472548
        let latitude = 49.905577
        let albersX = 1468294.70086
        let albersY = 564887.24757
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let expectedResult = AlbersCoordinate(x: albersX, y: albersY)
        let converted = coordinates.toAlbers()
        XCTAssertEqual(converted.x.rounded(toPlaces: 5), expectedResult.x.rounded(toPlaces: 5), "Conversion from Lat Long to Albers x")
        XCTAssertEqual(converted.y.rounded(toPlaces: 5), expectedResult.y.rounded(toPlaces: 5), "Conversion from Lat Long to Albers y")
    }
    
    func testLatLongToUTM() throws {
        let longitude = -119.472548
        let latitude = 49.905577
        let UTMx = 322462.246733
        let UTMy = 5531063.683699
        let utmZone = 11
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let expectedResult = UTMCoordinate(northings: UTMy, eastings: UTMx, zone: utmZone)
        let converted = coordinates.toUTM()
        XCTAssertEqual(converted?.eastings.rounded(toPlaces: 5), expectedResult.eastings.rounded(toPlaces: 5), "Conversion from Lat Long to UTM X")
        XCTAssertEqual(converted?.northings.rounded(toPlaces: 5), expectedResult.northings.rounded(toPlaces: 5), "Conversion from Lat Long to UTM Y")
        XCTAssertEqual(converted?.zone, expectedResult.zone, "Conversion from Lat Long to UTM Zone")
    }
    
    func testUTMToLatLong() throws {
        let longitude = -119.472548
        let latitude = 49.905577
        let UTMx = 322462.246733
        let UTMy = 5531063.683699
        let utmZone = 11
        let coordinates = UTMCoordinate(northings: UTMy, eastings: UTMx, zone: utmZone)
        let expectedResult = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let converted = coordinates.toLatLong()
        XCTAssertEqual(converted?.latitude.rounded(toPlaces: 6), expectedResult.latitude, "Conversion from UTM to Lat")
        XCTAssertEqual(converted?.longitude.rounded(toPlaces: 6), expectedResult.longitude, "Conversion from UTM to Long")
    }
    
    func testInsideOutside() {
        let one = CLLocationCoordinate2D(latitude: 49.905577, longitude: -119.472548)
        let two = CLLocationCoordinate2D(latitude: 57.166618, longitude: -120.585487)
        let three = CLLocationCoordinate2D(latitude: 54.915275, longitude: -126.026107)
        
        let four = CLLocationCoordinate2D(latitude: 47.848960, longitude: -105.389280)
        let five = CLLocationCoordinate2D(latitude: 55.858886, longitude: -108.916926)
        let six = CLLocationCoordinate2D(latitude: 61.694234, longitude: -145.369272)

        XCTAssertTrue(one.isInBC(), "Is Inside BC")
        XCTAssertTrue(two.isInBC(), "Is Inside BC")
        XCTAssertTrue(three.isInBC(), "Is Inside BC")
        
        XCTAssertFalse(four.isInBC(), "Is Outside BC")
        XCTAssertFalse(five.isInBC(), "Is Outside BC")
        XCTAssertFalse(six.isInBC(), "Is Outside BC")
    }
    
}
