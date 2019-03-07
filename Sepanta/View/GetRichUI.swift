//
//  GetRichUI.swift
//  Sepanta
//
//  Created by Iman on 12/15/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

//extension  GetRichViewController {
class GetRichUI {
    var delegate : GetRichViewController!
    var views = Dictionary<String,UIView>()
    var texts = Dictionary<String,UITextField>()
    var labels = Dictionary<String,UILabel>()
    var buttons = Dictionary<String,UIButton>()
    var awareCheckButton = UIButton(type: .custom)
    var termsCheckButton = UIButton(type: .custom)
    var termsAgreed : Bool = false
    var shopAwareness : Bool = false
    var submitButton = UIButton(type: .custom)

    init() {
    }
    
    //Create Gradient on PageView
    func showResellerRequest(_ avc : GetRichViewController) {
        self.delegate = avc
        //print("reseller Request : ",views["leftFormView"] ?? "Nil")
        if views["leftFormView"] != nil && views["leftFormView"]?.superview != nil { views["leftFormView"]?.removeFromSuperview()}
        var cursurY : CGFloat = 0
        let marginY : CGFloat = 10
        let marginX : CGFloat = 20
        let gradient = CAGradientLayer()
        gradient.frame = self.delegate.view.bounds
        gradient.colors = [UIColor(hex: 0xF7F7F7).cgColor, UIColor.white.cgColor]
        self.delegate.scrollView.layer.insertSublayer(gradient, at: 0)

        let backgroundFormView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2))
        backgroundFormView.layer.insertSublayer(gradient, at: 0)
        self.delegate.scrollView.addSubview(backgroundFormView)
        self.delegate.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height * 2)+40)
        
        views["rightFormView"] = RightTabbedViewWithWhitePanel(frame: CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width-40, height: UIScreen.main.bounds.height * 2))
        views["rightFormView"]?.backgroundColor = UIColor.clear
        
        
        let buttonsFont = UIFont(name: "Shabnam-Bold-FD", size: 14)
        let buttonHeight = (views["rightFormView"] as! RightTabbedViewWithWhitePanel).getHeight()
        let textFieldWidth = (views["rightFormView"]?.bounds.width)! - (2 * marginX)
        
        buttons["leftButton"] = UIButton(frame: CGRect(x: 0, y: 0, width: (views["rightFormView"]?.bounds.width)!/2, height: buttonHeight))
        buttons["leftButton"]!.setTitle("درخواست کارت", for: .normal)
        buttons["leftButton"]!.titleLabel?.font = buttonsFont
        buttons["leftButton"]!.addTarget(self.delegate, action: #selector(self.delegate.cardRequestTapped), for: .touchUpInside)
        buttons["leftButton"]!.setTitleColor(UIColor(hex: 0x515152), for: .normal)

        buttons["rightButton"] = UIButton(frame: CGRect(x: views["rightFormView"]!.bounds.width/2, y: 0, width: views["rightFormView"]!.bounds.width/2, height: buttonHeight))
        buttons["rightButton"]!.setTitle("درخواست فروشندگی", for: .normal)
        buttons["rightButton"]!.titleLabel?.font = buttonsFont
        buttons["rightButton"]!.setTitleColor(UIColor(hex: 0x515152), for: .normal)
        
        views["rightFormView"]!.addSubview(buttons["leftButton"]!)
        views["rightFormView"]!.addSubview(buttons["rightButton"]!)
        cursurY = cursurY + buttonHeight + marginY
        
        (views["shopView"],texts["shopText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_01", Selectable: false, PlaceHolderText: "نام فروشگاه")
        views["rightFormView"]?.addSubview(views["shopView"]!)
        cursurY = cursurY + buttonHeight + marginY
        
        (views["serviceView"],texts["serviceText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_02", Selectable: true, PlaceHolderText: "نوع خدمت")
        views["rightFormView"]?.addSubview(views["serviceView"]!)
        cursurY = cursurY + buttonHeight + marginY
        
        (views["familyView"],texts["familyText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: (textFieldWidth / 2)-(marginX/4), height: buttonHeight), Image: "icon_profile_04", Selectable: false, PlaceHolderText: "نام خانوادگی")
        views["rightFormView"]?.addSubview(views["familyView"]!)
        (views["nameView"],texts["nameText"]) = buildARowView(CGRect: CGRect(x: (textFieldWidth / 2)+(marginX/4)+marginX, y: cursurY, width: (textFieldWidth / 2)-marginX/4, height: buttonHeight), Image: "icon_profile_03", Selectable: false, PlaceHolderText: "نام")
        views["rightFormView"]?.addSubview(views["nameView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["locationView"],texts["locationText"]) = buildARowView(CGRect: CGRect(x: marginX+buttonHeight+marginX, y: cursurY, width: textFieldWidth-(buttonHeight+marginX), height: buttonHeight), Image: "icon_profile_05", Selectable: true, PlaceHolderText: "محدوده")
        views["rightFormView"]?.addSubview(views["locationView"]!)
        let locationButton = RoundedButton(frame: CGRect(x: marginX, y: cursurY, width: buttonHeight, height: buttonHeight))
        locationButton.setImage(UIImage(named: "icon_profile_06"), for: .normal)
        views["rightFormView"]?.addSubview(locationButton)
        cursurY = cursurY + buttonHeight + marginY

        (views["mobileNoView"],texts["mobileText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_07", Selectable: false, PlaceHolderText: "شماره همراه")
        views["rightFormView"]?.addSubview(views["mobileNoView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["discountRateView"],texts["discountText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_08", Selectable: false, PlaceHolderText: "درصد تخفیف پیشنهادی")
        views["rightFormView"]?.addSubview(views["discountRateView"]!)
        cursurY = cursurY + buttonHeight + (2 * marginY)

        awareCheckButton = UIButton(type: .custom)
        awareCheckButton.frame = CGRect(x: marginX+textFieldWidth-buttonHeight, y: cursurY, width: buttonHeight, height: buttonHeight)
        awareCheckButton.backgroundColor = UIColor(hex: 0xD6D7D9)
        awareCheckButton.setImage(UIImage(named: "icon_tick_white"), for: .normal)
        awareCheckButton.contentMode = .scaleAspectFit
        awareCheckButton.addTarget(self, action: #selector(self.awareButtonTapped(_:)), for: .touchUpInside)
        views["rightFormView"]?.addSubview(awareCheckButton)
        
        labels["awareLabel"] = UILabel(frame: CGRect(x: marginX, y: cursurY, width: textFieldWidth-buttonHeight-(marginX/2), height: buttonHeight))
        labels["awareLabel"]!.textColor = UIColor(hex: 0xD6D7D9)
        labels["awareLabel"]!.text = "آیا فروشگاه آگاه است"
        labels["awareLabel"]!.textAlignment = .right
        labels["awareLabel"]!.font = UIFont(name: "Shabnam-FD", size: 14)
        views["rightFormView"]?.addSubview(labels["awareLabel"]!)
        cursurY = cursurY + buttonHeight + (1 * marginY)
        
        termsCheckButton = UIButton(type: .custom)
        termsCheckButton.frame = CGRect(x: marginX+textFieldWidth-buttonHeight, y: cursurY, width: buttonHeight, height: buttonHeight)
        termsCheckButton.backgroundColor = UIColor(hex: 0xD6D7D9)
        termsCheckButton.setImage(UIImage(named: "icon_tick_white"), for: .normal)
        termsCheckButton.contentMode = .scaleAspectFit
        termsCheckButton.addTarget(self, action: #selector(self.termsButtonTapped(_:)), for: .touchUpInside)
        views["rightFormView"]?.addSubview(termsCheckButton)
        labels["termsLabel"] = UILabel(frame: CGRect(x: marginX, y: cursurY, width: textFieldWidth-buttonHeight-(marginX/2), height: buttonHeight))
        labels["termsLabel"]!.textColor = UIColor(hex: 0xD6D7D9)
        labels["termsLabel"]!.text = "قوانین و مقررات را خوانده ام و موافقم"
        labels["termsLabel"]!.textAlignment = .right
        labels["termsLabel"]!.font = UIFont(name: "Shabnam-FD", size: 14)
        views["rightFormView"]?.addSubview(labels["termsLabel"]!)
        cursurY = cursurY + buttonHeight + buttonHeight*2/3
        
        submitButton = RoundedButton(type: .custom)
        submitButton.frame = CGRect(x: marginX+(textFieldWidth/2)-1.5*buttonHeight, y: cursurY, width: 3*buttonHeight, height: buttonHeight)
        //submitButton.backgroundColor = UIColor.white
        submitButton.setTitleColor(UIColor(hex: 0xD6D7D9), for: .normal)
        submitButton.setTitle("ارسال", for: .normal)
        submitButton.semanticContentAttribute = .forceRightToLeft
        submitButton.titleLabel?.font = UIFont(name: "Shabnam-FD", size: 16)
        submitButton.setImage(UIImage(named: "icon_tick_black"), for: .normal)
        submitButton.contentMode = .scaleAspectFit
        submitButton.imageEdgeInsets = UIEdgeInsetsMake(0, buttonHeight/2, 0, 0)
        views["rightFormView"]?.addSubview(submitButton)
        cursurY = cursurY + buttonHeight + (1 * marginY)
        
        let formSize = CGSize(width: UIScreen.main.bounds.width, height: cursurY*1.2)
        self.delegate.scrollView.contentSize = formSize
        views["rightFormView"]?.frame = CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width-40, height: cursurY+buttonHeight*1.5)
        self.delegate.scrollView.addSubview(views["rightFormView"]!)
    }
    
    
    func buildARowView(CGRect rect : CGRect,Image anImageName : String,Selectable selectable:Bool,PlaceHolderText aPlaceHolder : String)->(UIView?,UITextField?){
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
        
        return (aView,aText)
    }
    
    @objc func termsButtonTapped(_ sender : Any){
        termsAgreed = !termsAgreed
        if termsAgreed {
            termsCheckButton.setImage(UIImage(named: "icon_tik_dark"), for: UIControlState.normal)
            labels["termsLabel"]!.textColor = UIColor(hex: 0x515152)
        } else {
            termsCheckButton.setImage(UIImage(named: "icon_tick_white"), for: .normal)
            labels["termsLabel"]!.textColor = UIColor(hex: 0xD6D7D9)
        }
    }
    
    @objc func awareButtonTapped(_ sender : Any) {
        shopAwareness = !shopAwareness
        if shopAwareness {
            awareCheckButton.setImage(UIImage(named: "icon_tik_dark"), for: UIControlState.normal)
            labels["awareLabel"]!.textColor = UIColor(hex: 0x515152)
        } else {
            awareCheckButton.setImage(UIImage(named: "icon_tick_white"), for: .normal)
            labels["awareLabel"]!.textColor = UIColor(hex: 0xD6D7D9)
        }
    }
    
    func showCardRequest(_ avc : GetRichViewController) {
        self.delegate = avc
        //print("Card Request  : ",views["rightFormView"]!,"  SuperView : ",views["rightFormView"]!.superview ?? "Nil")
        if views["rightFormView"]?.superview != nil { views["rightFormView"]?.removeFromSuperview()}
        var cursurY : CGFloat = 0
        let marginY : CGFloat = 10
        let marginX : CGFloat = 20
        views["leftFormView"] = LeftTabbedViewWithWhitePanel(frame: CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width-40, height: UIScreen.main.bounds.height * 1))
        views["leftFormView"]!.backgroundColor = UIColor.clear
        
        
        let buttonsFont = UIFont(name: "Shabnam-Bold-FD", size: 14)
        let buttonHeight = (views["leftFormView"] as! LeftTabbedViewWithWhitePanel).getHeight()
        let textFieldWidth = (views["leftFormView"]!.bounds.width) - (2 * marginX)
        
        buttons["leftButton"] = UIButton(frame: CGRect(x: 0, y: 0, width: views["leftFormView"]!.bounds.width/2, height: buttonHeight))
        buttons["leftButton"]!.setTitle("درخواست کارت", for: .normal)
        buttons["leftButton"]!.titleLabel?.font = buttonsFont
        //buttons["leftButton"]!.addTarget(self, action: #selector(self.cardRequestTapped(_:)), for: .touchUpInside)
        buttons["leftButton"]!.setTitleColor(UIColor(hex: 0x515152), for: .normal)
        views["leftFormView"]!.addSubview(buttons["leftButton"]!)
        
        buttons["rightButton"] = UIButton(frame: CGRect(x: views["leftFormView"]!.bounds.width/2, y: 0, width: views["leftFormView"]!.bounds.width/2, height: buttonHeight))
        buttons["rightButton"]!.setTitle("درخواست فروشندگی", for: .normal)
        buttons["rightButton"]!.titleLabel?.font = buttonsFont
        buttons["rightButton"]!.addTarget(self.delegate, action: #selector(self.delegate.resellerRequestTapped), for: .touchUpInside)
        buttons["rightButton"]!.setTitleColor(UIColor(hex: 0x515152), for: .normal)
        
        views["leftFormView"]!.addSubview(buttons["rightButton"]!)
        cursurY = cursurY + buttonHeight + marginY
        
        (views["familyView"],texts["familyText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: (textFieldWidth / 2)-(marginX/4), height: buttonHeight), Image: "icon_profile_04", Selectable: false, PlaceHolderText: "نام خانوادگی")
        views["leftFormView"]!.addSubview(views["familyView"]!)
        (views["nameView"],texts["nameText"]) = buildARowView(CGRect: CGRect(x: (textFieldWidth / 2)+(marginX/4)+marginX, y: cursurY, width: (textFieldWidth / 2)-marginX/4, height: buttonHeight), Image: "icon_profile_03", Selectable: false, PlaceHolderText: "نام")
        views["leftFormView"]!.addSubview(views["nameView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["nationalCodeView"],texts["nationalCodeText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "identity-card", Selectable: false, PlaceHolderText: "کد ملی")
        views["leftFormView"]?.addSubview(views["nationalCodeView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["birthDateView"],texts["birthDateText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "calendar-page-empty", Selectable: false, PlaceHolderText: "تاریخ تولد")
        views["leftFormView"]?.addSubview(views["birthDateView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["genderView"],texts["genderText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "genders", Selectable: true, PlaceHolderText: "جنسیت")
        views["leftFormView"]?.addSubview(views["genderView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["maritalStatusView"],texts["maritalStatusText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "marriage-rings-couple-with-a-heart", Selectable: true, PlaceHolderText: "وضعیت تاهل")
        views["leftFormView"]?.addSubview(views["maritalStatusView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["mobileNoView"],texts["mobileText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_07", Selectable: false, PlaceHolderText: "شماره همراه")
        views["leftFormView"]?.addSubview(views["mobileNoView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["emailView"],texts["emailText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "black-back-closed-envelope-shape", Selectable: false, PlaceHolderText: "ایمیل")
        views["leftFormView"]?.addSubview(views["emailView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["stateView"],texts["stateText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "map", Selectable: true, PlaceHolderText: "استان")
        views["leftFormView"]?.addSubview(views["stateView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["cityView"],texts["cityText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "NOIMAGE", Selectable: true, PlaceHolderText: "شهر")
        views["leftFormView"]?.addSubview(views["cityView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["regionView"],texts["regionText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "NOIMAGE", Selectable: true, PlaceHolderText: "منطقه")
        views["leftFormView"]?.addSubview(views["regionView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["orgView"],texts["orgText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "three-buildings", Selectable: false, PlaceHolderText: "نام سازمان")
        views["leftFormView"]?.addSubview(views["orgView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["cardNoView"],texts["cardNoText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "credit-card", Selectable: false, PlaceHolderText: "شماره کارت")
        views["leftFormView"]?.addSubview(views["cardNoView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["bankView"],texts["bankText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "bank-building", Selectable: false, PlaceHolderText: "بانک")
        views["leftFormView"]?.addSubview(views["bankView"]!)
        cursurY = cursurY + buttonHeight + marginY

        termsCheckButton = UIButton(type: .custom)
        termsCheckButton.frame = CGRect(x: marginX+textFieldWidth-buttonHeight, y: cursurY, width: buttonHeight, height: buttonHeight)
        termsCheckButton.backgroundColor = UIColor(hex: 0xD6D7D9)
        termsCheckButton.setImage(UIImage(named: "icon_tick_white"), for: .normal)
        termsCheckButton.contentMode = .scaleAspectFit
        termsCheckButton.addTarget(self, action: #selector(self.termsButtonTapped(_:)), for: .touchUpInside)
        views["leftFormView"]?.addSubview(termsCheckButton)
        labels["termsLabel"] = UILabel(frame: CGRect(x: marginX, y: cursurY, width: textFieldWidth-buttonHeight-(marginX/2), height: buttonHeight))
        labels["termsLabel"]!.textColor = UIColor(hex: 0xD6D7D9)
        labels["termsLabel"]!.text = "قوانین و مقررات را خوانده ام و موافقم"
        labels["termsLabel"]!.textAlignment = .right
        labels["termsLabel"]!.font = UIFont(name: "Shabnam-FD", size: 14)
        views["leftFormView"]?.addSubview(labels["termsLabel"]!)
        cursurY = cursurY + buttonHeight + buttonHeight*2/3

        submitButton = RoundedButton(type: .custom)
        submitButton.frame = CGRect(x: marginX+(textFieldWidth/2)-1.5*buttonHeight, y: cursurY, width: 3*buttonHeight, height: buttonHeight)
        //submitButton.backgroundColor = UIColor.white
        submitButton.setTitleColor(UIColor(hex: 0xD6D7D9), for: .normal)
        submitButton.setTitle("ارسال", for: .normal)
        submitButton.semanticContentAttribute = .forceRightToLeft
        submitButton.titleLabel?.font = UIFont(name: "Shabnam-FD", size: 16)
        submitButton.setImage(UIImage(named: "icon_tick_black"), for: .normal)
        submitButton.contentMode = .scaleAspectFit
        submitButton.imageEdgeInsets = UIEdgeInsetsMake(0, buttonHeight/2, 0, 0)
        views["leftFormView"]?.addSubview(submitButton)
        cursurY = cursurY + buttonHeight + (1 * marginY)
        
        let formSize = CGSize(width: UIScreen.main.bounds.width, height: cursurY*1.2)
        self.delegate.scrollView.contentSize = formSize
        views["leftFormView"]?.frame = CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width-40, height: cursurY+buttonHeight*1.5)
        self.delegate.scrollView.addSubview(views["leftFormView"]!)
        
    }
}
