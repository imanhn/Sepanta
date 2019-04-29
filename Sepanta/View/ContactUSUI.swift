//
//  ContactUSUI.swift
//  Sepanta
//
//  Created by Iman on 2/9/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
//
//  GetRichUI.swift
//  Sepanta
//
//  Created by Iman on 12/15/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Alamofire

class ContactUSUI : NSObject , UITextFieldDelegate {
    var delegate : ContactUSViewController!
    var views = Dictionary<String,UIView>()
    var texts = Dictionary<String,UITextField>()
    var labels = Dictionary<String,UILabel>()
    var buttons = Dictionary<String,UIButton>()
    var submitButton = UIButton(type: .custom)
    var disposeList = [Disposable]()
    
    init(_ vc : ContactUSViewController) {
        self.delegate = vc
        super.init()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //BuildRow set 11 for tag of selectable textfield (See BuildRow function)
        if textField.tag == 11 {
            return false
            
        }else{
            // edittingView is set for keyboard notification manageing facility to find out if we should move the keyboard up or not!
            self.delegate.edittingView = textField
            return true
        }
    }
    //Create Gradient on PageView
    @objc func showContactInfo() {
        
        //print("reseller Request : ",views["leftFormView"] ?? "Nil")
        if views["leftFormView"] != nil && views["leftFormView"]?.superview != nil
        {
            disposeList.forEach({$0.dispose()})
            views["leftFormView"]?.removeFromSuperview()
        }
        var cursurY : CGFloat = 0
        let marginY : CGFloat = 10
        let marginX : CGFloat = 20
        /*
        let gradient = CAGradientLayer()
        gradient.frame = self.delegate.view.bounds
        gradient.colors = [UIColor(hex: 0xF7F7F7).cgColor, UIColor.white.cgColor]
        self.delegate.mainView.layer.insertSublayer(gradient, at: 0)
        
        let backgroundFormView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2))
        backgroundFormView.layer.insertSublayer(gradient, at: 0)
        self.delegate.mainView.addSubview(backgroundFormView)
        */
        
        //views["rightFormView"] = TabbedViewWithWhitePanel(frame: CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width-40, height: UIScreen.main.bounds.height * 2))
        //self.delegate.panelView.backgroundColor = UIColor.clear
        
        
        let buttonsFont = UIFont(name: "Shabnam-Bold-FD", size: 14)
        let buttonHeight = self.delegate.panelView.getHeight()
        let textFieldWidth = (self.delegate.panelView.bounds.width) - (2 * marginX)
        
        buttons["leftButton"] = UIButton(frame: CGRect(x: 0, y: 0, width: (self.delegate.panelView.bounds.width)/2, height: buttonHeight))
        buttons["leftButton"]!.setTitle("اطلاعات ارتباطی", for: .normal)
        buttons["leftButton"]!.titleLabel?.font = buttonsFont
        buttons["leftButton"]!.addTarget(self, action: #selector(showFeedbackForm), for: .touchUpInside)
        buttons["leftButton"]!.setTitleColor(UIColor(hex: 0x515152), for: .normal)
        
        buttons["rightButton"] = UIButton(frame: CGRect(x: self.delegate.panelView.bounds.width/2, y: 0, width: self.delegate.panelView.bounds.width/2, height: buttonHeight))
        buttons["rightButton"]!.setTitle("فرم تماس با ما", for: .normal)
        buttons["rightButton"]!.titleLabel?.font = buttonsFont
        buttons["rightButton"]!.setTitleColor(UIColor(hex: 0x515152), for: .normal)
        
        self.delegate.panelView.addSubview(buttons["leftButton"]!)
        self.delegate.panelView.addSubview(buttons["rightButton"]!)
        cursurY = cursurY + buttonHeight + marginY
        
        (views["shopView"],texts["shopText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_01", Selectable: false, PlaceHolderText: "نام فروشگاه")
        self.delegate.panelView.addSubview(views["shopView"]!)
        cursurY = cursurY + buttonHeight + marginY
        
        (views["serviceView"],texts["serviceText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_02", Selectable: false, PlaceHolderText: "نوع خدمت")
        self.delegate.panelView.addSubview(views["serviceView"]!)
        cursurY = cursurY + buttonHeight + marginY
        
        (views["familyView"],texts["familyText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: (textFieldWidth / 2)-(marginX/4), height: buttonHeight), Image: "icon_profile_04", Selectable: false, PlaceHolderText: "نام خانوادگی")
        //texts["familyText"]!.text =  aProfileInfo.last_name
        self.delegate.panelView.addSubview(views["familyView"]!)
        (views["nameView"],texts["nameText"]) = buildARowView(CGRect: CGRect(x: (textFieldWidth / 2)+(marginX/4)+marginX, y: cursurY, width: (textFieldWidth / 2)-marginX/4, height: buttonHeight), Image: "icon_profile_03", Selectable: false, PlaceHolderText: "نام")
        //texts["nameText"]!.text =  aProfileInfo.first_name
        self.delegate.panelView.addSubview(views["nameView"]!)
        cursurY = cursurY + buttonHeight + marginY
        
        (views["locationView"],texts["locationText"]) = buildARowView(CGRect: CGRect(x: marginX+buttonHeight+marginX, y: cursurY, width: textFieldWidth-(buttonHeight+marginX), height: buttonHeight), Image: "icon_profile_05", Selectable: false, PlaceHolderText: "محدوده")
        self.delegate.panelView.addSubview(views["locationView"]!)
        //texts["locationText"]!.text =  aProfileInfo.address
        let locationButton = RoundedButton(frame: CGRect(x: marginX, y: cursurY, width: buttonHeight, height: buttonHeight))
        locationButton.setImage(UIImage(named: "icon_profile_06"), for: .normal)
        self.delegate.panelView.addSubview(locationButton)
        cursurY = cursurY + buttonHeight + marginY
        
        (views["mobileNoView"],texts["mobileText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_07", Selectable: false, PlaceHolderText: "شماره همراه")
        //texts["mobileText"]!.text =  aProfileInfo.phone
        texts["mobileText"]?.keyboardType = UIKeyboardType.decimalPad
        self.delegate.panelView.addSubview(views["mobileNoView"]!)
        cursurY = cursurY + buttonHeight + marginY
        
        (views["discountRateView"],texts["discountText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_08", Selectable: false, PlaceHolderText: "درصد تخفیف پیشنهادی")
        texts["discountText"]?.keyboardType = UIKeyboardType.decimalPad
        self.delegate.panelView.addSubview(views["discountRateView"]!)
        cursurY = cursurY + buttonHeight + (2 * marginY)
        
        
        self.delegate.panelView.addSubview(submitButton)
        cursurY = cursurY + buttonHeight + (1 * marginY)
      
        
        
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
        aText.delegate = self
        if selectable {
            let triangleImage = UIImageView(frame: CGRect(x: 0, y: rect.height*3/4 - 5, width: rect.height/4, height: rect.height/4))
            triangleImage.image = UIImage(named: "icon_dropdown_red")
            aText.tag = 11
            aView.addSubview(triangleImage)
        }
        aView.addSubview(aText)
        aView.addSubview(anIcon)
        
        return (aView,aText)
    }
    
    
    @objc func showFeedbackForm() {
        
        //print("Card Request  : ",self.delegate.panelView,"  SuperView : ",self.delegate.panelView.superview ?? "Nil")
        if self.delegate.panelView.superview != nil {
            disposeList.forEach({$0.dispose()})
            self.delegate.panelView.removeFromSuperview()
        }
        
        var cursurY : CGFloat = 0
        let marginY : CGFloat = 10
        let marginX : CGFloat = 20
        views["leftFormView"] = LeftTabbedViewWithWhitePanel(frame: CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width-40, height: UIScreen.main.bounds.height * 1))
        views["leftFormView"]!.backgroundColor = UIColor.clear
        
        
        let buttonsFont = UIFont(name: "Shabnam-Bold-FD", size: 14)
        let buttonHeight = (views["leftFormView"] as! LeftTabbedViewWithWhitePanel).getHeight()
        let textFieldWidth = (views["leftFormView"]!.bounds.width) - (2 * marginX)
        
        buttons["leftButton"] = UIButton(frame: CGRect(x: 0, y: 0, width: views["leftFormView"]!.bounds.width/2, height: buttonHeight))
        buttons["leftButton"]!.setTitle("اطلاعات ارتباطی", for: .normal)
        buttons["leftButton"]!.titleLabel?.font = buttonsFont
        //buttons["leftButton"]!.addTarget(self, action: #selector(self.cardRequestTapped(_:)), for: .touchUpInside)
        buttons["leftButton"]!.setTitleColor(UIColor(hex: 0x515152), for: .normal)
        views["leftFormView"]!.addSubview(buttons["leftButton"]!)
        
        buttons["rightButton"] = UIButton(frame: CGRect(x: views["leftFormView"]!.bounds.width/2, y: 0, width: views["leftFormView"]!.bounds.width/2, height: buttonHeight))
        buttons["rightButton"]!.setTitle("فرم تماس با ما", for: .normal)
        buttons["rightButton"]!.titleLabel?.font = buttonsFont
        buttons["rightButton"]!.addTarget(self, action: #selector(showContactInfo), for: .touchUpInside)
        buttons["rightButton"]!.setTitleColor(UIColor(hex: 0x515152), for: .normal)
        
        views["leftFormView"]!.addSubview(buttons["rightButton"]!)
        cursurY = cursurY + buttonHeight + marginY
        
        (views["familyView"],texts["familyText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: (textFieldWidth / 2)-(marginX/4), height: buttonHeight), Image: "icon_profile_04", Selectable: false, PlaceHolderText: "نام خانوادگی")
        //texts["familyText"]!.text =  aProfileInfo.last_name
        views["leftFormView"]!.addSubview(views["familyView"]!)
        (views["nameView"],texts["nameText"]) = buildARowView(CGRect: CGRect(x: (textFieldWidth / 2)+(marginX/4)+marginX, y: cursurY, width: (textFieldWidth / 2)-marginX/4, height: buttonHeight), Image: "icon_profile_03", Selectable: false, PlaceHolderText: "نام")
        //texts["nameText"]!.text =  aProfileInfo.first_name
        views["leftFormView"]!.addSubview(views["nameView"]!)
        cursurY = cursurY + buttonHeight + marginY
        
        (views["nationalCodeView"],texts["nationalCodeText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "identity-card", Selectable: false, PlaceHolderText: "کد ملی")
        //texts["nationalCodeText"]!.text =  aProfileInfo.national_code
        texts["nationalCodeText"]?.keyboardType = UIKeyboardType.decimalPad
        views["leftFormView"]?.addSubview(views["nationalCodeView"]!)
        cursurY = cursurY + buttonHeight + marginY
        
        

        
        submitButton = SubmitButton(type: .custom)
        submitButton.frame = CGRect(x: marginX+(textFieldWidth/2)-1.5*buttonHeight, y: cursurY, width: 3*buttonHeight, height: buttonHeight)
        submitButton.setTitle("ارسال", for: .normal)
        submitButton.addTarget(self, action: #selector(submitFeedBack), for: .touchUpInside)
        views["leftFormView"]?.addSubview(submitButton)
        cursurY = cursurY + buttonHeight + (1 * marginY)
        
        
    }
    
    @objc func submitFeedBack(_ sender : Any){
    
    }
    

}
