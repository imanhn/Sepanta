//
//  EditProfileUI.swift
//  Sepanta
//
//  Created by Iman on 12/19/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//


import Foundation
import UIKit

//extension  GetRichViewController {
class EditProfileUI {
    var delegate : EditProfileViewController!
    var views = Dictionary<String,UIView>()
    var texts = Dictionary<String,UITextField>()
    var labels = Dictionary<String,UILabel>()
    var buttons = Dictionary<String,UIButton>()
    var datePicker = UIDatePicker()
    var submitButton = UIButton(type: .custom)
    
    init() {
    }
    @objc func doneDatePicker(_ sender : Any) {
        self.delegate.view.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/DD"
        formatter.locale = Locale(identifier: "fa_IR")
        texts["birthDateText"]?.text = formatter.string(from: datePicker.date)
    }
    @objc func cancelDatePicker(_ sender : Any) {
        self.delegate.view.endEditing(true)
    }
    //Create Gradient on PageView
    @objc func sendEditedData(){
        //Submit data to server to change profile data and them back to profile view if required
    }
    func showForm(_ avc : EditProfileViewController) {
        self.delegate = avc
        //print("reseller Request : ",views["leftFormView"] ?? "Nil")
        if views["leftFormView"] != nil && views["leftFormView"]?.superview != nil { views["leftFormView"]?.removeFromSuperview()}
        var cursurY : CGFloat = 10
        let marginY : CGFloat = 10
        let marginX : CGFloat = 10
        let gradient = CAGradientLayer()
        gradient.frame = self.delegate.view.bounds
        gradient.colors = [UIColor(hex: 0xF7F7F7).cgColor, UIColor.white.cgColor]
        self.delegate.topView.layer.insertSublayer(gradient, at: 0)
        self.delegate.scrollView.contentSize = CGSize(width: self.delegate.formView.frame.width-2*marginX, height: self.delegate.formView.frame.height-2*marginY)
        views["rightFormView"] = RoundedUIViewWithWhitePanel(frame: CGRect(x: marginX, y: marginY, width: self.delegate.formView.frame.width-2*marginX, height: self.delegate.formView.frame.height-2*marginY))
        views["rightFormView"]?.backgroundColor = UIColor.white
        
        
        let buttonHeight = views["rightFormView"]!.frame.width/6
        let textFieldWidth = (views["rightFormView"]?.bounds.width)! - (2 * marginX)
        
        (views["familyView"],texts["familyText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: (textFieldWidth / 2)-(marginX/4), height: buttonHeight), Image: "icon_profile_04", Selectable: false, PlaceHolderText: "نام خانوادگی")
        views["rightFormView"]?.addSubview(views["familyView"]!)
        (views["nameView"],texts["nameText"]) = buildARowView(CGRect: CGRect(x: (textFieldWidth / 2)+(marginX/4)+marginX, y: cursurY, width: (textFieldWidth / 2)-marginX/4, height: buttonHeight), Image: "icon_profile_03", Selectable: false, PlaceHolderText: "نام")
        views["rightFormView"]?.addSubview(views["nameView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["nationalCodeView"],texts["nationalCodeText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "identity-card", Selectable: false, PlaceHolderText: "کد ملی")
        views["rightFormView"]?.addSubview(views["nationalCodeView"]!)
        cursurY = cursurY + buttonHeight + marginY
        
        (views["birthDateView"],texts["birthDateText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "calendar-page-empty", Selectable: false, PlaceHolderText: "تاریخ تولد")
        datePicker.calendar = Calendar(identifier: Calendar.Identifier.persian)
        datePicker.locale = Locale(identifier: "fa_IR")
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "ثبت", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneDatePicker(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "لغو", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelDatePicker(_:)))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        //adatePicker.inp
        texts["birthDateText"]?.inputAccessoryView = toolbar
        texts["birthDateText"]?.inputView = datePicker
        views["rightFormView"]?.addSubview(views["birthDateView"]!)
        cursurY = cursurY + buttonHeight + marginY
        
        (views["genderView"],self.delegate.genderTextField) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "genders", Selectable: true, PlaceHolderText: "جنسیت")
        views["rightFormView"]?.addSubview(views["genderView"]!)
        cursurY = cursurY + buttonHeight + marginY
        
        (views["maritalStatusView"],texts["maritalStatusText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "marriage-rings-couple-with-a-heart", Selectable: true, PlaceHolderText: "وضعیت تاهل")
        views["rightFormView"]?.addSubview(views["maritalStatusView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["emailView"],texts["emailText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "black-back-closed-envelope-shape", Selectable: false, PlaceHolderText: "ایمیل")
        views["rightFormView"]?.addSubview(views["emailView"]!)
        cursurY = cursurY + buttonHeight + marginY
        
        (views["stateView"],self.delegate.selectProvince) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "map", Selectable: true, PlaceHolderText: "استان")
        views["rightFormView"]?.addSubview(views["stateView"]!)
        cursurY = cursurY + buttonHeight + marginY
        
        (views["cityView"],self.delegate.selectCity) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "NOIMAGE", Selectable: true, PlaceHolderText: "شهر")
        views["rightFormView"]?.addSubview(views["cityView"]!)
        cursurY = cursurY + buttonHeight + marginY
        
        (views["regionView"],texts["regionText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "NOIMAGE", Selectable: true, PlaceHolderText: "منطقه")
        views["rightFormView"]?.addSubview(views["regionView"]!)
        cursurY = cursurY + buttonHeight + buttonHeight

        
        submitButton = RoundedButtonWithDarkBackground(type: .custom)
        submitButton.frame = CGRect(x: marginX+(textFieldWidth/2)-1.5*buttonHeight, y: cursurY, width: 3*buttonHeight, height: buttonHeight)
        //submitButton.backgroundColor = UIColor.white
        
        //submitButton.setImage(UIImage(named: "icon_tick_black"), for: .normal)
        //submitButton.setTitleColor(UIColor(hex: 0xD6D7D9), for: .normal)
        
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.setImage(UIImage(named: "icon_tick_white"), for: .normal)
        
        submitButton.setTitle("تایید", for: .normal)
        submitButton.semanticContentAttribute = .forceRightToLeft
        submitButton.titleLabel?.font = UIFont(name: "Shabnam-FD", size: 16)
        submitButton.addTarget(self, action: #selector(sendEditedData), for: .touchUpInside)
        
        
        submitButton.contentMode = .scaleAspectFit
        submitButton.imageEdgeInsets = UIEdgeInsetsMake(0, buttonHeight/2, 0, 0)
        views["rightFormView"]?.addSubview(submitButton)
        cursurY = cursurY + buttonHeight + (1 * marginY)
        
        let formSize = CGSize(width: self.delegate.formView.frame.width-2*marginX, height: cursurY*1.2)
        self.delegate.scrollView.contentSize = formSize
        views["rightFormView"]?.frame = CGRect(x: marginX, y: marginY, width: self.delegate.formView.frame.width-2*marginX, height: cursurY+1.5*buttonHeight)
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
    
}
