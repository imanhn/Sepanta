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

class GetRichUI : NSObject , UITextFieldDelegate {
    var delegate : GetRichViewController!
    var views = Dictionary<String,UIView>()
    var texts = Dictionary<String,UITextField>()
    var labels = Dictionary<String,UILabel>()
    var buttons = Dictionary<String,UIButton>()
    var datePicker = UIDatePicker()    
    var awareCheckButton = UIButton(type: .custom)
    var termsCheckButton = UIButton(type: .custom)
    var termsAgreed : Bool = false
    var shopAwareness : Bool = false
    var cardSubmitButton = UIButton(type: .custom)
    var resellerSubmitButton = UIButton(type: .custom)
    var stateCode : String!
    var cityCode : String!
    var cardNoPrefix = ""
    var aProfileInfo = ProfileInfo()
    var disposeList = [Disposable]()

    override init() {
        super.init()
        let profileInfoDispose = getAndSubscribeToProfileInfo()
        disposeList.append(profileInfoDispose)
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
    func showResellerRequest(_ avc : GetRichViewController) {
        self.delegate = avc
        //print("reseller Request : ",views["leftFormView"] ?? "Nil")
        if views["leftFormView"] != nil && views["leftFormView"]?.superview != nil
        {
            disposeList.forEach({$0.dispose()})
            views["leftFormView"]?.removeFromSuperview()
        }
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
        
        (views["serviceView"],texts["serviceText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_02", Selectable: false, PlaceHolderText: "نوع خدمت")
        views["rightFormView"]?.addSubview(views["serviceView"]!)
        cursurY = cursurY + buttonHeight + marginY
        
        (views["familyView"],texts["familyText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: (textFieldWidth / 2)-(marginX/4), height: buttonHeight), Image: "icon_profile_04", Selectable: false, PlaceHolderText: "نام خانوادگی")
        //texts["familyText"]!.text =  aProfileInfo.last_name
        views["rightFormView"]?.addSubview(views["familyView"]!)
        (views["nameView"],texts["nameText"]) = buildARowView(CGRect: CGRect(x: (textFieldWidth / 2)+(marginX/4)+marginX, y: cursurY, width: (textFieldWidth / 2)-marginX/4, height: buttonHeight), Image: "icon_profile_03", Selectable: false, PlaceHolderText: "نام")
        //texts["nameText"]!.text =  aProfileInfo.first_name
        views["rightFormView"]?.addSubview(views["nameView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["locationView"],texts["locationText"]) = buildARowView(CGRect: CGRect(x: marginX+buttonHeight+marginX, y: cursurY, width: textFieldWidth-(buttonHeight+marginX), height: buttonHeight), Image: "icon_profile_05", Selectable: false, PlaceHolderText: "محدوده")
        views["rightFormView"]?.addSubview(views["locationView"]!)
        //texts["locationText"]!.text =  aProfileInfo.address
        let locationButton = RoundedButton(frame: CGRect(x: marginX, y: cursurY, width: buttonHeight, height: buttonHeight))
        locationButton.setImage(UIImage(named: "icon_profile_06"), for: .normal)
        views["rightFormView"]?.addSubview(locationButton)
        cursurY = cursurY + buttonHeight + marginY

        (views["mobileNoView"],texts["mobileText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_07", Selectable: false, PlaceHolderText: "شماره همراه")
        //texts["mobileText"]!.text =  aProfileInfo.phone
        texts["mobileText"]?.keyboardType = UIKeyboardType.decimalPad
        views["rightFormView"]?.addSubview(views["mobileNoView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["discountRateView"],texts["discountText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_08", Selectable: false, PlaceHolderText: "درصد تخفیف پیشنهادی")
        texts["discountText"]?.keyboardType = UIKeyboardType.decimalPad
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
        
        resellerSubmitButton = SubmitButton(type: .custom)
        resellerSubmitButton.frame = CGRect(x: marginX+(textFieldWidth/2)-1.5*buttonHeight, y: cursurY, width: 3*buttonHeight, height: buttonHeight)
        resellerSubmitButton.setTitle("ارسال", for: .normal)
        resellerSubmitButton.addTarget(self, action: #selector(self.sellRequestSubmitTapped(_:)), for: .touchUpInside)
        views["rightFormView"]?.addSubview(resellerSubmitButton)
        cursurY = cursurY + buttonHeight + (1 * marginY)
        
        let formSize = CGSize(width: UIScreen.main.bounds.width, height: cursurY*1.2)
        self.delegate.scrollView.contentSize = formSize
        views["rightFormView"]?.frame = CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width-40, height: cursurY+buttonHeight*1.5)
        self.delegate.scrollView.addSubview(views["rightFormView"]!)
        self.fillEditProfileForm(With: aProfileInfo)
        let submitDispose = handleResellerSubmitButtonEnableOrDisable()
        disposeList.append(submitDispose)

    }
    
    @objc func sellRequestSubmitTapped(_ sender : Any){
        let aParameter = [
            "first_name":"\(texts["nameText"]!.text ?? "")",
            "last_name":"\(texts["familyText"]!.text ?? "")",
            "shop_name":"\(texts["shopText"]!.text ?? "")",
            "Phone_number":"\(texts["mobileText"]!.text ?? "")",
            "is_aware":"\(awareCheckButton.tag)",
            "address":"\(texts["locationText"]!.text ?? "")",
            //"city_code":"",
            "off_guess":"\(texts["discountText"]!.text ?? "")",
            "latitude":"35.1",
            "longitude":"51.1"
            //"national_code":"",
            //"categoriesId":"",
        ]
        print("aParameter : \(aParameter)")
        NetworkManager.shared.run(API: "selling-request", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: false)
        let messageDisp = NetworkManager.shared.messageObs
            .filter({$0.count > 0})
            .subscribe(onNext: { aMessage in
                self.delegate.alert(Message: aMessage)
                NetworkManager.shared.messageObs = BehaviorRelay<String>(value: "")
            })
        disposeList.append(messageDisp)
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
    
    @objc func termsButtonTapped(_ sender : Any){
        termsAgreed = !termsAgreed
        if termsAgreed {
            termsCheckButton.setImage(UIImage(named: "icon_tik_dark"), for: UIControlState.normal)
            labels["termsLabel"]!.textColor = UIColor(hex: 0x515152)
            termsCheckButton.tag = 1
        } else {
            termsCheckButton.setImage(UIImage(named: "icon_tick_white"), for: .normal)
            labels["termsLabel"]!.textColor = UIColor(hex: 0xD6D7D9)
            termsCheckButton.tag = 0
        }
    }
    
    @objc func awareButtonTapped(_ sender : Any) {
        shopAwareness = !shopAwareness
        if shopAwareness {
            awareCheckButton.setImage(UIImage(named: "icon_tik_dark"), for: UIControlState.normal)
            labels["awareLabel"]!.textColor = UIColor(hex: 0x515152)
            awareCheckButton.tag = 1
        } else {
            awareCheckButton.setImage(UIImage(named: "icon_tick_white"), for: .normal)
            labels["awareLabel"]!.textColor = UIColor(hex: 0xD6D7D9)
            awareCheckButton.tag = 0
        }
    }
    @objc func doneDatePicker(_ sender : Any) {
        self.delegate.view.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/DD"
        formatter.locale = Locale(identifier: "fa_IR")
        texts["birthDateText"]?.text = formatter.string(from: datePicker.date)
        texts["birthDateText"]?.sendActions(for: .valueChanged)
    }
    @objc func cancelDatePicker(_ sender : Any) {
        self.delegate.view.endEditing(true)
    }

    func showCardRequest(_ avc : GetRichViewController) {
        self.delegate = avc
        //print("Card Request  : ",views["rightFormView"]!,"  SuperView : ",views["rightFormView"]!.superview ?? "Nil")
        if views["rightFormView"]?.superview != nil {
            disposeList.forEach({$0.dispose()})
            views["rightFormView"]?.removeFromSuperview()
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
        
        (views["birthDateView"],texts["birthDateText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "calendar-page-empty", Selectable: false, PlaceHolderText: "تاریخ تولد")
        //texts["birthDateText"]!.text =  aProfileInfo.birthdate
        
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
        views["leftFormView"]?.addSubview(views["birthDateView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["genderView"],texts["genderText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "genders", Selectable: true, PlaceHolderText: "جنسیت")
        //texts["genderText"]!.text =  aProfileInfo.gender
        texts["genderText"]?.addTarget(self, action: #selector(selectGenderTapped), for: .touchDown)
        views["leftFormView"]?.addSubview(views["genderView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["maritalStatusView"],texts["maritalStatusText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "marriage-rings-couple-with-a-heart", Selectable: true, PlaceHolderText: "وضعیت تاهل")
        //texts["maritalStatusText"]!.text =  aProfileInfo.marital_status
        texts["maritalStatusText"]?.addTarget(self, action: #selector(selectMaritalStatusTapped), for: .touchDown)
        views["leftFormView"]?.addSubview(views["maritalStatusView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["mobileNoView"],texts["mobileText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_07", Selectable: false, PlaceHolderText: "شماره همراه")
        //texts["mobileText"]!.text =  aProfileInfo.phone
        texts["mobileText"]?.keyboardType = UIKeyboardType.decimalPad
        views["leftFormView"]?.addSubview(views["mobileNoView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["emailView"],texts["emailText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "black-back-closed-envelope-shape", Selectable: false, PlaceHolderText: "ایمیل")
        //texts["emailText"]!.text =  aProfileInfo.email
        texts["emailText"]?.keyboardType = UIKeyboardType.emailAddress
        views["leftFormView"]?.addSubview(views["emailView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["stateView"],texts["stateText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "map", Selectable: true, PlaceHolderText: "استان")
        //texts["stateText"]!.text =  aProfileInfo.state
        texts["stateText"]?.addTarget(self, action: #selector(selectStateTapped), for: .touchDown)
        views["leftFormView"]?.addSubview(views["stateView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["cityView"],texts["cityText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "NOIMAGE", Selectable: true, PlaceHolderText: "شهر")
        //texts["cityText"]!.text =  aProfileInfo.city
        texts["cityText"]?.addTarget(self, action: #selector(selectCityTapped), for: .touchDown)
        views["leftFormView"]?.addSubview(views["cityView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["regionView"],texts["regionText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "NOIMAGE", Selectable: false, PlaceHolderText: "منطقه")
        //texts["regionText"]!.text =  aProfileInfo.address
        views["leftFormView"]?.addSubview(views["regionView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["orgView"],texts["orgText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "three-buildings", Selectable: false, PlaceHolderText: "نام سازمان")
        views["leftFormView"]?.addSubview(views["orgView"]!)
        cursurY = cursurY + buttonHeight + marginY

        (views["cardNoView"],texts["cardNoText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "credit-card", Selectable: false, PlaceHolderText: "شماره کارت")
        views["leftFormView"]?.addSubview(views["cardNoView"]!)
        texts["cardNoText"]?.keyboardType = UIKeyboardType.decimalPad
        if self.delegate.cardNo != nil {
            texts["cardNoText"]!.text = self.delegate.cardNo
            texts["cardNoText"]!.sendActions(for: .valueChanged)
        }
        cursurY = cursurY + buttonHeight + marginY
        let cardDispose = texts["cardNoText"]!.rx.text
            .subscribe(onNext: { aCardNumber in
                if (aCardNumber?.count)! >= 6 {
                    let cardNumberPrefix = aCardNumber!.prefix(6).description
                    if self.cardNoPrefix != cardNumberPrefix{
                        let aParameter = ["card_number":"\(String(describing: cardNumberPrefix))"]
                        self.cardNoPrefix = cardNumberPrefix
                        NetworkManager.shared.run(API: "check-bank", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: true)
                    }
                }
            }
        )
        cardDispose.disposed(by: self.delegate.myDisposeBag)
        disposeList.append(cardDispose)
        
        (views["bankView"],texts["bankText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "bank-building", Selectable: false, PlaceHolderText: "بانک")
        texts["bankText"]?.isEnabled = false
        views["leftFormView"]?.addSubview(views["bankView"]!)
        cursurY = cursurY + buttonHeight + marginY
        let bankDispose = NetworkManager.shared.bankObs
            .subscribe(onNext: { aBank in
                //print("aBank.bank : ",aBank.bank)
                self.texts["bankText"]?.text = aBank.bank
            })
        bankDispose.disposed(by: self.delegate.myDisposeBag)
        disposeList.append(bankDispose)
        
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

        cardSubmitButton = SubmitButton(type: .custom)
        cardSubmitButton.frame = CGRect(x: marginX+(textFieldWidth/2)-1.5*buttonHeight, y: cursurY, width: 3*buttonHeight, height: buttonHeight)
        cardSubmitButton.setTitle("ارسال", for: .normal)
        cardSubmitButton.addTarget(self, action: #selector(self.cardRequestSubmitTapped(_:)), for: .touchUpInside)
        views["leftFormView"]?.addSubview(cardSubmitButton)
        cursurY = cursurY + buttonHeight + (1 * marginY)
        
        let formSize = CGSize(width: UIScreen.main.bounds.width, height: cursurY*1.2)
        self.delegate.scrollView.contentSize = formSize
        views["leftFormView"]?.frame = CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width-40, height: cursurY+buttonHeight*1.5)
        self.delegate.scrollView.addSubview(views["leftFormView"]!)
        self.fillEditProfileForm(With: aProfileInfo)
        let submitDispose = handleCardSubmitButtonEnableOrDisable()
        disposeList.append(submitDispose)

    }
    
    @objc func cardRequestSubmitTapped(_ sender : Any){
        var cityCode = ""
        let cityDic = NetworkManager.shared.cityDictionaryObs.value
        if cityDic.count == 0 {
            print("Dic is Empty!")
            return
        }
        
        if let acityText = texts["cityText"]!.text {
            if let acode = cityDic[acityText] {
                cityCode = acode
            }else{
                print("Code not found")
            }
        }else{
            print("CityText is empty!!!! Which is odd!")
        }
        //
        let aParameter = [
            "first_name":"\(texts["nameText"]!.text ?? "")",
            "last_name":"\(texts["familyText"]!.text ?? "")",
            "national_code":"\(texts["nationalCodeText"]!.text ?? "")",
            "addres":"\(texts["regionText"]!.text ?? "")",
            "birthdate":"\(texts["birthDateText"]!.text ?? "")",
            "city":cityCode,
            "cardnumber":"\(texts["cardNoText"]!.text ?? "")"
        ]
        print("aParameter : \(aParameter)")
        NetworkManager.shared.run(API: "card-request", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: false)
        let messageDisp = NetworkManager.shared.messageObs
            .filter({$0.count > 0})
            .subscribe(onNext: { aMessage in
                self.delegate.alert(Message: aMessage)
                NetworkManager.shared.messageObs = BehaviorRelay<String>(value: "")
            })
        disposeList.append(messageDisp)
    }
    
    func handleCardSubmitButtonEnableOrDisable() -> Disposable{
        let familtyTextValid = texts["familyText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let nameTextValid = texts["nameText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let nationalCodeValid = texts["nationalCodeText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let birthDateTextValid = texts["birthDateText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let genderTextValid = texts["genderText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let maritalStatusTextValid = texts["maritalStatusText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let emailTextValid = texts["emailText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let mobileTextValid = texts["mobileText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let stateTextValid = texts["stateText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let cityTextValid = texts["cityText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let regionTextValid = texts["regionText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let cardNoTextValid = texts["cardNoText"]!.rx.text.map({($0?.count == 16)}).share(replay: 1, scope: .whileConnected)
        
        let termsCheckValid = termsCheckButton.rx.tap.map({ _ -> Bool in
            if self.termsCheckButton.tag == 1 {return true}else{return false}
        }).share(replay: 1, scope: .whileConnected)
        
        let enableSubmitButton = Observable.combineLatest([familtyTextValid,
                                                           nameTextValid,
                                                           nationalCodeValid,
                                                           birthDateTextValid,
                                                           genderTextValid,
                                                           maritalStatusTextValid,
                                                           emailTextValid,
                                                           mobileTextValid,
                                                           stateTextValid,
                                                           cityTextValid,
                                                           regionTextValid,
                                                           cardNoTextValid,
                                                           termsCheckValid]) { (allChecks) -> Bool in
                                                            //print("ALL : ",allChecks)
                                                            let reducedAllChecks = allChecks.reduce(true) {
                                                                (accumulation: Bool, nextValue: Bool) -> Bool in
                                                                return accumulation && nextValue
                                                            }
                                                            //print("   Reduced to \(reducedAllChecks)")
                                                            return reducedAllChecks
        }
        return enableSubmitButton.bind(to: cardSubmitButton.rx.isEnabled)

        
    }
    func handleResellerSubmitButtonEnableOrDisable() -> Disposable{
        let familtyTextValid = texts["familyText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let nameTextValid = texts["nameText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let shopTextValid = texts["shopText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let serviceTextValid = texts["serviceText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let mobileTextValid = texts["mobileText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let locationTextValid = texts["locationText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let discountTextValid = texts["discountText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)

        let termsCheckValid = termsCheckButton.rx.tap.map({ _ -> Bool in
            if self.termsCheckButton.tag == 1 {return true}else{return false}
        }).share(replay: 1, scope: .whileConnected)
        let awareCheckValid = awareCheckButton.rx.tap.map({ _ -> Bool in
            if self.awareCheckButton.tag == 1 {return true}else{return false}
        }).share(replay: 1, scope: .whileConnected)

        let enableSubmitButton = Observable.combineLatest([familtyTextValid,
                                                          nameTextValid,
                                                          shopTextValid,
                                                          serviceTextValid,
                                                          mobileTextValid,
                                                          locationTextValid,
                                                          discountTextValid,
                                                          termsCheckValid,
                                                          awareCheckValid]) { (allChecks) -> Bool in
                                                            //print("ALL : ",allChecks)
                                                            let reducedAllChecks = allChecks.reduce(true) {
                                                                (accumulation: Bool, nextValue: Bool) -> Bool in
                                                                return accumulation && nextValue
                                                            }
                                                            //print("   Reduced to \(reducedAllChecks)")
                                                            return reducedAllChecks
        }
        return enableSubmitButton.bind(to: resellerSubmitButton.rx.isEnabled)
    }
    
    @objc func selectCityTapped(_ sender : Any){
        self.delegate.setEditing(false, animated: true)
        let aTextField = sender as! EmptyTextField
        if self.stateCode == nil || self.stateCode == "" {
            self.delegate.alert(Message: "لطفاْ ابتدا استان را انتخاب نمایید")
            return
        }
        let parameters = [
            "state code": self.stateCode!
        ]
        NetworkManager.shared.run(API: "get-state-and-city",QueryString: "", Method: HTTPMethod.post, Parameters: parameters, Header: nil,WithRetry: true)
        let cityDispose = NetworkManager.shared.cityDictionaryObs
            .filter({$0.count > 0})
            .subscribe(onNext: { [unowned self] (innerCityDicObs) in
                let controller = ArrayChoiceTableViewController(innerCityDicObs.keys.sorted(){$0 < $1}) {
                    (selectedOption) in
                    aTextField.text = selectedOption
                    aTextField.sendActions(for: .valueChanged)
                    self.cityCode = innerCityDicObs[selectedOption]
                }
                controller.preferredContentSize = CGSize(width: 250, height: 300)
                self.delegate.showPopup(controller, sourceView: aTextField)
            })
        cityDispose.disposed(by: self.delegate.myDisposeBag)
        disposeList.append(cityDispose)
    }
    
    @objc func selectStateTapped(_ sender : Any){
        self.delegate.setEditing(false, animated: true)
        let aTextField = sender as! EmptyTextField
        
        if NetworkManager.shared.provinceDictionaryObs.value.count > 0 {
            let options = NetworkManager.shared.provinceDictionaryObs.value.keys
            let controller = ArrayChoiceTableViewController(options.sorted(){$0 < $1}) {
                (selectedOption) in
                aTextField.text = selectedOption
                aTextField.sendActions(for: .valueChanged)
                self.cityCode = nil
                self.texts["cityText"]!.text = ""
                self.stateCode = NetworkManager.shared.provinceDictionaryObs.value[selectedOption]
                NetworkManager.shared.cityDictionaryObs = BehaviorRelay<Dictionary<String,String>>(value: Dictionary<String,String>())
            }
            controller.preferredContentSize = CGSize(width: 250, height: options.count*60)
            self.delegate.showPopup(controller, sourceView: aTextField)
            
        }else{
            NetworkManager.shared.run(API: "get-state-and-city",QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil,WithRetry: true)
            let provinceDispose = NetworkManager.shared.provinceDictionaryObs
                .filter({$0.count > 0})
                .subscribe(onNext: { [unowned self] (innerProvinceDicObs) in
                    let controller = ArrayChoiceTableViewController(innerProvinceDicObs.keys.sorted(){$0 < $1}) {
                        (selectedOption) in
                        aTextField.text = selectedOption
                        aTextField.sendActions(for: .valueChanged)
                        self.stateCode = innerProvinceDicObs[selectedOption]
                        self.cityCode = nil
                        self.texts["cityText"]!.text = ""
                        NetworkManager.shared.cityDictionaryObs = BehaviorRelay<Dictionary<String,String>>(value: Dictionary<String,String>())
                    }
                    controller.preferredContentSize = CGSize(width: 250, height: 300)
                    self.delegate.showPopup(controller, sourceView: aTextField)
                })
            provinceDispose.disposed(by: self.delegate.myDisposeBag)
            disposeList.append(provinceDispose)
        }
    }
    
    @objc func selectMaritalStatusTapped(_ sender : Any){
        self.delegate.setEditing(false, animated: true)
        let aTextField = sender as! EmptyTextField
        let options = ["مجرد","متاهل"]
        let controller = ArrayChoiceTableViewController(options.sorted(){$0 < $1}) {
            (selectedOption) in
            aTextField.text = selectedOption
            aTextField.sendActions(for: .valueChanged)
        }
        controller.preferredContentSize = CGSize(width: 250, height: options.count*60)
        self.delegate.showPopup(controller, sourceView: aTextField)
    }
    
    @objc func selectGenderTapped(_ sender : Any){
        self.delegate.setEditing(false, animated: true)
        let aTextField = sender as! EmptyTextField
        let options = ["مرد","زن"]
        let controller = ArrayChoiceTableViewController(options.sorted(){$0 < $1}) {
            (selectedOption) in
            aTextField.text = selectedOption
            aTextField.sendActions(for: .valueChanged)
        }
        controller.preferredContentSize = CGSize(width: 250, height: options.count*60)
        self.delegate.showPopup(controller, sourceView: aTextField)
    }
    
    func getAndSubscribeToProfileInfo()-> Disposable{
        //let aParameter = ["user id":"\(LoginKey.shared.userID)"]
        NetworkManager.shared.run(API: "profile-info", QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil,WithRetry: true)
        return ProfileInfoWrapper.shared.profileInfoObs
            .subscribe(onNext: { [unowned self] (innerProfileInfo) in
                //print("***FillingEDit")
                self.aProfileInfo = innerProfileInfo
                self.fillEditProfileForm(With: innerProfileInfo)
            })
    }
    
    func fillEditProfileForm(With aProfileInfo : ProfileInfo){
        if texts["familyText"] != nil { texts["familyText"]!.text = aProfileInfo.last_name}
        if texts["nameText"] != nil { texts["nameText"]!.text = aProfileInfo.first_name}
        if texts["nationalCodeText"] != nil { texts["nationalCodeText"]!.text = aProfileInfo.national_code}
        if texts["birthDateText"] != nil { texts["birthDateText"]!.text = aProfileInfo.birthdate}
        if texts["maritalStatusText"] != nil { texts["maritalStatusText"]!.text = aProfileInfo.marital_status}
        if texts["emailText"] != nil { texts["emailText"]!.text = aProfileInfo.email}
        //if texts["stateText"] != nil { texts["stateText"]!.text = aProfileInfo.state}
        //if texts["cityText"] != nil { texts["cityText"]!.text = aProfileInfo.city}
        if texts["regionText"] != nil { texts["regionText"]!.text = aProfileInfo.address}
        if texts["mobileText"] != nil { texts["mobileText"]!.text = aProfileInfo.phone}
        if texts["genderText"] != nil { texts["genderText"]!.text = aProfileInfo.gender}
        for akey in texts.keys{
            if let aTextField = texts[akey]
            {
                //print("Sending Value Changed : ",akey,"   ",aTextField)
                aTextField.sendActions(for: .valueChanged)
            }
        }
        //texts["**********"]!.text = aProfileInfo.bio
    }
}
