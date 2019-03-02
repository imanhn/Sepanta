//
//  MenuViewController.swift
//  Sepanta
//
//  Created by Iman on 12/12/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//
import UIKit
import Foundation

private extension UIStoryboard {
    
    static func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    /*
    static func rightViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "RightViewController") as? SidePanelViewController
    }
    
    static func centerViewController() -> CenterViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "CenterViewController") as? CenterViewController
    }
 */
}
