//
//  EditProfileUI.swift
//  Sepanta
//
//  Created by Iman on 12/19/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RxCocoa
import RxSwift

//extension  GetRichViewController {
class EditShopUI: NSObject, UITextFieldDelegate {

    var delegate: EditShopViewController
    var views = [String:UIView]()
    var formView = UIView()
    var texts = [String:UITextField]()
    var labels = [String:UILabel]()
    var buttons = [String:UIButton]()
    var datePicker = UIDatePicker()
    var submitButton = UIButton(type: .custom)
    var stateCode: String!
    var cityCode: String!
    var disposeList = [Disposable]()
    var myDisposeBag = DisposeBag()

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //BuildRow set 11 for tag of selectable textfield (See BuildRow function)
        if textField.tag == 11 {
            return false

        } else {
            // edittingView is set for keyboard notification manageing facility to find out if we should move the keyboard up or not!
            self.delegate.edittingView = textField
            return true
        }
    }

    init(_ vc: EditShopViewController) {
        self.delegate = vc
        super.init()
        showForm()
        getAndSubscribeToProfileInfo()
        //handleSubmitButtonEnableOrDisable()
    }

    func getAndSubscribeToProfileInfo() {
        //let aParameter = ["user id":"\(LoginKey.shared.userID)"]
        NetworkManager.shared.run(API: "profile-info", QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil, WithRetry: true)
        let profileInfoDisp = ProfileInfoWrapper.shared.profileInfoObs
            .subscribe(onNext: { [unowned self] (aProfileInfo) in
                //print("***FillingEDit")
                self.fillEditProfileForm(With: aProfileInfo)
            })
        profileInfoDisp.disposed(by: self.myDisposeBag)
        disposeList.append(profileInfoDisp)
    }

    func fillEditProfileForm(With aProfileInfo: ProfileInfo) {
        if aProfileInfo.image != nil {
            let imageURL = URL(string: NetworkManager.shared.websiteRootAddress + SlidesAndPaths.shared.path_profile_image + aProfileInfo.image!)
            //print("Shop Image : ",imageURL ?? "Nil")
            if imageURL != nil {
                self.delegate.shopLogo.setImageFromCache(PlaceHolderName: "logo_shape", Scale: 1.0, ImageURL: imageURL!, ImageName: aProfileInfo.image!)
                self.delegate.shopLogo.layer.shadowColor = UIColor.black.cgColor
                self.delegate.shopLogo.layer.shadowOffset = CGSize(width: 3, height: 3)
                self.delegate.shopLogo.layer.shadowRadius = 3
                self.delegate.shopLogo.layer.shadowOpacity = 0.3
            }
        } else {
            self.delegate.shopBanner.image = UIImage(named: "logo_shape")
        }

        if (aProfileInfo.banner ?? "").count > 0 {
            let imageURL = URL(string: NetworkManager.shared.websiteRootAddress + SlidesAndPaths.shared.path_banner_image + aProfileInfo.banner!)
            if imageURL != nil {
                self.delegate.shopBanner.setImageFromCache(PlaceHolderName: "banner_placeholder", Scale: 1.0, ImageURL: imageURL!, ImageName: aProfileInfo.banner!, ContentMode: UIViewContentMode.scaleToFill)
                self.delegate.shopBanner.layer.shadowColor = UIColor.black.cgColor
                self.delegate.shopBanner.layer.shadowOffset = CGSize(width: 3, height: 3)
                self.delegate.shopBanner.layer.shadowRadius = 3
                self.delegate.shopBanner.layer.shadowOpacity = 0.3
            }
        } else {
            self.delegate.shopBanner.image = UIImage(named: "banner_placeholder")
        }

        texts["familyText"]!.text = aProfileInfo.last_name
        texts["nameText"]!.text = aProfileInfo.first_name
        texts["nationalCodeText"]!.text = aProfileInfo.national_code
        texts["birthDateText"]!.text = aProfileInfo.birthdate
        texts["maritalStatusText"]!.text = aProfileInfo.marital_status
        texts["emailText"]!.text = aProfileInfo.email
        texts["stateText"]!.text = aProfileInfo.state
        texts["cityText"]!.text = aProfileInfo.city
        texts["regionText"]!.text = aProfileInfo.address
        texts["genderText"]!.text = aProfileInfo.gender
        for akey in texts.keys {
            if let aTextField = texts[akey] {
                //print("Sending Value Changed : ",akey,"   ",aTextField)
                aTextField.sendActions(for: .valueChanged)
            }
        }
        //texts["**********"]!.text = aProfileInfo.bio
    }

    @objc func doneDatePicker(_ sender: Any) {
        self.delegate.view.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "fa_IR")
        texts["birthDateText"]?.text = formatter.string(from: datePicker.date)
        texts["birthDateText"]?.sendActions(for: .valueChanged)
    }

    @objc func cancelDatePicker(_ sender: Any) {
        self.delegate.view.endEditing(true)
    }

    //Create Gradient on PageView
    @objc func sendEditedData() {
        //Submit data to server to change profile data and them back to profile view if required
        var gender_code = "1" //مرد
        if texts["genderText"]!.text == "زن" { gender_code = "0"}
        var marital_status_code = "2"  //متاهل
        if texts["maritalStatusText"]!.text == "مجرد" { marital_status_code = "1"}

        let aParameter = [
            "lastname": "\(texts["familyText"]!.text ?? "")",
            "firstname": "\(texts["nameText"]!.text ?? "")",
            "national_code": "\(texts["nationalCodeText"]!.text ?? "")",
            "birthdate": "\(texts["birthDateText"]!.text ?? "")",
            "marital_status": "\(marital_status_code)",
            "gender": "\(gender_code)",
            "email": "\(texts["emailText"]!.text ?? "")",
            "state": "\(texts["stateText"]!.text ?? "")",
            "city": "\(texts["cityText"]!.text ?? "")",
            "address": "\(texts["regionText"]!.text ?? "")"
        ]
        NetworkManager.shared.run(API: "profile-info", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: true)
        let updateMessageDisp = NetworkManager.shared.updateProfileInfoSuccessful
            .filter({$0 == true})
            .subscribe(onNext: { [unowned self] (_) in
                self.delegate.alert(Message: "اطلاعات پروفایل شما بروز شد")
                NetworkManager.shared.updateProfileInfoSuccessful = BehaviorRelay<Bool>(value: false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.delegate.backTapped(self.submitButton)
                    Spinner.stop()
                })

            })
        updateMessageDisp.disposed(by: self.myDisposeBag)
        disposeList.append(updateMessageDisp)
    }

    func showForm() {
        //print("reseller Request : ",views["leftFormView"] ?? "Nil")
        if views["leftFormView"] != nil && views["leftFormView"]?.superview != nil { views["leftFormView"]?.removeFromSuperview()}
        var cursurY: CGFloat = 10
        let marginY: CGFloat = 10
        let marginX: CGFloat = 10
        /*
        let gradient = CAGradientLayer()
        gradient.frame = self.delegate.view.bounds
        gradient.colors = [UIColor(hex: 0xF7F7F7).cgColor, UIColor.white.cgColor]
        self.delegate.mainScrollView.layer.insertSublayer(gradient, at: 0)
         */
        formView = UIView(frame: CGRect(x: 0, y: 0, width: self.delegate.textFormView.frame.width, height: self.delegate.textFormView.frame.height))

        let buttonHeight = UIScreen.main.bounds.height / 12
        let textFieldWidth = (formView.bounds.width) - (2 * marginX)

        (views["familyView"], texts["familyText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: (textFieldWidth / 2)-(marginX/4), height: buttonHeight), Image: "icon_profile_04", Selectable: false, PlaceHolderText: "نام خانوادگی")
        formView.addSubview(views["familyView"]!)
        (views["nameView"], texts["nameText"]) = buildARowView(CGRect: CGRect(x: (textFieldWidth / 2)+(marginX/4)+marginX, y: cursurY, width: (textFieldWidth / 2)-marginX/4, height: buttonHeight), Image: "icon_profile_03", Selectable: false, PlaceHolderText: "نام")
        formView.addSubview(views["nameView"]!)
        cursurY += buttonHeight + marginY

        (views["nationalCodeView"], texts["nationalCodeText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "identity-card", Selectable: false, PlaceHolderText: "کد ملی")
        formView.addSubview(views["nationalCodeView"]!)
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
        formView.addSubview(views["birthDateView"]!)
        cursurY += buttonHeight + marginY

        (views["genderView"], texts["genderText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "genders", Selectable: true, PlaceHolderText: "جنسیت")
        formView.addSubview(views["genderView"]!)
        texts["genderText"]?.addTarget(self, action: #selector(selectGenderTapped), for: .touchDown)
        cursurY += buttonHeight + marginY

        (views["maritalStatusView"], texts["maritalStatusText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "marriage-rings-couple-with-a-heart", Selectable: true, PlaceHolderText: "وضعیت تاهل")
        formView.addSubview(views["maritalStatusView"]!)
        texts["maritalStatusText"]?.addTarget(self, action: #selector(selectMaritalStatusTapped), for: .touchDown)
        cursurY += buttonHeight + marginY

        (views["emailView"], texts["emailText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "black-back-closed-envelope-shape", Selectable: false, PlaceHolderText: "ایمیل")
        formView.addSubview(views["emailView"]!)
        cursurY += buttonHeight + marginY

        (views["stateView"], texts["stateText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "map", Selectable: true, PlaceHolderText: "استان")
        formView.addSubview(views["stateView"]!)
        texts["stateText"]?.addTarget(self, action: #selector(selectStateTapped), for: .touchDown)
        cursurY += buttonHeight + marginY

        (views["cityView"], texts["cityText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "NOIMAGE", Selectable: true, PlaceHolderText: "شهر")
        formView.addSubview(views["cityView"]!)
        texts["cityText"]?.addTarget(self, action: #selector(selectCityTapped), for: .touchDown)
        cursurY += buttonHeight + marginY

        (views["regionView"], texts["regionText"]) = buildARowView(CGRect: CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight), Image: "NOIMAGE", Selectable: false, PlaceHolderText: "منطقه")
        formView.addSubview(views["regionView"]!)
        cursurY += buttonHeight + buttonHeight

        submitButton = SubmitButton(type: .custom)
        submitButton.frame = CGRect(x: marginX+(textFieldWidth/2)-1.5*buttonHeight, y: cursurY, width: 3*buttonHeight, height: buttonHeight)
        submitButton.setTitle("تایید", for: .normal)
        submitButton.addTarget(self, action: #selector(sendEditedData), for: .touchUpInside)
        submitButton.setEnable()

        formView.addSubview(submitButton)
        cursurY += buttonHeight + (1 * marginY)

        let formSize = CGSize(width: self.delegate.textFormView.frame.width, height: cursurY*1.2)
        formView.frame = CGRect(x: 0, y: 0, width: formSize.width, height: formSize.height)

        self.delegate.mainScrollView.contentSize = CGSize(width: formSize.width, height: formSize.height)
        self.delegate.mainScrollView.addSubview(formView)

    }

    func buildARowView(CGRect rect: CGRect, Image anImageName: String, Selectable selectable: Bool, PlaceHolderText aPlaceHolder: String) -> (UIView?, UITextField?) {
        let aView = UIView(frame: rect)
        let lineView = UIView(frame: CGRect(x: 0, y: rect.height-1, width: rect.width, height: 1))
        lineView.backgroundColor = UIColor(hex: 0xD6D7D9)
        aView.addSubview(lineView)

        //aView.backgroundColor = UIColor.white
        let icondim = rect.height / 3
        let spaceIconText: CGFloat = 20
        let imageRect = CGRect(x: (rect.width-icondim), y: (rect.height - icondim)/2, width: icondim, height: icondim)
        let anIcon = UIImageView(frame: imageRect)
        anIcon.image = UIImage(named: anImageName)
        anIcon.contentMode = .scaleAspectFit

        let aText = EmptyTextField(frame: CGRect(x: 0, y: 0, width: (rect.width-icondim-spaceIconText), height: rect.height))
        aText.font = UIFont(name: "Shabnam-FD", size: 14)
        aText.attributedPlaceholder = NSAttributedString(string: aPlaceHolder, attributes: [NSAttributedStringKey.foregroundColor: UIColor(hex: 0xD6D7D9)])
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

        return (aView, aText)
    }

    @objc func selectCityTapped(_ sender: Any) {
        self.delegate.setEditing(false, animated: true)
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
        cityDispose.disposed(by: self.myDisposeBag)
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
                self.texts["cityText"]!.text = ""
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
                        self.texts["cityText"]!.text = ""
                        NetworkManager.shared.cityDictionaryObs = BehaviorRelay<[String:String]>(value: [String:String]())
                    }
                    controller.preferredContentSize = CGSize(width: 250, height: 300)
                    self.delegate.showPopup(controller, sourceView: aTextField)
                })
            provinceDispose.disposed(by: self.delegate.myDisposeBag)
            disposeList.append(provinceDispose)
        }
    }

    @objc func selectMaritalStatusTapped(_ sender: Any) {
        self.delegate.setEditing(false, animated: true)
        let aTextField = sender as! EmptyTextField
        let options = ["مجرد", "متاهل"]
        let controller = ArrayChoiceTableViewController(options.sorted {$0 < $1}) { (selectedOption) in
            aTextField.text = selectedOption
            aTextField.sendActions(for: .valueChanged)
        }
        controller.preferredContentSize = CGSize(width: 250, height: options.count*60)
        self.delegate.showPopup(controller, sourceView: aTextField)
    }

    @objc func selectGenderTapped(_ sender: Any) {
        self.delegate.setEditing(false, animated: true)
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
