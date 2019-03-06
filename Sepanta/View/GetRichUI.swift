//
//  GetRichUI.swift
//  Sepanta
//
//  Created by Iman on 12/15/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

extension  GetRichViewController {
    
    //Create Gradient on PageView
    @objc func resellerRequestTapped(_ sender : Any?) {
        if leftFormView != nil && leftFormView.superview != nil { leftFormView.removeFromSuperview()}
        var cursurY : CGFloat = 0
        let marginY : CGFloat = 10
        let marginX : CGFloat = 20
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor(hex: 0xF7F7F7).cgColor, UIColor.white.cgColor]
        self.scrollView.layer.insertSublayer(gradient, at: 0)

        let backgroundFormView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2))
        backgroundFormView.layer.insertSublayer(gradient, at: 0)
        self.scrollView.addSubview(backgroundFormView)
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height * 2)+40)
        
        rightFormView = RightTabbedViewWithWhitePanel(frame: CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width-40, height: UIScreen.main.bounds.height * 2))
        rightFormView.backgroundColor = UIColor.clear
        
        
        let buttonsFont = UIFont(name: "Shabnam-Bold-FD", size: 14)
        let buttonHeight = rightFormView.getHeight()
        let textFieldWidth = rightFormView.bounds.width - (2 * marginX)
        
        leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: rightFormView.bounds.width/2, height: buttonHeight))
        leftButton.setTitle("درخواست کارت", for: .normal)
        leftButton.titleLabel?.font = buttonsFont
        leftButton.addTarget(self, action: #selector(self.cardRequestTapped(_:)), for: .touchUpInside)
        leftButton.setTitleColor(UIColor(hex: 0x515152), for: .normal)

        rightButton = UIButton(frame: CGRect(x: rightFormView.bounds.width/2, y: 0, width: rightFormView.bounds.width/2, height: buttonHeight))
        rightButton.setTitle("درخواست فروشندگی", for: .normal)
        rightButton.titleLabel?.font = buttonsFont
        rightButton.setTitleColor(UIColor(hex: 0x515152), for: .normal)
        
        rightFormView.addSubview(leftButton)
        rightFormView.addSubview(rightButton)
        cursurY = cursurY + rightFormView.getHeight() + marginY
        
        let shopView = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_01", Selectable: false, PlaceHolderText: "نام فروشگاه")
        rightFormView.addSubview(shopView)
        cursurY = cursurY + rightFormView.getHeight() + marginY
        
        let serviceView = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_02", Selectable: true, PlaceHolderText: "نوع خدمت")
        rightFormView.addSubview(serviceView)
        cursurY = cursurY + rightFormView.getHeight() + marginY
        
        let familyView = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: (textFieldWidth / 2)-(marginX/4), height: buttonHeight), Image: "icon_profile_04", Selectable: false, PlaceHolderText: "نام خانوادگی")
        rightFormView.addSubview(familyView)
        let nameView = buildARowView(CGRect: CGRect(x: (textFieldWidth / 2)+(marginX/4)+marginX, y: cursurY, width: (textFieldWidth / 2)-marginX/4, height: buttonHeight), Image: "icon_profile_03", Selectable: false, PlaceHolderText: "نام")
        rightFormView.addSubview(nameView)
        cursurY = cursurY + rightFormView.getHeight() + marginY

        let locationView = buildARowView(CGRect: CGRect(x: marginX+buttonHeight+marginX, y: cursurY, width: textFieldWidth-(buttonHeight+marginX), height: buttonHeight), Image: "icon_profile_05", Selectable: true, PlaceHolderText: "محدوده")
        rightFormView.addSubview(locationView)
        let locationButton = RoundedButton(frame: CGRect(x: marginX, y: cursurY, width: buttonHeight, height: buttonHeight))
        locationButton.setImage(UIImage(named: "icon_profile_06"), for: .normal)
        rightFormView.addSubview(locationButton)
        cursurY = cursurY + rightFormView.getHeight() + marginY

        let mobileNoView = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_07", Selectable: false, PlaceHolderText: "شماره همراه")
        rightFormView.addSubview(mobileNoView)
        cursurY = cursurY + rightFormView.getHeight() + marginY

        let discountRateView = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_08", Selectable: false, PlaceHolderText: "درصد تخفیف پیشنهادی")
        rightFormView.addSubview(discountRateView)
        cursurY = cursurY + rightFormView.getHeight() + (2 * marginY)

        awareCheckButton = UIButton(type: .custom)
        awareCheckButton.frame = CGRect(x: marginX+textFieldWidth-buttonHeight, y: cursurY, width: buttonHeight, height: buttonHeight)
        awareCheckButton.backgroundColor = UIColor(hex: 0xD6D7D9)
        awareCheckButton.setImage(UIImage(named: "icon_tick_white"), for: .normal)
        awareCheckButton.contentMode = .scaleAspectFit
        awareCheckButton.addTarget(self, action: #selector(self.awareButtonTapped(_:)), for: .touchUpInside)
        rightFormView.addSubview(awareCheckButton)
        
        awareLabel = UILabel(frame: CGRect(x: marginX, y: cursurY, width: textFieldWidth-buttonHeight-(marginX/2), height: buttonHeight))
        awareLabel?.textColor = UIColor(hex: 0xD6D7D9)
        awareLabel?.text = "آیا فروشگاه آگاه است"
        awareLabel?.textAlignment = .right
        awareLabel?.font = UIFont(name: "Shabnam-FD", size: 14)
        rightFormView.addSubview(awareLabel!)
        cursurY = cursurY + rightFormView.getHeight() + (1 * marginY)
        
        termsCheckButton = UIButton(type: .custom)
        termsCheckButton.frame = CGRect(x: marginX+textFieldWidth-buttonHeight, y: cursurY, width: buttonHeight, height: buttonHeight)
        termsCheckButton.backgroundColor = UIColor(hex: 0xD6D7D9)
        termsCheckButton.setImage(UIImage(named: "icon_tick_white"), for: .normal)
        termsCheckButton.contentMode = .scaleAspectFit
        termsCheckButton.addTarget(self, action: #selector(self.termsButtonTapped(_:)), for: .touchUpInside)
        rightFormView.addSubview(termsCheckButton)
        termsLabel = UILabel(frame: CGRect(x: marginX, y: cursurY, width: textFieldWidth-buttonHeight-(marginX/2), height: buttonHeight))
        termsLabel?.textColor = UIColor(hex: 0xD6D7D9)
        termsLabel?.text = "قوانین و مقررات را خوانده ام و موافقم"
        termsLabel?.textAlignment = .right
        termsLabel?.font = UIFont(name: "Shabnam-FD", size: 14)
        rightFormView.addSubview(termsLabel!)
        cursurY = cursurY + rightFormView.getHeight() + buttonHeight*2/3
        
        let submitButton = RoundedButton(type: .custom)
        submitButton.frame = CGRect(x: marginX+(textFieldWidth/2)-1.5*buttonHeight, y: cursurY, width: 3*buttonHeight, height: buttonHeight)
        //submitButton.backgroundColor = UIColor.white
        submitButton.setTitleColor(UIColor(hex: 0xD6D7D9), for: .normal)
        submitButton.setTitle("ارسال", for: .normal)
        submitButton.semanticContentAttribute = .forceRightToLeft
        submitButton.titleLabel?.font = UIFont(name: "Shabnam-FD", size: 16)
        submitButton.setImage(UIImage(named: "icon_tick_black"), for: .normal)
        submitButton.contentMode = .scaleAspectFit
        submitButton.imageEdgeInsets = UIEdgeInsetsMake(0, buttonHeight/2, 0, 0)
        rightFormView.addSubview(submitButton)
        cursurY = cursurY + rightFormView.getHeight() + (1 * marginY)
        
        let formSize = CGSize(width: UIScreen.main.bounds.width, height: cursurY*1.2)
        self.scrollView.contentSize = formSize
        rightFormView.frame = CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width-40, height: cursurY*1.2)
        self.scrollView.addSubview(rightFormView)
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
        anIcon.contentMode = .scaleAspectFit
        
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
    
    @objc func termsButtonTapped(_ sender : Any){
        termsAgreed = !termsAgreed
        if termsAgreed {
            termsCheckButton.setImage(UIImage(named: "icon_tik_dark"), for: UIControlState.normal)
            termsLabel?.textColor = UIColor(hex: 0x515152)
        } else {
            termsCheckButton.setImage(UIImage(named: "icon_tick_white"), for: .normal)
            termsLabel?.textColor = UIColor(hex: 0xD6D7D9)
        }
    }
    
    @objc func awareButtonTapped(_ sender : Any) {
        shopAwareness = !shopAwareness
        if shopAwareness {
            awareCheckButton.setImage(UIImage(named: "icon_tik_dark"), for: UIControlState.normal)
            awareLabel?.textColor = UIColor(hex: 0x515152)
        } else {
            awareCheckButton.setImage(UIImage(named: "icon_tick_white"), for: .normal)
            awareLabel?.textColor = UIColor(hex: 0xD6D7D9)
        }
    }
    
    @objc func cardRequestTapped(_ sender : Any?) {
        if rightFormView != nil && rightFormView.superview != nil { rightFormView.removeFromSuperview()}
        var cursurY : CGFloat = 0
        let marginY : CGFloat = 10
        let marginX : CGFloat = 20
        leftFormView = LeftTabbedViewWithWhitePanel(frame: CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width-40, height: UIScreen.main.bounds.height * 1))
        leftFormView.backgroundColor = UIColor.clear
        
        
        let buttonsFont = UIFont(name: "Shabnam-Bold-FD", size: 14)
        let buttonHeight = leftFormView.getHeight()
        let textFieldWidth = leftFormView.bounds.width - (2 * marginX)
        
        leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: leftFormView.bounds.width/2, height: buttonHeight))
        leftButton.setTitle("درخواست کارت", for: .normal)
        leftButton.titleLabel?.font = buttonsFont
        //leftButton.addTarget(self, action: #selector(self.cardRequestTapped(_:)), for: .touchUpInside)
        leftButton.setTitleColor(UIColor(hex: 0x515152), for: .normal)
        leftFormView.addSubview(leftButton)
        
        rightButton = UIButton(frame: CGRect(x: leftFormView.bounds.width/2, y: 0, width: leftFormView.bounds.width/2, height: buttonHeight))
        rightButton.setTitle("درخواست فروشندگی", for: .normal)
        rightButton.titleLabel?.font = buttonsFont
        rightButton.addTarget(self, action: #selector(self.resellerRequestTapped(_:)), for: .touchUpInside)
        rightButton.setTitleColor(UIColor(hex: 0x515152), for: .normal)
        
        leftFormView.addSubview(rightButton)
        cursurY = cursurY + leftFormView.getHeight() + marginY
        
        let familyView = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: (textFieldWidth / 2)-(marginX/4), height: buttonHeight), Image: "icon_profile_04", Selectable: false, PlaceHolderText: "نام خانوادگی")
        leftFormView.addSubview(familyView)
        let nameView = buildARowView(CGRect: CGRect(x: (textFieldWidth / 2)+(marginX/4)+marginX, y: cursurY, width: (textFieldWidth / 2)-marginX/4, height: buttonHeight), Image: "icon_profile_03", Selectable: false, PlaceHolderText: "نام")
        leftFormView.addSubview(nameView)
        cursurY = cursurY + leftFormView.getHeight() + marginY

        let nationalCodeView = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "identity-card", Selectable: false, PlaceHolderText: "کد ملی")
        leftFormView.addSubview(nationalCodeView)
        cursurY = cursurY + leftFormView.getHeight() + marginY

        let birthDateView = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "calendar-page-empty", Selectable: false, PlaceHolderText: "تاریخ تولد")
        leftFormView.addSubview(birthDateView)
        cursurY = cursurY + leftFormView.getHeight() + marginY

        let genderView = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "genders", Selectable: true, PlaceHolderText: "جنسیت")
        leftFormView.addSubview(genderView)
        cursurY = cursurY + leftFormView.getHeight() + marginY

        let maritalStatusView = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "marriage-rings-couple-with-a-heart", Selectable: true, PlaceHolderText: "وضعیت تاهل")
        leftFormView.addSubview(maritalStatusView)
        cursurY = cursurY + leftFormView.getHeight() + marginY

        let mobileNoView = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_07", Selectable: false, PlaceHolderText: "شماره همراه")
        leftFormView.addSubview(mobileNoView)
        cursurY = cursurY + leftFormView.getHeight() + marginY

        let emailView = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "black-back-closed-envelope-shape", Selectable: false, PlaceHolderText: "ایمیل")
        leftFormView.addSubview(emailView)
        cursurY = cursurY + leftFormView.getHeight() + marginY

        let stateView = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "map", Selectable: true, PlaceHolderText: "استان")
        leftFormView.addSubview(stateView)
        cursurY = cursurY + leftFormView.getHeight() + marginY

        let cityView = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "NOIMAGE", Selectable: true, PlaceHolderText: "شهر")
        leftFormView.addSubview(cityView)
        cursurY = cursurY + leftFormView.getHeight() + marginY

        let regionView = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "NOIMAGE", Selectable: true, PlaceHolderText: "منطقه")
        leftFormView.addSubview(regionView)
        cursurY = cursurY + leftFormView.getHeight() + marginY

        let orgView = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "three-buildings", Selectable: false, PlaceHolderText: "نام سازمان")
        leftFormView.addSubview(orgView)
        cursurY = cursurY + leftFormView.getHeight() + marginY

        let cardNoView = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "credit-card", Selectable: false, PlaceHolderText: "شماره کارت")
        leftFormView.addSubview(cardNoView)
        cursurY = cursurY + leftFormView.getHeight() + marginY

        let bankView = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "bank-building", Selectable: false, PlaceHolderText: "بانک")
        leftFormView.addSubview(bankView)
        cursurY = cursurY + leftFormView.getHeight() + marginY

        termsCheckButton = UIButton(type: .custom)
        termsCheckButton.frame = CGRect(x: marginX+textFieldWidth-buttonHeight, y: cursurY, width: buttonHeight, height: buttonHeight)
        termsCheckButton.backgroundColor = UIColor(hex: 0xD6D7D9)
        termsCheckButton.setImage(UIImage(named: "icon_tick_white"), for: .normal)
        termsCheckButton.contentMode = .scaleAspectFit
        termsCheckButton.addTarget(self, action: #selector(self.termsButtonTapped(_:)), for: .touchUpInside)
        leftFormView.addSubview(termsCheckButton)
        termsLabel = UILabel(frame: CGRect(x: marginX, y: cursurY, width: textFieldWidth-buttonHeight-(marginX/2), height: buttonHeight))
        termsLabel?.textColor = UIColor(hex: 0xD6D7D9)
        termsLabel?.text = "قوانین و مقررات را خوانده ام و موافقم"
        termsLabel?.textAlignment = .right
        termsLabel?.font = UIFont(name: "Shabnam-FD", size: 14)
        leftFormView.addSubview(termsLabel!)
        cursurY = cursurY + leftFormView.getHeight() + buttonHeight*2/3

        let submitButton = RoundedButton(type: .custom)
        submitButton.frame = CGRect(x: marginX+(textFieldWidth/2)-1.5*buttonHeight, y: cursurY, width: 3*buttonHeight, height: buttonHeight)
        //submitButton.backgroundColor = UIColor.white
        submitButton.setTitleColor(UIColor(hex: 0xD6D7D9), for: .normal)
        submitButton.setTitle("ارسال", for: .normal)
        submitButton.semanticContentAttribute = .forceRightToLeft
        submitButton.titleLabel?.font = UIFont(name: "Shabnam-FD", size: 16)
        submitButton.setImage(UIImage(named: "icon_tick_black"), for: .normal)
        submitButton.contentMode = .scaleAspectFit
        submitButton.imageEdgeInsets = UIEdgeInsetsMake(0, buttonHeight/2, 0, 0)
        leftFormView.addSubview(submitButton)
        cursurY = cursurY + leftFormView.getHeight() + (1 * marginY)
        
        let formSize = CGSize(width: UIScreen.main.bounds.width, height: cursurY*1.2)
        self.scrollView.contentSize = formSize
        leftFormView.frame = CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width-40, height: cursurY*1.2)
        self.scrollView.addSubview(leftFormView)

        print("Left First Item : ",leftFormView.subviews.first)
        
    }
}
