//
//  Constant.swift
//  FindMyDriver
//
//  Created by Yanis Soto on 21/08/2020.
//  Copyright © 2020 Heetch. All rights reserved.
//

import Foundation

struct K {
    struct ProductionServer {
        static let baseURL = "http://hiring.heetch.com/mobile"
    }
    
//    struct APIParameterKey {
//    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
