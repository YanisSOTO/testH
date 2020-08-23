//
//  ApiProtocol.swift
//  FindMyDriver
//
//  Created by Yanis Soto on 23/08/2020.
//  Copyright © 2020 Heetch. All rights reserved.
//


public protocol ApiProtocol {
    
    var api: API { get }
    
    func setUpMyLocation()
    func requestDrivers()
}
