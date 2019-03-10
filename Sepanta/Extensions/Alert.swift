//
//  Alert.swift
//  Sepanta
//
//  Created by Iman on 12/16/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    func alert(Message str : String){
        let alert = UIAlertController(title: "توجه", message: str, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "بلی", style: .default))
        self.present(alert, animated: true, completion: nil)
    }

}
