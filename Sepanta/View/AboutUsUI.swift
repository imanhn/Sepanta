//
//  AboutUsUI.swift
//  Sepanta
//
//  Created by Iman on 12/16/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//


import Foundation
import UIKit

//extension  GetRichViewController {
class AboutUsUI {
    var delegate : AboutUsViewController!
    var submitButton = UIButton(type: .custom)
    
    init() {
    }
    
    //Create Gradient on PageView
    func showAboutUs(_ avc : AboutUsViewController) {
        self.delegate = avc

        
        var cursurY : CGFloat = 0
        let marginY : CGFloat = (UIScreen.main.bounds.width / 6)  //10
        let gradient = CAGradientLayer()
        gradient.frame = self.delegate.view.bounds
        gradient.colors = [UIColor(hex: 0xF7F7F7).cgColor, UIColor.white.cgColor]
        self.delegate.scrollView.layer.insertSublayer(gradient, at: 0)
        
        let backgroundFormView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2))
        backgroundFormView.layer.insertSublayer(gradient, at: 0)
        self.delegate.scrollView.addSubview(backgroundFormView)
        self.delegate.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height * 2)+40)
        cursurY = cursurY + marginY
        
        
        let logo = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width/3, y: cursurY, width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3))
        logo.image = UIImage(named: "logo_shape")
        logo.contentMode = .scaleAspectFit
        self.delegate.scrollView.addSubview(logo)
        cursurY = cursurY + UIScreen.main.bounds.width/3 + marginY
        
        
        self.delegate.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: cursurY*1.2)

    }
    
}
