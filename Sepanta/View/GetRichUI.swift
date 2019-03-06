//
//  GetRichUI.swift
//  Sepanta
//
//  Created by Iman on 12/15/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

class GetRichUI {
    var delegate : GetRichViewController
    init(_ getRichViewController : GetRichViewController) {
        self.delegate = getRichViewController
        createUI()
    }
    
    //Create Gradient on PageView
    func createUI() {
        var cursurY : CGFloat = 0
        var marginY : CGFloat = 10
        var marginX : CGFloat = 20
        let gradient = CAGradientLayer()
        gradient.frame = self.delegate.view.bounds
        gradient.colors = [UIColor(hex: 0xF7F7F7).cgColor, UIColor.white.cgColor]
        self.delegate.scrollView.layer.insertSublayer(gradient, at: 0)

        let backgroundFormView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2))
        backgroundFormView.layer.insertSublayer(gradient, at: 0)
        self.delegate.scrollView.addSubview(backgroundFormView)
        self.delegate.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height * 2)+40)
        
        let formView = RightTabbedViewWithWhitePanel(frame: CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width-40, height: UIScreen.main.bounds.height * 2))
        formView.backgroundColor = UIColor.clear
        
        
        let buttonsFont = UIFont(name: "Shabnam-Bold-FD", size: 14)
        let buttonHeight = formView.getHeight()
        let textFieldWidth = formView.bounds.width - (2 * marginX)
        
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: formView.bounds.width/2, height: buttonHeight))
        leftButton.setTitle("درخواست کارت", for: .normal)
        leftButton.titleLabel?.font = buttonsFont
        leftButton.setTitleColor(UIColor(hex: 0x515152), for: .normal)

        let rightButton = UIButton(frame: CGRect(x: formView.bounds.width/2, y: 0, width: formView.bounds.width/2, height: buttonHeight))
        rightButton.setTitle("درخواست فروشندگی", for: .normal)
        rightButton.titleLabel?.font = buttonsFont
        rightButton.setTitleColor(UIColor(hex: 0x515152), for: .normal)
        
        formView.addSubview(leftButton)
        formView.addSubview(rightButton)
        cursurY = cursurY + formView.getHeight() + marginY
        
        let shopView = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_01", Selectable: false, PlaceHolderText: "نام فروشگاه")
        formView.addSubview(shopView)
        cursurY = cursurY + formView.getHeight() + marginY
        
        let serviceView = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_02", Selectable: true, PlaceHolderText: "نوع خدمت")
        formView.addSubview(serviceView)
        cursurY = cursurY + formView.getHeight() + marginY
        
        let familyView = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: (textFieldWidth / 2)-(marginX/4), height: buttonHeight), Image: "icon_profile_04", Selectable: false, PlaceHolderText: "نام خانوادگی")
        formView.addSubview(familyView)
        let nameView = buildARowView(CGRect: CGRect(x: (textFieldWidth / 2)+(marginX/4)+marginX, y: cursurY, width: (textFieldWidth / 2)-marginX/4, height: buttonHeight), Image: "icon_profile_03", Selectable: false, PlaceHolderText: "نام")
        formView.addSubview(nameView)
        cursurY = cursurY + formView.getHeight() + marginY

        let locationView = buildARowView(CGRect: CGRect(x: marginX+buttonHeight+marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_05", Selectable: true, PlaceHolderText: "محدوده")
        formView.addSubview(locationView)
        cursurY = cursurY + formView.getHeight() + marginY

        
        self.delegate.scrollView.addSubview(formView)
    }
    
    func buildARowView(CGRect rect : CGRect,Image anImageName : String,Selectable selectable:Bool,PlaceHolderText aPlaceHolder : String)->UIView{
        let aView = UIView(frame: rect)
        let lineView = UIView(frame: CGRect(x: 0, y: rect.height-1, width: rect.width, height: 1))
        lineView.backgroundColor = UIColor(hex: 0xD6D7D9)
        aView.addSubview(lineView)
        
        aView.backgroundColor = UIColor.white
        let icondim = rect.height / 3
        let spaceIconText : CGFloat = 20
        let imageRect = CGRect(x: (rect.width-icondim), y: (rect.height - icondim)/2, width: icondim, height: icondim)
        let anIcon = UIImageView(frame: imageRect)
        anIcon.image = UIImage(named: anImageName)
        
        let aText = EmptyTextField(frame: CGRect(x: 0, y: 0, width: (rect.width-icondim-spaceIconText), height: rect.height))
        aText.font = UIFont(name: "Shabnam-FD", size: 14)
        aText.attributedPlaceholder = NSAttributedString(string: aPlaceHolder , attributes: [NSAttributedStringKey.foregroundColor: UIColor(hex: 0xD6D7D9)])
        aText.textAlignment = .right
        if selectable {
            let triangleImage = UIImageView(frame: CGRect(x: 0, y: rect.height*3/4 - 5, width: rect.height/4, height: rect.height/4))
            triangleImage.image = UIImage(named: "icon_dropdown_red")
            aView.addSubview(triangleImage)
        }
        aView.addSubview(aText)
        aView.addSubview(anIcon)
        
        return aView
    }
}
