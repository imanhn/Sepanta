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
        let textFont = UIFont (name: "Shabnam FD", size: 13)!
        let aView = UIView(frame: CGRect(x: -self.view.frame.width, y: self.view.frame.height*0.4, width: self.view.frame.width, height: self.view.frame.height*0.06))
        aView.backgroundColor = UIColor(hex: 0x96336C)
        self.view.addSubview(aView)
        let aLabel = UILabel(frame: CGRect(x: 0, y: aView.frame.height*0.1, width: aView.frame.width, height: aView.frame.height*0.8))
        aLabel.text = str
        aLabel.font = textFont
        //aLabel.semanticContentAttribute = .forceRightToLeft
        aLabel.textAlignment = .center
        aLabel.textColor = UIColor(hex: 0xF7F7F7)
        aView.addSubview(aLabel)
        UIView.animate(withDuration: 0.3, animations: {
            //print("Animating Alert")
            aView.frame = CGRect(x: 0, y: self.view.frame.height*0.4, width: self.view.frame.width, height: self.view.frame.height*0.06)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            UIView.animate(withDuration: 0.3, animations: {
                aView.frame = CGRect(x: self.view.frame.width, y: self.view.frame.height*0.4, width: self.view.frame.width, height: self.view.frame.height*0.06)
            }){ _ in
                aView.removeFromSuperview()
            }
        })
    }
}
