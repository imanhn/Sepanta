//
//  UIButtonDisEnable.swift
//  Sepanta
//
//  Created by Iman on 1/27/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func setEnable() {
        self.isEnabled = true
        self.backgroundColor = UIColor(hex: 0x515152)
    }

    func setDisable() {
        self.isEnabled = false
        self.backgroundColor = UIColor(hex: 0xD6D7D9)
    }

}
