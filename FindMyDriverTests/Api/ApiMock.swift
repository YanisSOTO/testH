//
//  ApiMock.swift
//  FindMyDriverTests
//
//  Created by Yanis Soto on 23/08/2020.
//  Copyright © 2020 Heetch. All rights reserved.
//

import XCTest
import Foundation
import RxSwift
@testable import FindMyDriver

class ApiMock: ApiMockProtocol {

    init() {
    }
    
    func getListDrivers() -> Observable<[DriverHeetch]> {
        let drivers = [DriverHeetch(id: 1, firstname: "Pierre", lastname: "Lamage", image: "/image", coordinates: DriverHeetch.Coordinates(latitude: 42.0923, longitude: -2.2323)),
                  DriverHeetch(id: 1, firstname: "Magalie", lastname: "Leroi", image: "/image", coordinates: DriverHeetch.Coordinates(latitude: 2.0923, longitude: -4.2323)),
                  DriverHeetch(id: 1, firstname: "Pierre", lastname: "Lamage", image: "/image", coordinates: DriverHeetch.Coordinates(latitude: 20.09423, longitude: 1.2323)),
                  DriverHeetch(id: 1, firstname: "Pierre", lastname: "Lamage", image: "/image", coordinates: DriverHeetch.Coordinates(latitude: 53.123, longitude: -2.43))
        ]
        
        return Observable.just(drivers)
    }
}


protocol ApiMockProtocol {
     func getListDrivers() -> Observable<[DriverHeetch]>
}

