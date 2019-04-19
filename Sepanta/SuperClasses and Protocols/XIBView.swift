//
//  XIBView.swift
//  Sepanta
//
//  Created by Iman on 1/28/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

protocol XIBView {
    static func instantiate() -> Self
}

extension XIBView where Self: UIViewController {
    static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        
        /*
        let vc = Bundle.main.loadNibNamed(className, owner: nil, options: nil)?.first as? Self
        return vc!
        */
        
        let anib = UINib(nibName: className, bundle: nil)
        let vc = anib.instantiate(withOwner: self, options: nil)[0] as! Self
        return vc
        
    }
}
