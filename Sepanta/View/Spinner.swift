//
//  Spinner.swift
//  Sepanta
//
//  Created by Iman on 11/27/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

open class Spinner {
    internal static var spinner: UIActivityIndicatorView?
    open static var style: UIActivityIndicatorViewStyle = .whiteLarge
    open static var baseBackColor = UIColor(white: 0, alpha: 0.6)
    open static var baseColor = UIColor.init(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.0)
    
    open static func start() {
        if spinner == nil, let window = UIApplication.shared.keyWindow {
            let frame = UIScreen.main.bounds
            spinner = UIActivityIndicatorView(frame: frame)
            spinner!.activityIndicatorViewStyle = self.style
            spinner?.color = self.baseColor
            window.addSubview(spinner!)
            spinner!.startAnimating()
        }
    }
    
    open static func stop() {
        if spinner != nil {
            spinner!.stopAnimating()
            spinner!.removeFromSuperview()
            spinner = nil
        }
    }
        
}
