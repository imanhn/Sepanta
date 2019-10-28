//
//  GetRichUICardRequest.swift
//  Sepanta
//
//  Created by Iman on 8/3/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//
import Foundation
import UIKit
import RxCocoa
import RxSwift
import AlamofireImage
import Alamofire
import MapKit

extension GetRichUI {
    func showCardRequest(_ avc: GetRichViewController) {
        self.delegate = avc
        //print("Card Request  : ",views["rightFormView"]!,"  SuperView : ",views["rightFormView"]!.superview ?? "Nil")
        if views["rightFormView"]?.superview != nil {
            disposeList.forEach({$0.dispose()})
            views["afterRegionView"]?.subviews.forEach({$0.removeFromSuperview()})
            views["rightFormView"]?.removeFromSuperview()
            codePrefix = ""
            mobilePrefix = ""
            cardNoPrefix = ""
        }
        
        var cursurY: CGFloat = 0
        let marginY: CGFloat = 10
        let marginX: CGFloat = 20
        views["leftFormView"] = LeftTabbedViewWithWhitePanel(frame: CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width-40, height: UIScreen.main.bounds.height * 1))
        views["leftFormView"]!.backgroundColor = UIColor.clear
        buttonHeight = (views["leftFormView"] as! LeftTabbedViewWithWhitePanel).getHeight()
        self.delegate.scrollView.addSubview(views["leftFormView"]!)
        
        let buttonsFont = UIFont(name: "Shabnam-Bold-FD", size: 14)
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
        buttons["rightButton"]!.setTitleColor(UIColor(hex: 0xD6D7D9), for: .normal)
        
        views["leftFormView"]!.addSubview(buttons["rightButton"]!)
        cursurY += buttonHeight + marginY
        
        (views["familyView"], texts["familyText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: (textFieldWidth / 2)-(marginX/4), height: buttonHeight), Image: "icon_profile_04", Selectable: false, PlaceHolderText: "نام خانوادگی")
        //texts["familyText"]!.text =  aProfileInfo.last_name
        views["leftFormView"]!.addSubview(views["familyView"]!)
        (views["nameView"], texts["nameText"]) = buildARowView(CGRect: CGRect(x: (textFieldWidth / 2)+(marginX/4)+marginX, y: cursurY, width: (textFieldWidth / 2)-marginX/4, height: buttonHeight), Image: "icon_profile_03", Selectable: false, PlaceHolderText: "نام")
        //texts["nameText"]!.text =  aProfileInfo.first_name
        views["leftFormView"]!.addSubview(views["nameView"]!)
        cursurY += buttonHeight + marginY
        
        let aRadioView = RadioView(frame: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight),items: ["ایرانی","غیر ایرانی"])
        views["leftFormView"]?.addSubview(aRadioView)
        cursurY += buttonHeight + marginY

        (views["nationalCodeView"], texts["nationalCodeText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "identity-card", Selectable: false, PlaceHolderText: "کد ملی")
        //texts["nationalCodeText"]!.text =  aProfileInfo.national_code
        texts["nationalCodeText"]?.keyboardType = UIKeyboardType.numberPad
        views["leftFormView"]?.addSubview(views["nationalCodeView"]!)
        nationalCodeCity =  createNationalCodeCity(CursurY: cursurY)
        views["leftFormView"]?.addSubview(nationalCodeCity)
        cursurY += buttonHeight + marginY
        
        (views["birthCertCodeView"], texts["birthCertCodeText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "identity-card", Selectable: false, PlaceHolderText: "شماره شناسنامه")
        //texts["nationalCodeText"]!.text =  aProfileInfo.national_code
        texts["birthCertCodeText"]?.keyboardType = UIKeyboardType.numberPad
        views["leftFormView"]?.addSubview(views["birthCertCodeView"]!)
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
        views["leftFormView"]?.addSubview(views["birthDateView"]!)
        cursurY += buttonHeight + marginY
        
        (views["genderView"], texts["genderText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "genders", Selectable: true, PlaceHolderText: "جنسیت")
        //texts["genderText"]!.text =  aProfileInfo.gender
        texts["genderText"]?.addTarget(self, action: #selector(selectGenderTapped), for: .touchDown)
        views["leftFormView"]?.addSubview(views["genderView"]!)
        cursurY += buttonHeight + marginY
        
        (views["maritalStatusView"], texts["maritalStatusText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "marriage-rings-couple-with-a-heart", Selectable: true, PlaceHolderText: "وضعیت تاهل")
        texts["maritalStatusText"]?.addTarget(self, action: #selector(selectMaritalStatusTapped), for: .touchDown)
        views["leftFormView"]?.addSubview(views["maritalStatusView"]!)
        cursurY += buttonHeight + marginY
        
        (views["emailView"], texts["emailText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "black-back-closed-envelope-shape", Selectable: false, PlaceHolderText: "ایمیل")
        texts["emailText"]?.keyboardType = UIKeyboardType.emailAddress
        views["leftFormView"]?.addSubview(views["emailView"]!)
        cursurY += buttonHeight + marginY
        
        (views["mobileNoView"], texts["mobileText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_07", Selectable: false, PlaceHolderText: "شماره همراه")
        //texts["mobileText"]!.text =  aProfileInfo.phone
        texts["mobileText"]?.keyboardType = UIKeyboardType.phonePad
        views["leftFormView"]?.addSubview(views["mobileNoView"]!)
        mobileLogo = createMobileLogo(CursurY: cursurY)
        views["leftFormView"]?.addSubview(mobileLogo)
        cursurY += buttonHeight + marginY
        
        //texts["mobileText"]
        
        (views["stateView"], texts["stateText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "map", Selectable: true, PlaceHolderText: "استان")
        texts["stateText"]?.addTarget(self, action: #selector(selectStateTapped), for: .touchDown)
        views["leftFormView"]?.addSubview(views["stateView"]!)
        cursurY += buttonHeight + marginY
        
        (views["cityView"], texts["cityText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "NOIMAGE", Selectable: true, PlaceHolderText: "شهر")
        texts["cityText"]?.addTarget(self, action: #selector(selectCityTapped), for: .touchDown)
        views["leftFormView"]?.addSubview(views["cityView"]!)
        cursurY += buttonHeight + marginY
        
        // When there is no region, the rest of items should get scrolled up and the regionView should be hided
        // in order to do this I have defined a new View (afterRegionView) and added all view items below regionView to it
        // when ever it is needed to hide region afterRegionView is moved up and when there is a region list for the selected city
        // I just move the afterRegionView down and make regionView.hidden=false (this is done in selectCityTapped
        views["afterRegionView"] = UIView(frame: CGRect(x: 20, y: cursurY+20, width: UIScreen.main.bounds.width-40, height: UIScreen.main.bounds.height * 1))
        //self.delegate.scrollView.addSubview(views["afterRegionView"]!)
        
        (views["regionView"], texts["regionText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "NOIMAGE", Selectable: true, PlaceHolderText: "منطقه")
         texts["regionText"]?.addTarget(self, action: #selector(selectRegionTapped), for: .touchDown)
        views["leftFormView"]?.addSubview(views["regionView"]!)
        views["regionView"]?.isHidden = true
        //cursurY += buttonHeight + marginY  // Commented because the default value for regionView.isHidden is true! for false it should be uncommented

        var animatedPartCursurY : CGFloat = 0
        
        (views["addressView"], texts["addressText"]) = buildARowView(CGRect: CGRect(x: marginX, y: animatedPartCursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_05", Selectable: false, PlaceHolderText: "آدرس")
        views["afterRegionView"]?.addSubview(views["addressView"]!)
        animatedPartCursurY += buttonHeight + marginY
        
        (views["postalCodeView"], texts["postalCodeText"]) = buildARowView(CGRect: CGRect(x: marginX, y: animatedPartCursurY, width: textFieldWidth, height: buttonHeight), Image: "icon_profile_05", Selectable: false, PlaceHolderText: "کد پستی")
        texts["postalCodeText"]?.keyboardType = UIKeyboardType.numberPad
        views["afterRegionView"]?.addSubview(views["postalCodeView"]!)
        animatedPartCursurY += buttonHeight + marginY

        cardRequestType = RadioView(frame: CGRect(x: marginX, y: animatedPartCursurY, width: textFieldWidth, height: buttonHeight),items: ["درخواست کارت جدید","تعریف روی کارت دیگر"])
        //views["leftFormView"]?.addSubview(cardRequestType)
        views["afterRegionView"]?.addSubview(cardRequestType)
        animatedPartCursurY += buttonHeight + marginY
        let cardRequestTypeDisp = cardRequestType.selectedItem.subscribe(
            onNext: { aSelectedItem in
                if (aSelectedItem == 1) {
                    self.addCardRows()
                } else {
                    self.removeCardRows()
                }
        })
        disposeList.append(cardRequestTypeDisp)
        cardRequestTypeDisp.disposed(by: myDisposeBag)
        
        (views["cardNoView"], texts["cardNoText"]) = buildARowView(CGRect: CGRect(x: marginX+buttonHeight+marginX, y: animatedPartCursurY, width: textFieldWidth-(buttonHeight+marginX), height: buttonHeight), Image: "credit-card", Selectable: false, PlaceHolderText: "شماره کارت")
        //views["leftFormView"]?.addSubview(views["cardNoView"]!)
        views["afterRegionView"]?.addSubview(views["cardNoView"]!)
        texts["cardNoText"]?.keyboardType = UIKeyboardType.decimalPad
        if self.delegate.cardNo != nil {
            texts["cardNoText"]!.text = self.delegate.cardNo
            texts["cardNoText"]!.sendActions(for: .valueChanged)
        }
        bankLogo = UIImageView(frame: CGRect(x: marginX, y: animatedPartCursurY, width: buttonHeight, height: buttonHeight))
        //views["leftFormView"]?.addSubview(bankLogo)
        views["afterRegionView"]?.addSubview(bankLogo)
        animatedPartCursurY += buttonHeight + marginY
        let bankDispose = NetworkManager.shared.bankObs
            .filter({$0.bank != nil && $0.bank!.count > 0})
            .subscribe(onNext: { aBank in
                if aBank.logo != nil {
                    let imageStrUrl = NetworkManager.shared.websiteRootAddress + SlidesAndPaths.shared.path_bank_logo_image + aBank.logo!
                    print("imageStrUrl : ", imageStrUrl)
                    if let imageURL = URL(string: imageStrUrl) {
                        print("imageURL : ", imageURL)
                        print("size : ", self.bankLogo.frame.size)
                        self.bankLogo.af_setImage(withURL: imageURL, placeholderImage: UIImage(named: "bank-building"), filter: AspectScaledToFitSizeFilter(size: self.bankLogo.frame.size))
                        //bankLogo.setImageFromCache(PlaceHolderName: "bank-building", Scale: 1, ImageURL: imageURL, ImageName: aBank.logo!,ContentMode: UIViewContentMode.scaleAspectFit)
                    }
                }
                //self.texts["bankText"]?.text = aBank.bank
            })
        bankDispose.disposed(by: self.delegate.myDisposeBag)
        disposeList.append(bankDispose)
        let cardDispose = texts["cardNoText"]!.rx.text
            .subscribe(onNext: { aCardNumber in
                if (aCardNumber?.count)! >= 6 {
                    let cardNumberPrefix = aCardNumber!.prefix(6).description
                    if self.cardNoPrefix != cardNumberPrefix {
                        let aParameter = ["card_number": "\(String(describing: cardNumberPrefix))"]
                        self.cardNoPrefix = cardNumberPrefix
                        NetworkManager.shared.run(API: "check-bank", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: true)
                    }
                } else {
                    self.bankLogo.image = nil //UIImage(named: "bank-building")
                    self.bankLogo.contentScaleFactor = 0.5
                    self.cardNoPrefix = ""
                    //self.texts["bankText"]?.text = nil
                }
            }
        )
        cardDispose.disposed(by: self.delegate.myDisposeBag)
        disposeList.append(cardDispose)
        views["cardNoView"]?.isHidden = true
        bankLogo.isHidden = true
        animatedPartCursurY += buttonHeight/2
        
        cardSubmitButton = SubmitButton(type: .custom)
        cardSubmitButton.frame = CGRect(x: marginX+(textFieldWidth/2)-1.5*buttonHeight, y: animatedPartCursurY-buttonHeight, width: 3*buttonHeight, height: buttonHeight)
        cardSubmitButton.setTitle("ارسال", for: .normal)
        cardSubmitButton.addTarget(self, action: #selector(self.cardRequestSubmitTapped(_:)), for: .touchUpInside)
        views["afterRegionView"]?.addSubview(cardSubmitButton)
        animatedPartCursurY += buttonHeight + marginY
        
        views["afterRegionView"]?.frame = CGRect(x: 20, y: cursurY+20, width: UIScreen.main.bounds.width-40, height: animatedPartCursurY)
        self.delegate.scrollView.addSubview(views["afterRegionView"]!)        
        
        cursurY += animatedPartCursurY
        let formSize = CGSize(width: UIScreen.main.bounds.width, height: cursurY*1.2)
        self.delegate.scrollView.contentSize = formSize
        views["leftFormView"]?.frame = CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width-40, height: cursurY+buttonHeight*0.5)
        getAndSubscribeToLastCard()
        submitDispose = handleCardSubmitButtonEnableOrDisable()
        cardSubmitButton.isEnabled = true
        disposeList.append(submitDispose)
        
    }
    
    func addCardRows() {
        cardSubmitButton.frame = CGRect(x: cardSubmitButton.frame.minX, y: cardSubmitButton.frame.minY+buttonHeight, width: cardSubmitButton.frame.width, height: cardSubmitButton.frame.height)
        views["cardNoView"]?.isHidden = false
        bankLogo.isHidden = false
    }
    
    func removeCardRows() {
        cardSubmitButton.frame = CGRect(x: cardSubmitButton.frame.minX, y: cardSubmitButton.frame.minY-buttonHeight, width: cardSubmitButton.frame.width, height: cardSubmitButton.frame.height)
        views["cardNoView"]?.isHidden = true
        bankLogo.isHidden = true
    }
    
    func handleCardSubmitButtonEnableOrDisable() -> Disposable {
        let familtyTextValid = texts["familyText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let nameTextValid = texts["nameText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let nationalCodeValid = texts["nationalCodeText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let birthDateTextValid = texts["birthCertCodeText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let genderTextValid = texts["genderText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let maritalStatusTextValid = texts["maritalStatusText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let postalCodeTextValid = texts["postalCodeText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let mobileTextValid = texts["mobileText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let stateTextValid = texts["stateText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let cityTextValid = texts["cityText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        //let regionTextValid = texts["regionText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        
        let enableSubmitButton = Observable.combineLatest([familtyTextValid,
                                                           nameTextValid,
                                                           nationalCodeValid,
                                                           birthDateTextValid,
                                                           genderTextValid,
                                                           maritalStatusTextValid,
                                                           postalCodeTextValid,
                                                           mobileTextValid,
                                                           stateTextValid,
                                                           cityTextValid]) { (allChecks) -> Bool in
                                                            print("ALL : ",allChecks)
                                                            let reducedAllChecks = allChecks.reduce(true) { (accumulation: Bool, nextValue: Bool) -> Bool in
                                                                return accumulation && nextValue
                                                            }
                                                            //print("   Reduced to \(reducedAllChecks)")
                                                            //if self.texts["cardNoText"] == nil || self.texts["cardNoText"]?.text?.count != 16 { return false }
                                                            return reducedAllChecks
        }
        return enableSubmitButton.bind(to: cardSubmitButton.rx.isEnabled)
        
    }
    
    @objc func cardRequestSubmitTapped(_ sender: Any) {
        guard (self.cardRequestType.selectedItem.value == 0) || (self.texts["cardNoText"]?.text?.count == 16) else {
            self.delegate.alert(Message: "لطفا شماره کارت را کامل وارد کنید")
            return
        }
        var aCardType = CardType.Sepanta
        let cardIdString = "\(self.cardId ?? 1)"
        if cardRequestType.selectedItem.value == 1 { aCardType = CardType.Other }
        let aParameter = [
            "first_name": "\(texts["nameText"]?.text ?? "")",
            "last_name": "\(texts["familyText"]?.text ?? "")",
            "national_code": "\(texts["nationalCodeText"]?.text ?? "")",
            "gender": "\(genderCode ?? "")",
            "martial_status":"\(maritalStatusCode ?? "")",
            "email":"\(texts["emailText"]?.text ?? "")",
            "sh_code":"\(texts["birthCertCodeText"]?.text ?? "")",
            "cellphone": "\(texts["mobileText"]?.text ?? "")",
            "addres": "\(texts["addressText"]?.text ?? "")",
            "birthdate": "\(texts["birthDateText"]?.text ?? "")",
            "post_code": "\(texts["postalCodeText"]?.text ?? "")",
            "city_code":"\(self.cityCode ?? "0")",
            "state_code":"\(self.stateCode ?? "0")",
            "cardnumber": "\(texts["cardNoText"]?.text ?? "")",
            "card_id": cardIdString
        ]
        print("aParameter : \(aParameter)")
        let cardRequestDisp = CardRequest(Parameter: aParameter).results()
            .subscribe(onNext: {aNetworkResponse in
                if aNetworkResponse.status == "error" {
                    if let message = aNetworkResponse.message {
                        self.delegate.alert(Message: message)
                    } else {
                        self.delegate.alert(Message: "خطا در ثبت کارت، مجدد تلاش بفرمایید")
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        self.delegate.coordinator?.pushPayment(CardId : cardIdString,Type: aCardType)
                    })
                }
            }, onError: {_ in })
        cardRequestDisp.disposed(by: myDisposeBag)
        disposeList.append(cardRequestDisp)
    }
}
