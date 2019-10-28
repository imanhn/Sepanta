//
//  ShowProfileUI.swift
//  Sepanta
//
//  Created by Iman on 12/18/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Alamofire
import RxAlamofire

class ShowUserProfileUI: NSObject, UICollectionViewDelegateFlowLayout {
    var delegate: ProfileViewController!
    var views = [String:UIView]()
    var buttons = [String:UIButton]()
    var collectionView: UICollectionView!
    var myDisposeBag = DisposeBag()
    var disposeList = [Disposable]()
    var shops = BehaviorRelay<[Shop]>(value: [Shop]())
    var cards = BehaviorRelay<[CreditCard]>(value: [CreditCard]())
    let numberOfFollowedShopInARow: CGFloat = 4
    var scrollView = UIScrollView(frame: CGRect.zero)
    
    init(_ vc: ProfileViewController) {
        super.init()
        self.delegate = vc
        showMyClub()
        //bindUIwithDataSource()
        getProfileData()
        getAndSubscribeToPointsScores()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 30) / numberOfFollowedShopInARow // compute your cell width
        //print("WOW Calling layout cell width : ",cellWidth," index : ",indexPath)
        //return CGSize(width: 50 , height: 50)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    //Create Gradient on PageView
    func showMyClub() {
        
        if views["leftFormView"] != nil && views["leftFormView"]?.superview != nil { views["leftFormView"]?.removeFromSuperview()}
        var cursurY: CGFloat = 0
        let marginY: CGFloat = 10
        let marginX: CGFloat = 10

        //self.delegate.paneView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height * 2)+40)

        views["rightFormView"] = RightTabbedViewWithWhitePanel(frame: CGRect(x: marginX, y: marginY, width: self.delegate.paneView.frame.width-2*marginX, height: self.delegate.paneView.frame.height-marginY))
        views["rightFormView"]!.backgroundColor = UIColor.clear
        let buttonsFont = UIFont(name: "Shabnam-Bold-FD", size: 14)
        let buttonHeight = (views["rightFormView"] as! RightTabbedViewWithWhitePanel).getHeight()
        //let textFieldWidth = (views["rightFormView"]?.bounds.width)! - (2 * marginX)

        buttons["leftButton"] = UIButton(frame: CGRect(x: 0, y: 0, width: (views["rightFormView"]?.bounds.width)!/2, height: buttonHeight))
        buttons["leftButton"]!.setTitle("کارت های من", for: .normal)
        buttons["leftButton"]!.titleLabel?.font = buttonsFont
        buttons["leftButton"]!.addTarget(self, action: #selector(self.showMyCards(_:)), for: .touchUpInside)
        buttons["leftButton"]!.setTitleColor(UIColor(hex: 0x515152), for: .normal)

        buttons["rightButton"] = UIButton(frame: CGRect(x: views["rightFormView"]!.bounds.width/2, y: 0, width: views["rightFormView"]!.bounds.width/2, height: buttonHeight))
        buttons["rightButton"]!.setTitle("باشگاه های من", for: .normal)
        buttons["rightButton"]!.titleLabel?.font = buttonsFont
        buttons["rightButton"]!.setTitleColor(UIColor(hex: 0x515152), for: .normal)

        views["rightFormView"]!.addSubview(buttons["leftButton"]!)
        views["rightFormView"]!.addSubview(buttons["rightButton"]!)
        cursurY += buttonHeight + marginY

        let scrollView = UIScrollView(frame: CGRect(x: 0, y: cursurY, width: views["rightFormView"]!.frame.width, height: views["rightFormView"]!.frame.height-buttonHeight))
        views["rightFormView"]!.addSubview(scrollView)

        //scrollView ADDs Goes Here!
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10

        collectionView = UICollectionView(frame: CGRect(x: marginX, y: cursurY, width: views["rightFormView"]!.frame.width-(2*marginX), height: views["rightFormView"]!.frame.height-cursurY), collectionViewLayout: flowLayout)
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: "shopcell")
        collectionView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        _ = collectionView.rx.setDelegate(self) //Delegate method to call
        views["rightFormView"]!.addSubview(collectionView)
        self.delegate.paneView.addSubview(views["rightFormView"]!)
        bindCollectionView()
    }

    func bindCollectionView() {
        print("LoginKey.shared.role  : ",LoginKey.shared.role )
        self.shops.bind(to: collectionView.rx.items(cellIdentifier: "shopcell")) { [weak self] _, model, cell in
            if let aCell = cell as? ButtonCell {
                //if aCell.aButton == nil {aCell.aButton = UIButton(type: .custom)}
                //print("model : ", model)
                let dim = ((self?.collectionView.bounds.width ?? 50) * 0.8) / (self?.numberOfFollowedShopInARow ?? 3)
                aCell.aButton.frame = CGRect(x: 0, y: 0, width: dim, height: dim)
                self?.collectionView.addSubview(aCell)
                aCell.addSubview(aCell.aButton)
                if model.image != nil && (model.image ?? "").count > 0 {
                    let strURL = NetworkManager.shared.websiteRootAddress + SlidesAndPaths.shared.path_profile_image + (model.image ?? "")
                    let imageURL = URL(string: strURL)
                    if imageURL == nil {
                        print("     Post URL is not valid : ", model.image ?? "Empty Image")
                        aCell.aButton.setImage(UIImage(named: "logo_shape"), for: .normal)
                    } else {
                        aCell.aButton.setImageFromCache(PlaceHolderName: "logo_shape", Scale: 1, ImageURL: imageURL!, ImageName: model.image!)
                    }
                } else {
                    aCell.aButton.setImage(UIImage(named: "logo_shape"), for: .normal)
                }
                aCell.aButton.layer.shadowColor = UIColor.black.cgColor
                aCell.aButton.layer.shadowOffset = CGSize(width: 3, height: 3)
                aCell.aButton.layer.shadowRadius = 2
                aCell.aButton.layer.shadowOpacity = 0.2
                
                aCell.aButton.tag = model.shop_id ?? 0
                aCell.aButton.addTarget(self, action: #selector(self?.showShopDetail), for: .touchUpInside)
            } else {
                print("\(cell) can not be casted to PostCell")
            }
            }.disposed(by: myDisposeBag)
    }

    @objc func showShopDetail(_ sender: Any) {
        let aButton = (sender as? UIButton)
        guard (aButton?.tag != 0) else {
            self.delegate.alert(Message: "اطلاعات این فروشگاه ناقص است")
            return
        }
        for ashop in shops.value {
            if (ashop.shop_id == aButton?.tag)  && (ashop.shop_id != 0) {
                print("Shop Selected Pushing : ", ashop)
                self.delegate.coordinator!.pushShop(Shop: ashop)
                return
            }
        }
    }

    @objc func showMyCards(_ sender : Any) {
        //print("Card Request  : ",views["rightFormView"]!,"  SuperView : ",views["rightFormView"]!.superview ?? "Nil")
        if views["rightFormView"]?.superview != nil { views["rightFormView"]?.removeFromSuperview()}
        var cursurY: CGFloat = 0
        let marginY: CGFloat = 10
        let marginX: CGFloat = 10
        views["leftFormView"] = LeftTabbedView(frame: CGRect(x: marginX, y: marginY, width: self.delegate.paneView.frame.width-2*marginX, height: self.delegate.paneView.frame.height-marginY))
        views["leftFormView"]!.backgroundColor = UIColor.clear

        let buttonsFont = UIFont(name: "Shabnam-Bold-FD", size: 14)
        let buttonHeight = (views["leftFormView"] as! LeftTabbedView).getHeight()
        //let textFieldWidth = (views["leftFormView"]!.bounds.width) - (2 * marginX)

        buttons["leftButton"] = UIButton(frame: CGRect(x: 0, y: 0, width: views["leftFormView"]!.bounds.width/2, height: buttonHeight))
        buttons["leftButton"]!.setTitle("کارت های من", for: .normal)
        buttons["leftButton"]!.titleLabel?.font = buttonsFont
        //buttons["leftButton"]!.addTarget(self, action: #selector(self.cardRequestTapped(_:)), for: .touchUpInside)
        buttons["leftButton"]!.setTitleColor(UIColor(hex: 0x515152), for: .normal)

        buttons["rightButton"] = UIButton(frame: CGRect(x: views["leftFormView"]!.bounds.width/2, y: 0, width: views["leftFormView"]!.bounds.width/2, height: buttonHeight))
        buttons["rightButton"]!.setTitle("باشگاه های من", for: .normal)
        buttons["rightButton"]!.titleLabel?.font = buttonsFont
        buttons["rightButton"]!.addTarget(self.delegate, action: #selector(self.delegate.myClubTapped), for: .touchUpInside)
        buttons["rightButton"]!.setTitleColor(UIColor(hex: 0x515152), for: .normal)

        views["leftFormView"]!.addSubview(buttons["leftButton"]!)
        views["leftFormView"]!.addSubview(buttons["rightButton"]!)
        cursurY += buttonHeight + marginY

        scrollView = UIScrollView(frame: CGRect(x: 0, y: cursurY, width: views["leftFormView"]!.frame.width, height: views["leftFormView"]!.frame.height-cursurY-marginY))
        let cardwidth = scrollView.frame.width - ( 4 * marginX)
        let cardHeight = scrollView.frame.width/2
        let cardMargin = cardHeight/4
        var cardCursurY = marginY
        var i = 0
        for aCardData in self.cards {
            let acard = CardView(frame: CGRect(x: 2*marginX, y: cardCursurY, width: cardwidth, height: cardHeight))
            acard.cardNo1.text = aCardData.card_number?.slice(From: 0, To: 3)
            acard.cardNo2.text = aCardData.card_number?.slice(From: 4, To: 7)
            acard.cardNo3.text = aCardData.card_number?.slice(From: 8, To: 11)
            acard.cardNo4.text = aCardData.card_number?.slice(From: 12, To: 15)
            let bankPrefixNum = aCardData.card_number?.slice(From: 0, To: 5)
            acard.menuButton.tag = i
            acard.menuButton.addTarget(self, action: #selector(self.menuOnCardTapped(_:)), for: .touchUpInside)
            print(" CARD Data : \(aCardData.bank_logo) \(aCardData.bank_name)")
            if aCardData.bank_logo == nil || aCardData.bank_name == nil ||
                aCardData.bank_logo == "" || aCardData.bank_name == "" {
                print("Getting Bank Data : \(bankPrefixNum)")
                //FIXME it doesn't work since acard is not the one when the route response!
                CheckBank(SixDigitPrefix: bankPrefixNum!).results()
                    .subscribe(onNext: { innerBank in
                        print("Bank DATA : \(innerBank)")
                        if innerBank.logo != nil {
                            let imageUrl = NetworkManager.shared.websiteRootAddress + SlidesAndPaths.shared.path_bank_logo_image + (innerBank.logo ?? "")
                            if let castedUrl = URL(string: imageUrl) {
                                acard.bankLogo.af_setImage(withURL: castedUrl, placeholderImage: UIImage(named: "bank-building"))
                                //acard.bankLogo.setImageFromCache(PlaceHolderName: "bank-building", Scale: 1, ImageURL: castedUrl, ImageName: innerBank.logo!)
                            } else {
                                print("ShowProfileUI : Bank Str -> URL Can not be casted ")
                            }
                        }
                        print("innerBank.bank : \(innerBank.bank)")
                        acard.nameLabel.text = (aCardData.first_name ?? "")  + " " + (aCardData.last_name ?? "")
                    }).disposed(by: myDisposeBag)
            } else {
                if aCardData.bank_logo != nil {
                    let imageUrl = NetworkManager.shared.websiteRootAddress + SlidesAndPaths.shared.path_bank_logo_image + (aCardData.bank_logo ?? "")
                    print("BANK : ",imageUrl)
                    
                    if let castedUrl = URL(string: imageUrl) {
                        acard.bankLogo.af_setImage(withURL: castedUrl, placeholderImage: UIImage(named: "bank-building"))
                        //acard.bankLogo.setImageFromCache(PlaceHolderName: "bank-building", Scale: 1, ImageURL: castedUrl, ImageName: aCardData.bank_logo!)
                    }
                }
                print("aCardData.bank_name : \(aCardData.bank_name)")
                acard.nameLabel.text = (aCardData.first_name ?? "") + " " + (aCardData.last_name ?? "")
            }
            if aCardData.card_number == "0" {
                // This is a sepanta card
                print("Sepanta Card Detected")
                acard.bankLogo.image = UIImage(named: "logo_shape")
                acard.nameLabel.text = (aCardData.first_name ?? "") + " " + (aCardData.last_name ?? "")
            }
            scrollView.addSubview(acard)
            cardCursurY += marginY + acard.frame.height + cardMargin
            i += 1
        }
        let newCard = NewCardView(frame: CGRect(x: 2*marginX, y: cardCursurY, width: cardwidth, height: cardHeight))
        scrollView.addSubview(newCard)
        newCard.addButton.addTarget(self, action: #selector(addCardTapped), for: .touchUpInside)
        cardCursurY += marginY + newCard.frame.height + cardMargin

        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: cardCursurY)
        views["leftFormView"]!.addSubview(scrollView)
        self.delegate.paneView.addSubview(views["leftFormView"]!)

    }
    
    func bindCards(){
        
    }
    
    @objc func menuOnCardTapped(_ sender: Any) {
        let menuButton = (sender as! UIButton)
        let del = "حذف کارت"
        let edit = "ویرایش کارت"
        //let close = "بستن منو"
        let menuList = [del,edit]
        
        let controller = MenuLister(menuList) { (selectedOption) in
            switch selectedOption {
            case del : self.deleteCard(CardNumber: menuButton.tag)
            case edit : self.editCard(CardNumber: menuButton.tag)
            default :
                print("Should not get here, but if it gets its fine! really!")
            }
        }
        controller.preferredContentSize = CGSize(width: 150, height: 100)
        self.delegate.showPopup(controller, sourceView: menuButton)
    }
    
    func deleteCard(CardNumber cardNumber : Int) {
        guard NetworkManager.shared.userProfileObs.value.cards.count > cardNumber else {
            self.delegate.alert(Message: "عملیات با خطا مواجه گردید")
            return
        }
        if let aCardId = NetworkManager.shared.userProfileObs.value.cards[cardNumber].card_id {
            let deleteCardDisp = DeleteCard(CardID: "\(aCardId)").results()
                .subscribe(onNext: { aGenericResponse in
                    print("aGenericResponse : \(aGenericResponse)")
                    if let aStatus = aGenericResponse.status {
                        if aStatus ==  "successful" {
                            self.getProfileData()
                            self.delegate.alert(Message: aGenericResponse.message ?? "کارت با موفقیت حذف گردید")
                        }
                    } else {
                        print("UNKNOWN response.")
                        self.getProfileData()
                    }
                }, onError: {_ in })
            deleteCardDisp.disposed(by: myDisposeBag)
            self.disposeList.append(deleteCardDisp)
        } else {
            print("Error : card_id is nil ")
            fatalError()
        }
    }
    
    func editCard(CardNumber cardNumber : Int) {
        
    }

    @objc func addCardTapped(_ sender: Any) {
        self.delegate.coordinator!.pushNewCard()
    }

    func getProfileData() {
        let profileDisp = GetProfileOfUser().results()
            .subscribe(onNext: { [weak self] aProfile in
                if aProfile.image != nil && aProfile.image!.count > 0 {
                    let imageUrl = NetworkManager.shared.websiteRootAddress + SlidesAndPaths.shared.path_profile_image + aProfile.image!
                    print("Profile Picture : ", imageUrl)
                    let castedUrl = URL(string: imageUrl)
                    if castedUrl != nil {
                        self?.delegate.profilePicture.setImageFromCache(PlaceHolderName: "icon_profile_img", Scale: 1, ImageURL: castedUrl!, ImageName: aProfile.image!)
                        self?.delegate.profilePicture.layer.cornerRadius = (self?.delegate.profilePicture.frame.width ?? 50)/2
                        self?.delegate.profilePicture.layer.masksToBounds = true
                        self?.delegate.profilePicture.layer.borderColor = UIColor.white.cgColor
                        self?.delegate.profilePicture.layer.borderWidth = 4
                        
                    } else {
                        print("URL Can not be casted : ", imageUrl)
                    }
                }
                self?.delegate.nameLabel.text =  aProfile.fullName
                self?.delegate.descLabel.text = aProfile.bio
                self?.delegate.clubNumLabel.text = "\(aProfile.follow_count ?? 0)"
                self?.shops.accept(aProfile.content)
                self?.cards.accept(aProfile.cards)
            })
        profileDisp.disposed(by: myDisposeBag)
        self.disposeList.append(profileDisp)

    }

    func getAndSubscribeToPointsScores() {
        let pointScoreDisp = GetPointsScore().results()
            .subscribe(onNext: { [unowned self] aUserPoint in
                //print("Subscribed and Received : ",aUserPoint)
                self.delegate.cupScoreLabel.text = "\(aUserPoint.points_total ?? 0)"
            })
        pointScoreDisp.disposed(by: myDisposeBag)
        self.disposeList.append(pointScoreDisp)
    }

}
