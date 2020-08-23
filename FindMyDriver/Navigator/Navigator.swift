//
//  Navigator.swift
//  FindMyDriver
//
//  Created by Yanis Soto on 21/08/2020.
//  Copyright © 2020 Heetch. All rights reserved.
//

import Foundation

protocol Navigator {
    associatedtype Destination

    func navigate(to destination: Destination)
}
