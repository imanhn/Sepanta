//
//  Alert.swift
//  Sepanta
//
//  Created by Iman on 12/16/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

class UIButtonWithTargetAction : UIButton{
    var targetAction : (()->Void) = {}
    @objc func runTargetAction(){
        targetAction()
    }
}

extension UIViewController {
 typealias actionFunction = ()->Void
    func alert(Message str : String, completion anAction :@escaping actionFunction={} ){
        if str.count == 0 {return}
        let textFont = UIFont (name: "Shabnam FD", size: 13)!
        let aView = UIView(frame: CGRect(x: -self.view.frame.width, y: self.view.frame.height*0.4, width: self.view.frame.width, height: self.view.frame.height*0.06))
        aView.backgroundColor = UIColor(hex: 0xDA3A5C)
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
                anAction()
            }
        })
    }
    

    func showQuestion(Message aMessage : String,OKLabel okLabel : String, CancelLabel cancelLabel : String, OkAction : @escaping actionFunction={},  CancelAction : @escaping actionFunction={}){
        for av in self.view.subviews{
            if av.tag == 123 {
                return
            }
        }
        let marginX = self.view.frame.width / 30
        let textFont = UIFont (name: "Shabnam FD", size: 13)!
        let aView = UIView(frame: CGRect(x: marginX, y: self.view.frame.height*0.4, width: self.view.frame.width-2*marginX, height: self.view.frame.height*0.1))
        aView.backgroundColor = UIColor(hex: 0xDA3A5C)
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
        let aButton = UIButtonWithTargetAction(frame: CGRect(x: buttonWidth, y: aView.frame.height*0.5, width: buttonWidth, height: aView.frame.height*0.4))
        aButton.setTitle(okLabel, for: .normal)
        aButton.titleLabel?.textColor = UIColor.white
        aButton.titleLabel?.font = textFont
        aButton.layer.cornerRadius = 4
        aButton.layer.borderWidth = 1
        aButton.layer.borderColor = UIColor.white.cgColor
        aButton.targetAction = OkAction
        //aButton.addTarget(self, action: #selector(okPressed), for: .touchUpInside)
        aButton.addTarget(self, action:#selector(runAction), for: .touchUpInside)
        aView.addSubview(aButton)

        let bButton = UIButtonWithTargetAction(frame: CGRect(x: buttonWidth*3, y: aView.frame.height*0.5, width: buttonWidth, height: aView.frame.height*0.4))
        bButton.setTitle(cancelLabel, for: .normal)
        bButton.titleLabel?.textColor = UIColor.white
        bButton.layer.cornerRadius = 4
        bButton.layer.borderWidth = 1
        bButton.layer.borderColor = UIColor.white.cgColor
        bButton.targetAction = CancelAction
        bButton.addTarget(self, action: #selector(runAction), for: .touchUpInside)
        bButton.titleLabel?.font = textFont
        aView.addSubview(bButton)

    }
    @objc func runAction(_ sender : UIButton){
        if let abutton = sender as? UIButtonWithTargetAction {
            abutton.runTargetAction()
            abutton.superview?.removeFromSuperview()
        }
    }
    func showDarkQuestion(Message aMessage : String,OKLabel okLabel : String, CancelLabel cancelLabel : String, OkAction : @escaping actionFunction={},  CancelAction : @escaping actionFunction={}){
        for av in self.view.subviews{
            if av.tag == 123 {
                return
            }
        }
        let offsetY = (self.view.frame.height) / 4
        let offsetX : CGFloat = 20
        let w = self.view.frame.width - (2 * offsetX)
        let h = (w/2)*0.8
        let aframe = CGRect(x: offsetX, y: offsetY, width:w, height: h)

        let contentView = UIView(frame: aframe)
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor(hex: 0xF7F7F7)
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize(width: 3, height: 3)
        contentView.layer.shadowRadius = 5
        self.view.addSubview(contentView)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: contentView.frame.height/7, width: contentView.frame.width, height: contentView.frame.height*2/7))
        titleLabel.text = aMessage
        titleLabel.font = UIFont(name: "Shabnam FD", size: 13)
        titleLabel.textColor = UIColor(hex: 0x515152)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        
        let yesButton = RoundedButtonWithDarkBackground(type: .custom)
        yesButton.frame = CGRect(x: contentView.frame.width/10, y: contentView.frame.height*4/7, width: contentView.frame.width*3/10, height: contentView.frame.height*2/7)
        contentView.addSubview(yesButton)
        yesButton.setTitle(okLabel, for: .normal)
        yesButton.setTitleColor(UIColor.white, for: .normal)
        yesButton.titleLabel?.font = UIFont(name: "Shabnam FD", size: 12)
        yesButton.addTarget(self, action: #selector(runAction(_:)), for: .touchUpInside)
        yesButton.targetAction = OkAction
        
        let noButton = RoundedButtonWithDarkBackground(type: .custom)
        noButton.frame = CGRect(x: contentView.frame.width*6/10, y: contentView.frame.height*4/7, width: contentView.frame.width*3/10, height: contentView.frame.height*2/7)
        contentView.addSubview(noButton)
        noButton.setTitle(cancelLabel, for: .normal)
        noButton.setTitleColor(UIColor.white, for: .normal)
        noButton.titleLabel?.font = UIFont(name: "Shabnam FD", size: 12)
        noButton.addTarget(self, action: #selector(runAction(_:)), for: .touchUpInside)
        noButton.targetAction = CancelAction
        
    }
    
    func showAlertWithOK(Message aMessage : String,OKLabel okLabel : String,Completion anAction: @escaping actionFunction={}){
        for av in self.view.subviews{
            if av.tag == 123 {
                return
            }
        }
        let marginX = self.view.frame.width / 30
        let textFont = UIFont (name: "Shabnam FD", size: 13)!
        let aView = UIView(frame: CGRect(x: marginX, y: self.view.frame.height*0.4, width: self.view.frame.width-2*marginX, height: self.view.frame.height*0.2))
        aView.backgroundColor = UIColor(hex: 0x96336C)
        aView.tag = 123
        aView.layer.cornerRadius = 5
        aView.layer.borderColor = UIColor.white.cgColor
        aView.layer.borderWidth = 1
        aView.layer.shadowColor = UIColor.black.cgColor
        aView.layer.shadowOffset = CGSize(width: 2, height: 3)
        aView.layer.shadowOpacity = 0.3
        self.view.addSubview(aView)
        let aLabel = UILabel(frame: CGRect(x: marginX, y: aView.frame.height*0.1, width: aView.frame.width-2*marginX, height: aView.frame.height*0.4))
        aLabel.text = aMessage
        aLabel.font = textFont
        aLabel.numberOfLines = 3
        aLabel.semanticContentAttribute = .forceRightToLeft
        aLabel.textAlignment = .right
        aLabel.textColor = UIColor.white
        aView.addSubview(aLabel)
        let buttonWidth = aView.frame.width / 3
        let aButton = UIButtonWithTargetAction(frame: CGRect(x: (aView.frame.width-buttonWidth)/2, y: aView.frame.height*0.55, width: buttonWidth, height: aView.frame.height*0.35))
        aButton.setTitle(okLabel, for: .normal)
        aButton.titleLabel?.textColor = UIColor.white
        aButton.titleLabel?.font = textFont
        aButton.layer.cornerRadius = 4
        aButton.layer.borderWidth = 1
        aButton.layer.borderColor = UIColor.white.cgColor
        aButton.targetAction = anAction
        aButton.addTarget(self, action: #selector(runAction(_:)), for: .touchUpInside)
        aView.addSubview(aButton)
        
    }

}
