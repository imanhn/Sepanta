//
//  UIColorFromHex.swift
//  Sepanta
//
//  Created by Iman on 12/11/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue: CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }

}
