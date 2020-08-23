//
//  Extension.swift
//  FindMyDriver
//
//  Created by Yanis Soto on 23/08/2020.
//  Copyright © 2020 Heetch. All rights reserved.
//

import UIKit

// MARK: - UIImage extension
extension UIImage {

    public static func loadImageFromURL(url: URL) -> UIImage?{
        if let data = try? Data(contentsOf: url) {
            let img =  UIImage(data: data, scale: 7)
            return img
        }
        return nil
    }
}

// MARK: - Date extension
extension Date {
    func formatString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
