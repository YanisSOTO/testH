//
//  DriverHeetch+Test.swift
//  FindMyDriverTests
//
//  Created by Yanis Soto on 23/08/2020.
//  Copyright © 2020 Heetch. All rights reserved.
//

import XCTest

@testable import FindMyDriver
class DriverHeetch_Test: XCTestCase {
    func testDriverHeetchFromtInit() {
        let driver = self.createDriverHeetch()
        XCTAssertEqual(driver.firstname, "Pierre")
        XCTAssertEqual(driver.lastname, "Michel")
        XCTAssertEqual(driver.image, "/image")
        XCTAssertEqual(driver.coordinates, DriverHeetch.Coordinates(latitude: 0.1, longitude: 2.1))
    }
    
    func testCoordinateFromInit() {
        let coordinates = self.createCoordinates()
        XCTAssertEqual(coordinates.latitude, 0.1)
        XCTAssertEqual(coordinates.longitude, 2.1)
    }
}

extension DriverHeetch_Test {
    func createDriverHeetch() -> DriverHeetch {
        let driver = DriverHeetch(id: 1, firstname: "Pierre", lastname: "Michel", image: "/image", coordinates: self.createCoordinates())
        return driver
    }
    
    func createCoordinates() -> DriverHeetch.Coordinates {
        let coordinates = DriverHeetch.Coordinates(latitude: 0.1, longitude: 2.1)
        return coordinates
    }
}
    
