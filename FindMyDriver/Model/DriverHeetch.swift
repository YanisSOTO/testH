//
//  DriverHeetch.swift
//  FindMyDriver
//
//  Created by Yanis Soto on 21/08/2020.
//  Copyright © 2020 Heetch. All rights reserved.
//

import Foundation

// MARK: - Driver model
public struct DriverHeetch: Codable, Equatable {

    public struct Coordinates: Codable, Equatable {

        public let latitude: Double
        public let longitude: Double
        
        init (latitude: Double, longitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
        }
    }

    public let id: Int
    public let firstname, lastname, image: String
    let coordinates: Coordinates
    
    enum CodingKeys: String, CodingKey {
        case id, firstname, lastname, image, coordinates
    }
}
