//
//  UIResponder.swift
//  Sepanta
//
//  Created by Iman on 4/1/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

extension UIResponder {
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
