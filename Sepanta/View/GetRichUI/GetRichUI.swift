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
import AlamofireImage
import Alamofire
import MapKit

class GetRichUI: NSObject, UITextFieldDelegate {
    let buttonsFont = UIFont(name: "Shabnam-Bold-FD", size: 14)
    var cursurY: CGFloat = 0
    let marginY: CGFloat = 10
    let marginX: CGFloat = 20
    var buttonHeight: CGFloat = 10
    var shopLoc: CGPoint!
    var sellerLocation: CLLocationCoordinate2D!
    var textFieldWidth: CGFloat = 0
    var delegate: GetRichViewController!
    var views = [String:UIView]()
    var texts = [String:UITextField]()
    var labels = [String:UILabel]()
    var buttons = [String:UIButton]()
    var datePicker = UIDatePicker()
    var locationButton = RoundedButton(type: .custom)
    var awareCheckButton = UIButton(type: .custom)
    var areYouOwnerCheckButton = UIButton(type: .custom)
    var licenceCheckButton = UIButton(type: .custom)
    var cardSubmitButton = UIButton(type: .custom)
    var cardRequestType = RadioView(frame: CGRect.zero, items: [String]())
    var bankLogo = UIImageView()
    var mobileLogo = UIImageView()
    var nationalCodeCity = UILabel()
    var haveLicence = false
    var shopAwareness = false
    var areYouOwner = false
    var resellerSubmitButton = UIButton(type: .custom)
    var stateCode: String!
    var cityCode: String!
    var genderCode : String!
    var maritalStatusCode : String!
    var regionCode: String!
    var serviceCode: String!
    var cardNoPrefix = ""
    var mobilePrefix = ""
    var codePrefix = ""
    var aProfileInfo = ProfileInfo()
    var aProfile = Profile()
    var submitDispose: Disposable!
    var disposeList = [Disposable]()
    var myDisposeBag = DisposeBag()

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

        } else {
            // edittingView is set for keyboard notification manageing facility to find out if we should move the keyboard up or not!
            self.delegate.edittingView = textField
            return true
        }
    }

    func createNationalCodeCity(CursurY cursurY: CGFloat) -> UILabel {
        //print("CREATEING.....")
        nationalCodeCity = UILabel(frame: CGRect(x: marginX, y: cursurY+buttonHeight*0.2, width: buttonHeight*2, height: buttonHeight*0.6))
        nationalCodeCity.font = UIFont(name: "Shabnam FD", size: 12)
        nationalCodeCity.textAlignment = .center
        let nccDispose = NetworkManager.shared.nationalCodeCityObs
            .filter({$0.count > 0})
            .subscribe(onNext: { aCityName in
                self.nationalCodeCity.text = aCityName

            })
        nccDispose.disposed(by: self.delegate.myDisposeBag)
        disposeList.append(nccDispose)

        let nccText = texts["nationalCodeText"]!.rx.text
            .subscribe(onNext: { aCode in
                if (aCode?.count)! >= 3 {
                    let aCodePrefix = aCode!.prefix(3).description
                    if self.codePrefix != aCodePrefix {
                        let aParameter = ["code": "\(String(describing: aCodePrefix))"]
                        self.codePrefix = aCodePrefix
                        NetworkManager.shared.run(API: "national-codes", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: true)
                    }
                } else {
                    self.nationalCodeCity.text = ""
                }
            }
        )
        nccText.disposed(by: self.delegate.myDisposeBag)
        disposeList.append(nccText)
        return nationalCodeCity
    }

    func createMobileLogo(CursurY cursurY: CGFloat) -> UIImageView {
        print("MOBILE : ", CGRect(x: marginX+buttonHeight*0.2, y: cursurY+buttonHeight*0.2, width: buttonHeight*0.6, height: buttonHeight*0.6))
        mobileLogo = UIImageView(frame: CGRect(x: marginX+buttonHeight*0.2, y: cursurY+buttonHeight*0.2, width: buttonHeight*0.6, height: buttonHeight*0.6))
        //cursurY += buttonHeight + marginY
        let mobileDispose = NetworkManager.shared.mobileObs
            .filter({$0.name != nil})
            .subscribe(onNext: { aMobile in
                if aMobile.logo != nil {
                    let imageStrUrl = NetworkManager.shared.websiteRootAddress + aMobile.logo!
                    print("imageStrUrl : ", imageStrUrl)
                    if let imageURL = URL(string: imageStrUrl) {
                        print("imageURL : ", imageURL)
                        print("size : ", self.mobileLogo.frame.size)
                        self.mobileLogo.af_setImage(withURL: imageURL, placeholderImage: nil, filter: AspectScaledToFitSizeFilter(size: self.mobileLogo.frame.size))
                    }
                }

            })
        mobileDispose.disposed(by: self.delegate.myDisposeBag)
        disposeList.append(mobileDispose)
        let mobileTextDispose = texts["mobileText"]!.rx.text
            .subscribe(onNext: { aCardNumber in
                if (aCardNumber?.count)! >= 4 {
                    let mobileNumberPrefix = aCardNumber!.prefix(4).description
                    if self.mobilePrefix != mobileNumberPrefix {
                        let aParameter = ["code": "\(String(describing: mobileNumberPrefix))"]
                        self.mobilePrefix = mobileNumberPrefix
                        NetworkManager.shared.run(API: "mobile-operators", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: true)
                    }
                } else {
                    self.mobileLogo.image = nil //UIImage(named: "bank-building")
                    self.mobileLogo.contentScaleFactor = 0.5
                    self.mobilePrefix = ""
                    //self.texts["bankText"]?.text = nil
                }
            }
        )
        mobileTextDispose.disposed(by: self.delegate.myDisposeBag)
        disposeList.append(mobileTextDispose)
        return mobileLogo
    }

    @objc func sellRequestSubmitTapped(_ sender: Any) {
        let aParameter = [
            "first_name": "\(texts["nameText"]?.text ?? "")",
            "last_name": "\(texts["familyText"]?.text ?? "")",
            "address": "\(texts["addressText"]?.text ?? "")",
            "off_guess": "\(texts["discountText"]?.text ?? "")",
            "city_code":"\(self.cityCode ?? "0")",
            "state_code":"\(self.stateCode ?? "0")",
            "birth_date":"\(texts["birthDateText"]?.text ?? "")",
            "shop_name": "\(texts["shopText"]?.text ?? "")",
            "categoriesId":"\(self.serviceCode ?? "")",
            "phone_number": "\(texts["phoneNumberText"]?.text ?? "")",
            "cellphone": "\(texts["mobileText"]?.text ?? "")",
            "is_aware": "\(awareCheckButton.tag)",
            "is_license": "\(licenceCheckButton.tag)",
            "is_owner": "\(areYouOwnerCheckButton.tag)",
            "lat": "\(self.sellerLocation.latitude) ?? 35.2",
            "long": "\(self.sellerLocation.longitude) ?? 51.2",
            "national_code": "\(self.texts["nationalCodeText"]?.text ?? "")"
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

    func buildARowView(CGRect rect: CGRect, Image anImageName: String, Selectable selectable: Bool, PlaceHolderText aPlaceHolder: String) -> (UIView?, UITextField?) {
        let aView = UIView(frame: rect)
        let lineView = UIView(frame: CGRect(x: 0, y: rect.height-1, width: rect.width, height: 1))
        lineView.backgroundColor = UIColor(hex: 0xD6D7D9)
        aView.addSubview(lineView)

        aView.backgroundColor = UIColor.white
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

    @objc func awareButtonTapped(_ sender: Any) {
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

    @objc func areYouOwnerButtonTapped(_ sender: Any) {
        areYouOwner = !areYouOwner
        if areYouOwner {
            areYouOwnerCheckButton.setImage(UIImage(named: "icon_tik_dark"), for: UIControlState.normal)
            labels["areYouOwnerLabel"]!.textColor = UIColor(hex: 0x515152)
            areYouOwnerCheckButton.tag = 1
        } else {
            areYouOwnerCheckButton.setImage(UIImage(named: "icon_tick_white"), for: .normal)
            labels["areYouOwnerLabel"]!.textColor = UIColor(hex: 0xD6D7D9)
            areYouOwnerCheckButton.tag = 0
        }
    }

    @objc func licenceButtonTapped(_ sender: Any) {
        haveLicence = !haveLicence
        if haveLicence {
            licenceCheckButton.setImage(UIImage(named: "icon_tik_dark"), for: UIControlState.normal)
            labels["licenceLabel"]!.textColor = UIColor(hex: 0x515152)
            licenceCheckButton.tag = 1
        } else {
            licenceCheckButton.setImage(UIImage(named: "icon_tick_white"), for: .normal)
            labels["licenceLabel"]!.textColor = UIColor(hex: 0xD6D7D9)
            licenceCheckButton.tag = 0
        }
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

    @objc func cardRequestSubmitTapped(_ sender: Any) {
        var cardIdString : String = ""
        if aProfile.cards.last?.card_id != nil { cardIdString = "\(aProfile.cards.last?.card_id ?? 0)"}
        let aParameter = [
            "first_name": "\(texts["nameText"]?.text ?? "")",
            "last_name": "\(texts["familyText"]?.text ?? "")",
            "national_code": "\(texts["nationalCodeText"]?.text ?? "")",
            "gender": "\(genderCode ?? "")", // FIXME is ""
            "marital_status":"\(maritalStatusCode ?? "")", // FIXME is ""
            "email":"\(texts["emailText"]?.text ?? "")",
            "sh_code":"\(texts["birthCertCodeText"]?.text ?? "")",
            "cellphone": "\(texts["mobileText"]?.text ?? "")",
            "addres": "\(texts["addressText"]?.text ?? "")",
            "birthdate": "\(texts["birthDateText"]?.text ?? "")",
            "post_code": "\(texts["postalCodeText"]?.text ?? "")",
            "city_code":"\(self.cityCode ?? "0")",
            "state_code":"\(self.stateCode ?? "0")",
            "cardnumber": "\(texts["cardNoText"]?.text ?? "")",
            "card_id": cardIdString // FIXME is nil!
        ]
        print("aParameter : \(aParameter)")
        return
        NetworkManager.shared.run(API: "card-request", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: false)
        let messageDisp = NetworkManager.shared.messageObs
            .filter({$0.count > 0})
            .subscribe(onNext: { aMessage in
                self.delegate.alert(Message: aMessage)
                NetworkManager.shared.messageObs = BehaviorRelay<String>(value: "")
            })
        disposeList.append(messageDisp)
    }

    func handleCardSubmitButtonEnableOrDisable() -> Disposable {
        let familtyTextValid = texts["familyText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let nameTextValid = texts["nameText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let nationalCodeValid = texts["nationalCodeText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let birthDateTextValid = texts["birthDateText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let genderTextValid = texts["genderText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let maritalStatusTextValid = texts["maritalStatusText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let postalCodeTextValid = texts["postalCodeText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let mobileTextValid = texts["mobileText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let stateTextValid = texts["stateText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let cityTextValid = texts["cityText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        //let regionTextValid = texts["regionText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let cardNoTextValid = texts["cardNoText"]!.rx.text.map({($0?.count == 16)}).share(replay: 1, scope: .whileConnected)
        let bankCardForOthers = Observable<Bool>.create { [unowned self] observer -> Disposable in
            if self.cardRequestType.selectedItem.value == 0 {
                observer.onNext(true)
            } else {
                if self.texts["cardNoText"]?.text?.count == 16 {
                    observer.onNext(true)
                } else {
                    observer.onNext(false)
                }
            }
            return Disposables.create()
        }
        
        let enableSubmitButton = Observable.combineLatest([familtyTextValid,
                                                           nameTextValid,
                                                           nationalCodeValid,
                                                           birthDateTextValid,
                                                           genderTextValid,
                                                           maritalStatusTextValid,
                                                           postalCodeTextValid,
                                                           mobileTextValid,
                                                           stateTextValid,
                                                           cityTextValid,
                                                           cardNoTextValid,
                                                           bankCardForOthers]) { (allChecks) -> Bool in
                                                            //print("ALL : ",allChecks)
                                                            let reducedAllChecks = allChecks.reduce(true) { (accumulation: Bool, nextValue: Bool) -> Bool in
                                                                return accumulation && nextValue
                                                            }
                                                            //print("   Reduced to \(reducedAllChecks)")
                                                            //if self.texts["cardNoText"] == nil || self.texts["cardNoText"]?.text?.count != 16 { return false }
                                                            return reducedAllChecks
        }
        return enableSubmitButton.bind(to: cardSubmitButton.rx.isEnabled)

    }
    func handleResellerSubmitButtonEnableOrDisable() -> Disposable {
        let familtyTextValid = texts["familyText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let nameTextValid = texts["nameText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let addressTextValid = texts["addressText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let discountTextValid = texts["discountText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let stateTextValid = texts["stateText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let cityTextValid = texts["cityText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let shopTextValid = texts["shopText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let serviceTextValid = texts["serviceText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let mobileTextValid = texts["mobileText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let phoneNumberTextValid = texts["phoneNumberText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let birthDateTextValid = texts["birthDateText"]!.rx.text.map({!($0?.isEmpty ?? true)}).share(replay: 1, scope: .whileConnected)
        let enableSubmitButton = Observable.combineLatest([familtyTextValid,
                                                          nameTextValid,
                                                          shopTextValid,
                                                          stateTextValid,
                                                          cityTextValid,
                                                          serviceTextValid,
                                                          mobileTextValid,
                                                          phoneNumberTextValid,
                                                          addressTextValid,
                                                          birthDateTextValid,
                                                          discountTextValid]) { (allChecks) -> Bool in
                                                            //print("ALL : ",allChecks)
                                                            let reducedAllChecks = allChecks.reduce(true) { (accumulation: Bool, nextValue: Bool) -> Bool in
                                                                return accumulation && nextValue
                                                            }
                                                            //print("   Reduced to \(reducedAllChecks)")
                                                            return reducedAllChecks
        }
        return enableSubmitButton.bind(to: resellerSubmitButton.rx.isEnabled)
    }

    @objc func selectRegionTapped(_ sender: Any) {
        self.delegate.setEditing(false, animated: true)
        let aTextField = sender as! EmptyTextField
        if self.cityCode == nil || self.cityCode == "" {
            self.delegate.alert(Message: "لطفاْ ابتدا شهر را انتخاب نمایید")
            return
        }
        let innerRegionList = NetworkManager.shared.regionListObs.value
        if innerRegionList.count == 0 {
            self.delegate.alert(Message: "شهر انتخاب شده منطقه ندارد")
            return
        }
        let controller = ArrayChoiceTableViewController(innerRegionList.filter({$0.count > 0})) { (selectedOption) in
            aTextField.text = selectedOption
            aTextField.sendActions(for: .valueChanged)
            self.regionCode = "\(String(describing: innerRegionList.index(of: selectedOption)))"
        }
        controller.preferredContentSize = CGSize(width: 250, height: 300)
        self.delegate.showPopup(controller, sourceView: aTextField)
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
                    self.regionCode = ""
                    self.texts["regionText"]?.text = ""
                    let parameters = [
                        "city id": self.cityCode!
                    ]
                    NetworkManager.shared.run(API: "get-area", QueryString: "", Method: HTTPMethod.post, Parameters: parameters, Header: nil, WithRetry: true)

                }
                controller.preferredContentSize = CGSize(width: 250, height: 300)
                self.delegate.showPopup(controller, sourceView: aTextField)
            })
        cityDispose.disposed(by: self.delegate.myDisposeBag)
        disposeList.append(cityDispose)
        
        let regDispose = NetworkManager.shared.regionListObs
            .subscribe(onNext: {aList in
                if (aList.count == 0) && (self.views["regionView"]?.isHidden == false) {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.views["afterRegionView"]?.frame.origin.y -= (self.buttonHeight + self.marginY)
                    })
                    self.views["regionView"]?.isHidden = true
                } else if (aList.count > 0) && (self.views["regionView"]?.isHidden == true) {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.views["afterRegionView"]?.frame.origin.y += (self.buttonHeight + self.marginY)
                    })
                    self.views["regionView"]?.isHidden = false
                }
            })
        regDispose.disposed(by: self.delegate.myDisposeBag)
        disposeList.append(regDispose)
        
    }

    @objc func selectServiceTypeTapped(_ sender: Any) {
        self.delegate.setEditing(false, animated: true)
        let aTextField = sender as! EmptyTextField

        if NetworkManager.shared.serviceTypeObs.value.count > 0 {
            let options = NetworkManager.shared.serviceTypeObs.value
            let controller = ArrayChoiceTableViewController(options.filter({$0.count > 1})) { (selectedOption) in
                aTextField.text = selectedOption
                aTextField.sendActions(for: .valueChanged)
                self.serviceCode = "\(options.index(of: selectedOption) ?? 0)"
            }
            controller.preferredContentSize = CGSize(width: 250, height: options.count*60)
            self.delegate.showPopup(controller, sourceView: aTextField)

        } else {
            NetworkManager.shared.run(API: "get-categories", QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil, WithRetry: true)
            let serviceDispose = NetworkManager.shared.serviceTypeObs
                .filter({$0.count > 0})
                .subscribe(onNext: { [unowned self] (innerServiceTypes) in
                    let controller = ArrayChoiceTableViewController(innerServiceTypes.filter({$0.count > 1})) { (selectedOption) in
                        aTextField.text = selectedOption
                        aTextField.sendActions(for: .valueChanged)
                        self.serviceCode = "\(innerServiceTypes.index(of: selectedOption) ?? 0)"
                    }
                    controller.preferredContentSize = CGSize(width: 250, height: 300)
                    self.delegate.showPopup(controller, sourceView: aTextField)
                })
            serviceDispose.disposed(by: self.delegate.myDisposeBag)
            disposeList.append(serviceDispose)
        }
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
                NetworkManager.shared.regionListObs.accept([String]())
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
            if selectedOption == "متاهل" {self.maritalStatusCode = "2"} else {self.maritalStatusCode = "1"}
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
            if selectedOption == "مرد" {self.genderCode = "1"} else {self.genderCode = "0"}
            aTextField.sendActions(for: .valueChanged)
        }
        controller.preferredContentSize = CGSize(width: 250, height: options.count*60)
        self.delegate.showPopup(controller, sourceView: aTextField)
    }

    func getAndSubscribeToProfileInfo() -> Disposable {
        //let aParameter = ["user id":"\(LoginKey.shared.userID)"]
        NetworkManager.shared.run(API: "profile-info", QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil, WithRetry: true)
        return ProfileInfoWrapper.shared.profileInfoObs
            .subscribe(onNext: { [unowned self] (innerProfileInfo) in
                //print("***FillingEDit")
                self.aProfileInfo = innerProfileInfo
                self.fillEditProfileInfoForm(With: innerProfileInfo)
            })
    }
    func fillEditProfileInfoForm(With aProfileInfo: ProfileInfo) {
        //print(" profile Info in GetRichUI : \(aProfileInfo)")
        if texts["familyText"] != nil { texts["familyText"]!.text = aProfileInfo.last_name}
        if texts["nameText"] != nil { texts["nameText"]!.text = aProfileInfo.first_name}
        if texts["nationalCodeText"] != nil { texts["nationalCodeText"]!.text = aProfileInfo.national_code}
        if texts["birthDateText"] != nil { texts["birthDateText"]!.text = aProfileInfo.birthdate}
        if texts["maritalStatusText"] != nil { texts["maritalStatusText"]!.text = aProfileInfo.marital_status}
        if texts["addressText"] != nil { texts["addressText"]!.text = aProfileInfo.address}
        if texts["emailText"] != nil { texts["emailText"]!.text = aProfileInfo.email}
        //if texts["stateText"] != nil { texts["stateText"]!.text = aProfileInfo.state}
        //if texts["cityText"] != nil { texts["cityText"]!.text = aProfileInfo.city}
        if texts["addressText"] != nil { texts["addressText"]!.text = aProfileInfo.address}
        if texts["mobileText"] != nil { texts["mobileText"]!.text = aProfileInfo.phone}
        if texts["genderText"] != nil { texts["genderText"]!.text = aProfileInfo.gender}
        for akey in texts.keys {
            if let aTextField = texts[akey] {
                //print("Sending Value Changed : ",akey,"   ",aTextField)
                aTextField.sendActions(for: .valueChanged)
            }
        }
    }

    @objc func selectOnMapTapped(_ sender: UIButton) {
        NetworkManager.shared.selectedLocation
            .filter({$0.latitude != 0 && $0.longitude != 0 })
            .subscribe(onNext: {aLoc in
                print("selected location  : ", aLoc)
                self.sellerLocation = aLoc
                //self.locationButton.backgroundColor = UIColor(hex: 0x9FDA64)
                self.locationButton.setImage(UIImage(named: "icon_location_green"), for: .normal)
                self.locationButton.layer.borderColor = UIColor(hex: 0x9FDA64).cgColor
                self.locationButton.layer.borderWidth = 1
            }).disposed(by: self.delegate.myDisposeBag)
        self.delegate.coordinator!.pushSelectOnMap(texts["shopText"]?.text ?? "بدون نام")
    }
}
