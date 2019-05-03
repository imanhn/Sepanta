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
 typealias actionFunction = ()->Void
    func alert(Message str : String){
        if str.count == 0 {return}
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
    
    @objc func okPressed(_ sender : Any){
        fatalError()
    }
    
    @objc func cancelPressed(_ sender : Any){
        if let cancelButton = sender as? UIButton {
            cancelButton.superview?.removeFromSuperview()
        }
    }
    
    func showQuestion(Message aMessage : String,OKLabel okLabel : String, CancelLabel cancelLabel : String,QuestionTag atag : Int){
        for av in self.view.subviews{
            if av.tag == 123 {
                return
            }
        }
        let marginX = self.view.frame.width / 30
        let textFont = UIFont (name: "Shabnam FD", size: 13)!
        let aView = UIView(frame: CGRect(x: marginX, y: self.view.frame.height*0.4, width: self.view.frame.width-2*marginX, height: self.view.frame.height*0.1))
        aView.backgroundColor = UIColor(hex: 0x96336C)
        aView.tag = 123
        aView.layer.cornerRadius = 5
        aView.layer.borderColor = UIColor.white.cgColor
        aView.layer.borderWidth = 1
        aView.layer.shadowColor = UIColor.black.cgColor
        aView.layer.shadowOffset = CGSize(width: 2, height: 3)
        aView.layer.shadowOpacity = 0.3
        self.view.addSubview(aView)
        let aLabel = UILabel(frame: CGRect(x: marginX, y: aView.frame.height*0.1, width: aView.frame.width-2*marginX, height: aView.frame.height*0.3))
        aLabel.text = aMessage
        aLabel.font = textFont
        aLabel.semanticContentAttribute = .forceRightToLeft
        aLabel.textAlignment = .right
        aLabel.textColor = UIColor.white
        aView.addSubview(aLabel)
        let buttonWidth = aView.frame.width / 5
        let aButton = UIButton(frame: CGRect(x: buttonWidth, y: aView.frame.height*0.5, width: buttonWidth, height: aView.frame.height*0.4))
        aButton.setTitle(okLabel, for: .normal)
        aButton.titleLabel?.textColor = UIColor.white
        aButton.titleLabel?.font = textFont
        aButton.tag = atag
        aButton.layer.cornerRadius = 4
        aButton.layer.borderWidth = 1
        aButton.layer.borderColor = UIColor.white.cgColor

        aButton.addTarget(self, action: #selector(okPressed), for: .touchUpInside)
        aView.addSubview(aButton)

        let bButton = UIButton(frame: CGRect(x: buttonWidth*3, y: aView.frame.height*0.5, width: buttonWidth, height: aView.frame.height*0.4))
        bButton.setTitle(cancelLabel, for: .normal)
        bButton.titleLabel?.textColor = UIColor.white
        bButton.layer.cornerRadius = 4
        bButton.layer.borderWidth = 1
        bButton.layer.borderColor = UIColor.white.cgColor
        bButton.addTarget(self, action: #selector(cancelPressed(_:)), for: .touchUpInside)
        bButton.titleLabel?.font = textFont
        aView.addSubview(bButton)

    }
}
