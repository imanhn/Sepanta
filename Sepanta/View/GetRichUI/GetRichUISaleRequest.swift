//
//  GetRichUISaleRequest.swift
//  Sepanta
//
//  Created by Iman on 8/3/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
extension GetRichUI {
    //Create Gradient on PageView
    func showResellerRequest(_ avc: GetRichViewController) {
        self.delegate = avc
        //print("reseller Request : ",views["leftFormView"] ?? "Nil")
        if views["leftFormView"] != nil && views["leftFormView"]?.superview != nil {
            disposeList.forEach({$0.dispose()})
            views["afterRegionView"]?.subviews.forEach({$0.removeFromSuperview()})
            views["leftFormView"]?.removeFromSuperview()
            codePrefix = ""
            mobilePrefix = ""
            cardNoPrefix = ""
        }
        var cursurY: CGFloat = 0
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
        buttonHeight = (views["rightFormView"] as! RightTabbedViewWithWhitePanel).getHeight()
        self.delegate.scrollView.addSubview(views["rightFormView"]!)
        textFieldWidth = (views["rightFormView"]?.bounds.width)! - (2 * marginX)
        
        buttons["leftButton"] = UIButton(frame: CGRect(x: 0, y: 0, width: (views["rightFormView"]?.bounds.width)!/2, height: buttonHeight))
        buttons["leftButton"]!.setTitle("درخواست کارت", for: .normal)
        buttons["leftButton"]!.titleLabel?.font = buttonsFont
        buttons["leftButton"]!.addTarget(self.delegate, action: #selector(self.delegate.cardRequestTapped), for: .touchUpInside)
        buttons["leftButton"]!.setTitleColor(UIColor(hex: 0xD6D7D9), for: .normal)
        
        buttons["rightButton"] = UIButton(frame: CGRect(x: views["rightFormView"]!.bounds.width/2, y: 0, width: views["rightFormView"]!.bounds.width/2, height: buttonHeight))
        buttons["rightButton"]!.setTitle("درخواست فروشندگی", for: .normal)
        buttons["rightButton"]!.titleLabel?.font = buttonsFont
        buttons["rightButton"]!.setTitleColor(UIColor(hex: 0x515152), for: .normal)
        
        views["rightFormView"]!.addSubview(buttons["leftButton"]!)
        views["rightFormView"]!.addSubview(buttons["rightButton"]!)
        cursurY += buttonHeight + marginY
        
        (views["shopView"], texts["shopText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_01", Selectable: false, PlaceHolderText: "نام فروشگاه")
        views["rightFormView"]?.addSubview(views["shopView"]!)
        cursurY += buttonHeight + marginY
        
        (views["serviceView"], texts["serviceText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_02", Selectable: true, PlaceHolderText: "انتخاب دسته بندی")
        texts["serviceText"]?.addTarget(self, action: #selector(selectServiceTypeTapped), for: .touchDown)
        views["rightFormView"]?.addSubview(views["serviceView"]!)
        cursurY += buttonHeight + marginY
        
        (views["familyView"], texts["familyText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: (textFieldWidth / 2)-(marginX/4), height: buttonHeight), Image: "icon_profile_04", Selectable: false, PlaceHolderText: "نام خانوادگی")
        //texts["familyText"]!.text =  aProfileInfo.last_name
        views["rightFormView"]?.addSubview(views["familyView"]!)
        (views["nameView"], texts["nameText"]) = buildARowView(CGRect: CGRect(x: (textFieldWidth / 2)+(marginX/4)+marginX, y: cursurY, width: (textFieldWidth / 2)-marginX/4, height: buttonHeight), Image: "icon_profile_03", Selectable: false, PlaceHolderText: "نام")
        //texts["nameText"]!.text =  aProfileInfo.first_name
        views["rightFormView"]?.addSubview(views["nameView"]!)
        cursurY += buttonHeight + marginY
        
        let aRadioView = RadioView(frame: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight),items: ["ایرانی","غیر ایرانی"])
        views["rightFormView"]?.addSubview(aRadioView)
        cursurY += buttonHeight + marginY
        //aRadioView.selectedItem.sub

        (views["nationalCodeView"], texts["nationalCodeText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "identity-card", Selectable: false, PlaceHolderText: "کد ملی")
        //texts["nationalCodeText"]!.text =  aProfileInfo.national_code
        texts["nationalCodeText"]?.keyboardType = UIKeyboardType.numberPad
        views["rightFormView"]?.addSubview(views["nationalCodeView"]!)
        nationalCodeCity =  createNationalCodeCity(CursurY: cursurY)
        views["rightFormView"]?.addSubview(nationalCodeCity)
        cursurY += buttonHeight + marginY
        
        (views["birthDateView"], texts["birthDateText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "calendar-page-empty", Selectable: false, PlaceHolderText: "تاریخ تولد")
        datePicker.calendar = Calendar(identifier: Calendar.Identifier.persian)
        datePicker.locale = Locale(identifier: "fa_IR")
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "ثبت", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneDatePicker(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "لغو", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelDatePicker(_:)))
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        //adatePicker.inp
        texts["birthDateText"]?.inputAccessoryView = toolbar
        texts["birthDateText"]?.inputView = datePicker
        views["rightFormView"]?.addSubview(views["birthDateView"]!)
        cursurY += buttonHeight + marginY
        
        (views["stateView"], texts["stateText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "map", Selectable: true, PlaceHolderText: "استان")
        //texts["stateText"]!.text =  aProfileInfo.state
        texts["stateText"]?.addTarget(self, action: #selector(selectStateTapped), for: .touchDown)
        views["rightFormView"]?.addSubview(views["stateView"]!)
        cursurY += buttonHeight + marginY
        
        (views["cityView"], texts["cityText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "NOIMAGE", Selectable: true, PlaceHolderText: "شهر")
        //texts["cityText"]!.text =  aProfileInfo.city
        texts["cityText"]?.addTarget(self, action: #selector(selectCityTapped), for: .touchDown)
        views["rightFormView"]?.addSubview(views["cityView"]!)
        cursurY += buttonHeight + marginY

        // When there is no region, the rest of items should get scrolled up and the regionView should be hided
        // in order to do this I have defined a new View (afterRegionView) and added all view items below regionView to it
        // when ever it is needed to hide region afterRegionView is moved up and when there is a region list for the selected city
        // I just move the afterRegionView down and make regionView.hidden=false (this is done in selectCityTapped
        views["afterRegionView"] = UIView(frame: CGRect(x: 20, y: cursurY+20, width: UIScreen.main.bounds.width-40, height: UIScreen.main.bounds.height * 1))
        self.delegate.scrollView.addSubview(views["afterRegionView"]!)
        
        (views["regionView"], texts["regionText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "NOIMAGE", Selectable: true, PlaceHolderText: "منطقه")
        texts["regionText"]?.addTarget(self, action: #selector(selectRegionTapped), for: .touchDown)
        views["rightFormView"]?.addSubview(views["regionView"]!)
        views["regionView"]?.isHidden = true
        //cursurY += buttonHeight + marginY  // Commented because the default value for regionView.isHidden is true! for false it should be uncommented
        
        var animatedPartCursurY : CGFloat = 0
        
        (views["locationView"], texts["addressText"]) = buildARowView(CGRect: CGRect(x: marginX+buttonHeight+marginX, y: animatedPartCursurY, width: textFieldWidth-(buttonHeight+marginX), height: buttonHeight), Image: "icon_profile_05", Selectable: false, PlaceHolderText: "آدرس")
        views["afterRegionView"]?.addSubview(views["locationView"]!)
        locationButton = RoundedButton(frame: CGRect(x: marginX, y: animatedPartCursurY, width: buttonHeight, height: buttonHeight))
        locationButton.setImage(UIImage(named: "icon_location"), for: .normal)
        locationButton.addTarget(self, action: #selector(selectOnMapTapped), for: .touchUpInside)
        views["afterRegionView"]?.addSubview(locationButton)
        animatedPartCursurY += buttonHeight + marginY
        
        (views["phoneNumberView"], texts["phoneNumberText"]) = buildARowView(CGRect: CGRect(x: marginX, y: animatedPartCursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_08", Selectable: false, PlaceHolderText: "تلفن فروشگاه")
        texts["phoneNumberText"]?.keyboardType = UIKeyboardType.numberPad
        views["afterRegionView"]?.addSubview(views["phoneNumberView"]!)
        animatedPartCursurY += buttonHeight + (2 * marginY)
        
        (views["mobileNoView"], texts["mobileText"]) = buildARowView(CGRect: CGRect(x: marginX, y: animatedPartCursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_07", Selectable: false, PlaceHolderText: "شماره همراه")
        //texts["mobileText"]!.text =  aProfileInfo.phone
        texts["mobileText"]?.keyboardType = UIKeyboardType.phonePad
        views["afterRegionView"]?.addSubview(views["mobileNoView"]!)
        mobileLogo = createMobileLogo(CursurY: animatedPartCursurY)
        views["afterRegionView"]?.addSubview(mobileLogo)
        animatedPartCursurY += buttonHeight + marginY
        
        (views["discountRateView"], texts["discountText"]) = buildARowView(CGRect: CGRect(x: marginX, y: animatedPartCursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_08", Selectable: false, PlaceHolderText: "درصد تخفیف پیشنهادی")
        texts["discountText"]?.keyboardType = UIKeyboardType.numberPad
        views["afterRegionView"]?.addSubview(views["discountRateView"]!)
        animatedPartCursurY += buttonHeight + (2 * marginY)
        
        awareCheckButton = UIButton(type: .custom)
        awareCheckButton.frame = CGRect(x: marginX+textFieldWidth-buttonHeight, y: animatedPartCursurY, width: buttonHeight, height: buttonHeight)
        awareCheckButton.backgroundColor = UIColor(hex: 0xD6D7D9)
        awareCheckButton.setImage(UIImage(named: "icon_tick_white"), for: .normal)
        awareCheckButton.contentMode = .scaleAspectFit
        awareCheckButton.addTarget(self, action: #selector(self.awareButtonTapped(_:)), for: .touchUpInside)
        views["afterRegionView"]?.addSubview(awareCheckButton)
        labels["awareLabel"] = UILabel(frame: CGRect(x: marginX, y: animatedPartCursurY, width: textFieldWidth-buttonHeight-(marginX/2), height: buttonHeight))
        labels["awareLabel"]!.textColor = UIColor(hex: 0xD6D7D9)
        labels["awareLabel"]!.text = "آیا فروشگاه آگاه است"
        labels["awareLabel"]!.textAlignment = .right
        labels["awareLabel"]!.font = UIFont(name: "Shabnam-FD", size: 14)
        views["afterRegionView"]?.addSubview(labels["awareLabel"]!)
        animatedPartCursurY += buttonHeight + (1 * marginY)
        
        areYouOwnerCheckButton = UIButton(type: .custom)
        areYouOwnerCheckButton.frame = CGRect(x: marginX+textFieldWidth-buttonHeight, y: animatedPartCursurY, width: buttonHeight, height: buttonHeight)
        areYouOwnerCheckButton.backgroundColor = UIColor(hex: 0xD6D7D9)
        areYouOwnerCheckButton.setImage(UIImage(named: "icon_tick_white"), for: .normal)
        areYouOwnerCheckButton.contentMode = .scaleAspectFit
        areYouOwnerCheckButton.addTarget(self, action: #selector(self.areYouOwnerButtonTapped(_:)), for: .touchUpInside)
        views["afterRegionView"]?.addSubview(areYouOwnerCheckButton)
        labels["areYouOwnerLabel"] = UILabel(frame: CGRect(x: marginX, y: animatedPartCursurY, width: textFieldWidth-buttonHeight-(marginX/2), height: buttonHeight))
        labels["areYouOwnerLabel"]!.textColor = UIColor(hex: 0xD6D7D9)
        labels["areYouOwnerLabel"]!.text = "آیا مالک فروشگاه هستید؟"
        labels["areYouOwnerLabel"]!.textAlignment = .right
        labels["areYouOwnerLabel"]!.font = UIFont(name: "Shabnam-FD", size: 14)
        views["afterRegionView"]?.addSubview(labels["areYouOwnerLabel"]!)
        animatedPartCursurY += buttonHeight + (1 * marginY)
        
        licenceCheckButton = UIButton(type: .custom)
        licenceCheckButton.frame = CGRect(x: marginX+textFieldWidth-buttonHeight, y: animatedPartCursurY, width: buttonHeight, height: buttonHeight)
        licenceCheckButton.backgroundColor = UIColor(hex: 0xD6D7D9)
        licenceCheckButton.setImage(UIImage(named: "icon_tick_white"), for: .normal)
        licenceCheckButton.contentMode = .scaleAspectFit
        licenceCheckButton.addTarget(self, action: #selector(self.licenceButtonTapped(_:)), for: .touchUpInside)
        views["afterRegionView"]?.addSubview(licenceCheckButton)
        labels["licenceLabel"] = UILabel(frame: CGRect(x: marginX, y: animatedPartCursurY, width: textFieldWidth-buttonHeight-(marginX/2), height: buttonHeight))
        labels["licenceLabel"]!.textColor = UIColor(hex: 0xD6D7D9)
        labels["licenceLabel"]!.text = "آیا مجوز صنفی دارید؟"
        labels["licenceLabel"]!.textAlignment = .right
        labels["licenceLabel"]!.font = UIFont(name: "Shabnam-FD", size: 14)
        views["afterRegionView"]?.addSubview(labels["licenceLabel"]!)
        animatedPartCursurY += buttonHeight + buttonHeight*2/3
        
        resellerSubmitButton = SubmitButton(type: .custom)
        resellerSubmitButton.frame = CGRect(x: marginX+(textFieldWidth/2)-1.5*buttonHeight, y: animatedPartCursurY, width: 3*buttonHeight, height: buttonHeight)
        resellerSubmitButton.setTitle("ارسال", for: .normal)
        resellerSubmitButton.addTarget(self, action: #selector(self.sellRequestSubmitTapped(_:)), for: .touchUpInside)
        views["afterRegionView"]?.addSubview(resellerSubmitButton)
        animatedPartCursurY += buttonHeight + (1 * marginY)
        
        views["afterRegionView"]?.frame = CGRect(x: 20, y: cursurY+20, width: UIScreen.main.bounds.width-40, height: animatedPartCursurY)
        cursurY += animatedPartCursurY
         self.delegate.scrollView.addSubview(views["afterRegionView"]!)
        let formSize = CGSize(width: UIScreen.main.bounds.width, height: cursurY*1.2)
        self.delegate.scrollView.contentSize = formSize
        views["rightFormView"]?.frame = CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width-40, height: cursurY+buttonHeight*1.5)
        getAndSubscribeToLastCard()
        submitDispose = handleResellerSubmitButtonEnableOrDisable()
        disposeList.append(submitDispose)
        
    }
}
