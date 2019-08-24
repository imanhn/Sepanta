//
//  SignUPUI.swift
//  Sepanta
//
//  Created by Iman on 2/11/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Alamofire

class SignUPUI: NSObject, UITextFieldDelegate {
    var delegate: SignupViewController
    var mobileText = UITextField()
    var usernameText = UITextField()
    var genderText = UITextField()
    var provinceText = UITextField()
    var cityText = UITextField()

    var mobileView = UIView()
    var usernameView = UIView()
    var genderView = UIView()
    var provinceView = UIView()
    var cityView = UIView()

    var termsCheckButton = UIButton(type: .custom)
    var termLabel = UILabel()
    var termsAgreed: Bool = false

    var submitButton = UIButton(type: .custom)
    var stateCode: String!
    var cityCode: String!

    var disposeList = [Disposable]()

    init(_ vc: SignupViewController) {
        self.delegate = vc
        super.init()
        showSignUpForm()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // IMPORTANT : *** BuildRow set 11 for tag of selectable textfield (See BuildRow function)
        if textField.tag == 11 {
            return false

        } else {
            // edittingView is set for keyboard notification manageing facility to find out if we should move the keyboard up or not!
            self.delegate.edittingView = textField
            return true
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        //print("Text ",range," str : ",string," currnet : ",currentText,"  Updated :  ",updatedText)
        if textField.tag == 13 {
            if string.containPersianChar() { return false}
            if string.containSymbol() { return false}
            if updatedText.count > 0 {
                if Int(updatedText.slice(From: 0, To: 0)) != nil {return false}
            }
            if updatedText.count > 25 {return false}
        }
        if textField.tag == 12 {
            if updatedText.count > 0 && updatedText.first != "0" {return false}
            if updatedText.count > 1 && updatedText.slice(From: 0, To: 1) != "09" {return false}
            if updatedText.count > 11 {return false}
        }
        return true
    }

    //Create Gradient on PageView
    func showSignUpForm() {
        var cursurY: CGFloat = 0
        let marginY: CGFloat = 5
        let marginX: CGFloat = 10

        let buttonHeight = (self.delegate.signUpFormView.frame.height / 5) - marginY
        let textFieldWidth = (self.delegate.signUpFormView.bounds.width) - (2 * marginX)

        (mobileView, mobileText) = CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight).buildARowView( Image: "icon_profile_07", Selectable: false, PlaceHolderText: "شماره همراه")
        mobileText.keyboardType = UIKeyboardType.numberPad
        mobileText.tag = 12
        mobileText.clearButtonMode = .whileEditing
        mobileText.semanticContentAttribute = .forceRightToLeft
        self.delegate.signUpFormView.addSubview(mobileView)
        mobileText.delegate = self
        cursurY += buttonHeight + marginY

        (usernameView, usernameText) = CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight).buildARowView( Image: "icon_profile_03", Selectable: false, PlaceHolderText: "نام کاربری")
        self.delegate.signUpFormView.addSubview(usernameView)
        usernameText.delegate = self
        usernameText.tag = 13
        usernameText.clearButtonMode = .whileEditing
        usernameText.semanticContentAttribute = .forceRightToLeft
        cursurY += buttonHeight + marginY

        (genderView, genderText) = CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight).buildARowView( Image: "icon_gen_gray", Selectable: true, PlaceHolderText: "انتخاب جنسیت")
        genderText.addTarget(self, action: #selector(selectGenderTapped), for: .touchDown)
        self.delegate.signUpFormView.addSubview(genderView)
        genderText.delegate = self
        cursurY += buttonHeight + marginY

        (provinceView, provinceText) = CGRect(x: (textFieldWidth / 2)+(marginX/4)+marginX, y: cursurY, width: (textFieldWidth / 2)-marginX/4, height: buttonHeight).buildARowView( Image: "icon_profile_05", Selectable: true, PlaceHolderText: "انتخاب استان")
        provinceText.addTarget(self, action: #selector(selectStateTapped), for: .touchDown)
        provinceText.delegate = self
        self.delegate.signUpFormView.addSubview(provinceView)

        (cityView, cityText) = CGRect(x: marginX, y: cursurY, width: (textFieldWidth / 2)-(marginX/4), height: buttonHeight).buildARowView( Image: "", Selectable: true, PlaceHolderText: "انتخاب شهر")
        cityText.addTarget(self, action: #selector(selectCityTapped), for: .touchDown)
        self.delegate.signUpFormView.addSubview(cityView)
        cityText.delegate = self
        cursurY += buttonHeight + marginY

        termsCheckButton = UIButton(type: .custom)
        termsCheckButton.frame = CGRect(x: marginX+textFieldWidth-buttonHeight+(buttonHeight*0.1), y: cursurY+(buttonHeight*0.1), width: buttonHeight*0.8, height: buttonHeight*0.8)
        termsCheckButton.backgroundColor = UIColor(hex: 0xD6D7D9)
        termsCheckButton.setImage(UIImage(named: "icon_tick_white"), for: .normal)
        termsCheckButton.contentMode = .scaleAspectFit
        termsCheckButton.addTarget(self, action: #selector(self.termsButtonTapped(_:)), for: .touchUpInside)
        self.delegate.signUpFormView.addSubview(termsCheckButton)
        termLabel = UILabel(frame: CGRect(x: marginX, y: cursurY, width: textFieldWidth-buttonHeight-(marginX/2), height: buttonHeight))
        termLabel.textColor = UIColor(hex: 0xD6D7D9)

        let termsText = "قوانین و مقررات را خوانده ام و موافقم"
        let attributedText = NSMutableAttributedString(string: termsText)
        attributedText.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: 15))
        attributedText.addAttribute(.foregroundColor, value: UIColor.blue, range: NSRange(location: 0, length: 15))
        termLabel.attributedText = attributedText
        termLabel.textAlignment = .right
        termLabel.font = UIFont(name: "Shabnam-FD", size: 14)

        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTerms))
        termLabel.isUserInteractionEnabled = true
        termLabel.addGestureRecognizer(tap)
        self.delegate.signUpFormView.addSubview(termLabel)
        cursurY += buttonHeight + buttonHeight*2/3

        let submitDispose = handleSubmitStatus()
        disposeList.append(submitDispose)

    }

    @objc func viewTerms() {
        let offsetY = self.delegate.view.frame.height*0.1
        let offsetX = self.delegate.view.frame.width*0.1
        let aTermView = TermsView(frame: CGRect(x: offsetX, y: offsetY, width: self.delegate.view.frame.width-(2*offsetX), height: self.delegate.view.frame.height-(2*offsetY)))

        if let rtfPath = Bundle.main.url(forResource: "terms", withExtension: "rtf") {
            do {
                let attributedStringWithRtf: NSAttributedString = try NSAttributedString(url: rtfPath, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                aTermView.textView.attributedText = attributedStringWithRtf
            } catch let error {
                print("Got an error \(error)")
            }
        } else {
            print("Terms and Service File Not Found")
        }
        self.delegate.view.addSubview(aTermView)
    }

    @objc func termsButtonTapped(_ sender: Any) {
        termsAgreed = !termsAgreed
        if termsAgreed {
            termsCheckButton.setImage(UIImage(named: "icon_tik_dark"), for: UIControlState.normal)
            termLabel.textColor = UIColor(hex: 0x515152)
            let termsText = "قوانین و مقررات را خوانده ام و موافقم"
            let attributedText = NSMutableAttributedString(string: termsText)
            attributedText.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: 15))
            attributedText.addAttribute(.foregroundColor, value: UIColor.blue, range: NSRange(location: 0, length: 15))
            termLabel.attributedText = attributedText
            termsCheckButton.tag = 1
        } else {
            termsCheckButton.setImage(UIImage(named: "icon_tick_white"), for: .normal)
            termLabel.textColor = UIColor(hex: 0xD6D7D9)
            let termsText = "قوانین و مقررات را خوانده ام و موافقم"
            let attributedText = NSMutableAttributedString(string: termsText)
            attributedText.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: 15))
            attributedText.addAttribute(.foregroundColor, value: UIColor.blue, range: NSRange(location: 0, length: 15))
            termLabel.attributedText = attributedText
            termsCheckButton.tag = 0
        }
    }

    func handleSubmitStatus() -> Disposable {
        let mobileTextValid = mobileText.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let usernameTextValid = usernameText.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let genderValid = genderText.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let stateTextValid = provinceText.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let cityTextValid = cityText.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)

        let termsCheckValid = termsCheckButton.rx.tap.map({ _ -> Bool in
            if self.termsCheckButton.tag == 1 {return true} else {return false}
        }).share(replay: 1, scope: .whileConnected)

        let enableSubmitButton = Observable.combineLatest([mobileTextValid,
                                                           usernameTextValid,
                                                           genderValid,
                                                           stateTextValid,
                                                           cityTextValid,
                                                           termsCheckValid]) { (allChecks) -> Bool in
                                                            //print("ALL : ",allChecks)
                                                            let reducedAllChecks = allChecks.reduce(true) { (accumulation: Bool, nextValue: Bool) -> Bool in
                                                                return accumulation && nextValue
                                                            }
                                                            //print("   Reduced to \(reducedAllChecks)")
                                                            return reducedAllChecks
        }
        return enableSubmitButton.bind(to: self.delegate.submitButton.rx.isEnabled)

    }

    @objc func selectCityTapped(_ sender: Any) {
        self.delegate.view.endEditing(true)
        let aTextField = sender as! EmptyTextField
        if self.stateCode == nil || self.stateCode == "" {
            self.delegate.alert(Message: "لطفاْ ابتدا استان را انتخاب نمایید")
            return
        }
        let parameters = [
            "state code": self.stateCode!
        ]
        NetworkManager.shared.run(API: "get-state-and-city", QueryString: "", Method: HTTPMethod.post, Parameters: parameters, Header: nil, WithRetry: true)
        let cityDispose = NetworkManager.shared.cityDictionaryObs
            .filter({$0.count > 0})
            .subscribe(onNext: { [unowned self] (innerCityDicObs) in
                let controller = ArrayChoiceTableViewController(innerCityDicObs.keys.sorted {$0 < $1}) { (selectedOption) in
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
    @objc func selectStateTapped(_ sender: Any) {
        self.delegate.setEditing(false, animated: true)
        let aTextField = sender as! EmptyTextField

        if NetworkManager.shared.allProvinceListObs.value.count > 0 {
            let options = NetworkManager.shared.allProvinceListObs.value
            let controller = ArrayChoiceTableViewController(options.filter({$0.count > 1})) { (selectedOption) in
                aTextField.text = selectedOption
                aTextField.sendActions(for: .valueChanged)
                self.cityCode = nil
                self.cityText.text = ""
                self.stateCode = "\(options.index(of: selectedOption) ?? 0)"
                NetworkManager.shared.cityDictionaryObs = BehaviorRelay<[String:String]>(value: [String:String]())
            }
            controller.preferredContentSize = CGSize(width: 250, height: options.count*60)
            self.delegate.showPopup(controller, sourceView: aTextField)

        } else {
            NetworkManager.shared.run(API: "get-state-and-city", QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil, WithRetry: true)
            let provinceDispose = NetworkManager.shared.allProvinceListObs
                .filter({$0.count > 0})
                .subscribe(onNext: { [unowned self] (innerAllProvinceList) in
                    let controller = ArrayChoiceTableViewController(innerAllProvinceList.filter({$0.count > 1})) { (selectedOption) in
                        aTextField.text = selectedOption
                        aTextField.sendActions(for: .valueChanged)
                        self.stateCode = "\(innerAllProvinceList.index(of: selectedOption) ?? 0)"
                        self.cityCode = nil
                        self.cityText.text = ""
                        NetworkManager.shared.cityDictionaryObs = BehaviorRelay<[String:String]>(value: [String:String]())
                    }
                    controller.preferredContentSize = CGSize(width: 250, height: 300)
                    self.delegate.showPopup(controller, sourceView: aTextField)
                })
            provinceDispose.disposed(by: self.delegate.myDisposeBag)
            disposeList.append(provinceDispose)
        }
    }

    @objc func selectGenderTapped(_ sender: Any) {
        self.delegate.view.endEditing(true)
        let aTextField = sender as! EmptyTextField
        let options = ["مرد", "زن"]
        let controller = ArrayChoiceTableViewController(options.sorted {$0 < $1}) { (selectedOption) in
            aTextField.text = selectedOption
            aTextField.sendActions(for: .valueChanged)
        }
        controller.preferredContentSize = CGSize(width: 250, height: options.count*60)
        self.delegate.showPopup(controller, sourceView: aTextField)
    }

}
