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

class ShowProfileUI : NSObject,UICollectionViewDelegateFlowLayout {
    var delegate : ProfileViewController!
    var views = Dictionary<String,UIView>()
    var buttons = Dictionary<String,UIButton>()
    var collectionView : UICollectionView!
    var myDisposeBag = DisposeBag()
    var shops = BehaviorRelay<[Shop]>(value: [Shop]())
    var posts = BehaviorRelay<[Post]>(value: [Post]())
    let numberOfFollowedShopInARow : CGFloat = 4
    
    init(_ vc : ProfileViewController) {
        super.init()
        self.delegate = vc
        showMyClub()
        bindUIwithDataSource()
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
        
        //print("reseller Request : ",views["leftFormView"] ?? "Nil")
        if views["leftFormView"] != nil && views["leftFormView"]?.superview != nil { views["leftFormView"]?.removeFromSuperview()}
        var cursurY : CGFloat = 0
        let marginY : CGFloat = 10
        let marginX : CGFloat = 10
        
        //self.delegate.paneView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height * 2)+40)
        
        views["rightFormView"] = RightTabbedViewWithWhitePanel(frame: CGRect(x: marginX, y: marginY, width: self.delegate.paneView.frame.width-2*marginX, height: self.delegate.paneView.frame.height-marginY))
        views["rightFormView"]!.backgroundColor = UIColor.clear
        let buttonsFont = UIFont(name: "Shabnam-Bold-FD", size: 14)
        let buttonHeight = (views["rightFormView"] as! RightTabbedViewWithWhitePanel).getHeight()
        //let textFieldWidth = (views["rightFormView"]?.bounds.width)! - (2 * marginX)
        
        buttons["leftButton"] = UIButton(frame: CGRect(x: 0, y: 0, width: (views["rightFormView"]?.bounds.width)!/2, height: buttonHeight))
        buttons["leftButton"]!.setTitle("اطلاعات ارتباطی", for: .normal)
        buttons["leftButton"]!.titleLabel?.font = buttonsFont
        buttons["leftButton"]!.addTarget(self.delegate, action: #selector(self.delegate.contactTapped), for: .touchUpInside)
        buttons["leftButton"]!.setTitleColor(UIColor(hex: 0x515152), for: .normal)
        
        buttons["rightButton"] = UIButton(frame: CGRect(x: views["rightFormView"]!.bounds.width/2, y: 0, width: views["rightFormView"]!.bounds.width/2, height: buttonHeight))
        buttons["rightButton"]!.setTitle("باشگاه های من", for: .normal)
        buttons["rightButton"]!.titleLabel?.font = buttonsFont
        buttons["rightButton"]!.setTitleColor(UIColor(hex: 0x515152), for: .normal)
        
        views["rightFormView"]!.addSubview(buttons["leftButton"]!)
        views["rightFormView"]!.addSubview(buttons["rightButton"]!)
        cursurY = cursurY + buttonHeight + marginY

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
    
    func bindUIwithDataSource() {
       NetworkManager.shared.profileObs
        .subscribe(onNext: { [weak self] aProfile in
            if aProfile.image != nil && aProfile.image!.count > 0 {
                let imageUrl = NetworkManager.shared.websiteRootAddress + SlidesAndPaths.shared.path_profile_image + aProfile.image!
                print("Profile Picture : ",imageUrl)
                let castedUrl = URL(string: imageUrl)
                if castedUrl != nil {
                    self?.delegate.profilePicture.setImageFromCache(PlaceHolderName: "icon_profile_img", Scale: 1, ImageURL: castedUrl!, ImageName: aProfile.image!)
                    self?.delegate.profilePicture.layer.cornerRadius = (self?.delegate.profilePicture.frame.width ?? 50)/2
                    self?.delegate.profilePicture.layer.masksToBounds = true
                    self?.delegate.profilePicture.layer.borderColor = UIColor.white.cgColor
                    self?.delegate.profilePicture.layer.borderWidth = 4

                }else{
                    print("URL Can not be casted : ",imageUrl)
                }
            }
            self?.delegate.nameLabel.text =  aProfile.fullName
            self?.delegate.descLabel.text = aProfile.fullName
            //self?.delegate.cupLabel
            self?.delegate.clubNumLabel.text = "\(aProfile.follow_count ?? 0)"
            //print("aProfile.content : ",aProfile.content)
            if LoginKey.shared.role == "Shop" {
                self?.posts.accept(aProfile.content as! [Post])
            }else{
                self?.shops.accept(aProfile.content as! [Shop])
            }
        }).disposed(by: myDisposeBag)
    }
    
    func bindCollectionView(){
        if LoginKey.shared.role == "Shop" {
            self.posts.bind(to: collectionView.rx.items(cellIdentifier: "shopcell")) { [weak self] row, model, cell in
                if let aCell = cell as? ButtonCell {
                    //if aCell.aButton == nil {aCell.aButton = UIButton(type: .custom)}
                    //print("model : ",model)
                    let dim = ((self?.collectionView.bounds.width ?? 50) * 0.8) / (self?.numberOfFollowedShopInARow ?? 3)
                    aCell.aButton.frame = CGRect(x: 0, y: 0, width: dim, height: dim)
                    self?.collectionView.addSubview(aCell)
                    aCell.addSubview(aCell.aButton)
                    if model.image != nil && (model.image ?? "").count > 0 {
                        let strURL = NetworkManager.shared.websiteRootAddress + SlidesAndPaths.shared.path_post_image + (model.image ?? "")
                        let imageURL = URL(string: strURL)
                        if imageURL == nil {
                            print("     Post URL is not valid : ",model.image ?? "Empty Image")
                            aCell.aButton.setImage(UIImage(named: "logo_shape"), for: .normal)
                        }else{
                            aCell.aButton.setImageFromCache(PlaceHolderName: "logo_shape", Scale: 1, ImageURL: imageURL!, ImageName: model.image!)
                        }
                    }else{
                        aCell.aButton.setImage(UIImage(named: "logo_shape"), for: .normal)
                    }
                    aCell.aButton.layer.shadowColor = UIColor.black.cgColor
                    aCell.aButton.layer.shadowOffset = CGSize(width: 3, height: 3)
                    aCell.aButton.layer.shadowRadius = 2
                    aCell.aButton.layer.shadowOpacity = 0.2
                    
                    aCell.aButton.tag = model.id ?? 0
                    aCell.aButton.addTarget(self, action: #selector(self?.showPostDetail), for: .touchUpInside)
                }else{
                    print("\(cell) can not be casted to PostCell")
                }
                }.disposed(by: myDisposeBag)
        }else{
            self.shops.bind(to: collectionView.rx.items(cellIdentifier: "shopcell")) { [weak self] row, model, cell in
                if let aCell = cell as? ButtonCell {
                    //if aCell.aButton == nil {aCell.aButton = UIButton(type: .custom)}
                    //print("model : ",model)
                    let dim = ((self?.collectionView.bounds.width ?? 50) * 0.8) / (self?.numberOfFollowedShopInARow ?? 3)
                    aCell.aButton.frame = CGRect(x: 0, y: 0, width: dim, height: dim)
                    self?.collectionView.addSubview(aCell)
                    aCell.addSubview(aCell.aButton)
                    if model.image != nil && (model.image ?? "").count > 0 {
                        let strURL = NetworkManager.shared.websiteRootAddress + SlidesAndPaths.shared.path_post_image + (model.image ?? "")
                        let imageURL = URL(string: strURL)
                        if imageURL == nil {
                            print("     Post URL is not valid : ",model.image ?? "Empty Image")
                            aCell.aButton.setImage(UIImage(named: "logo_shape"), for: .normal)
                        }else{
                            aCell.aButton.setImageFromCache(PlaceHolderName: "logo_shape", Scale: 1, ImageURL: imageURL!, ImageName: model.image!)
                        }
                    }else{
                        aCell.aButton.setImage(UIImage(named: "logo_shape"), for: .normal)
                    }
                    aCell.aButton.layer.shadowColor = UIColor.black.cgColor
                    aCell.aButton.layer.shadowOffset = CGSize(width: 3, height: 3)
                    aCell.aButton.layer.shadowRadius = 2
                    aCell.aButton.layer.shadowOpacity = 0.2
                    
                    aCell.aButton.tag = model.user_id ?? 0
                    aCell.aButton.addTarget(self, action: #selector(self?.showShopDetail), for: .touchUpInside)
                }else{
                    print("\(cell) can not be casted to PostCell")
                }
                }.disposed(by: myDisposeBag)
        }
    }
    
    @objc func showShopDetail(_ sender : Any){
        let aButton = (sender as? UIButton)
        for ashop in shops.value {
            if ashop.user_id == aButton?.tag {
                print("Shop Selected Pushing : ",ashop)
                // this is neccessary because ShowProfile is subscribed to Profile and it will raise an error
                // right after trying to push a shop because shop contents are post and profile contents are shops!
                // when We push a shop, if showprofile is still subscribed to ProfileObs then when the shopVC fetch shop profile from server
                // ShowProfile receives that and can not cast Content[Post] to Content[shop]
                NetworkManager.shared.profileObs = BehaviorRelay<Profile>(value: Profile())
                self.delegate.coordinator!.pushShop(Shop: ashop)
            }
        }
    }
    @objc func showPostDetail(_ sender : Any){
        let aButton = (sender as? UIButton)
        if let postID = aButton?.tag {
            self.delegate.coordinator!.PushAPost(PostID: postID)
        }else{
            self.delegate.alert(Message: "اطلاعات این پست کامل نیست")
        }
    }
    
    func showContacts() {
        //print("Card Request  : ",views["rightFormView"]!,"  SuperView : ",views["rightFormView"]!.superview ?? "Nil")
        if views["rightFormView"]?.superview != nil { views["rightFormView"]?.removeFromSuperview()}
        var cursurY : CGFloat = 0
        let marginY : CGFloat = 10
        let marginX : CGFloat = 10
        views["leftFormView"] = LeftTabbedView(frame: CGRect(x: marginX, y: marginY, width: self.delegate.paneView.frame.width-2*marginX, height: self.delegate.paneView.frame.height-marginY))
        views["leftFormView"]!.backgroundColor = UIColor.clear
        
        
        let buttonsFont = UIFont(name: "Shabnam-Bold-FD", size: 14)
        let buttonHeight = (views["leftFormView"] as! LeftTabbedView).getHeight()
        //let textFieldWidth = (views["leftFormView"]!.bounds.width) - (2 * marginX)
        
        buttons["leftButton"] = UIButton(frame: CGRect(x: 0, y: 0, width: views["leftFormView"]!.bounds.width/2, height: buttonHeight))
        buttons["leftButton"]!.setTitle("اطلاعات ارتباطی", for: .normal)
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
        cursurY = cursurY + buttonHeight + marginY

        let scrollView = UIScrollView(frame: CGRect(x: 0, y: cursurY, width: views["leftFormView"]!.frame.width, height: views["leftFormView"]!.frame.height-cursurY-marginY))
        let cardwidth = scrollView.frame.width - ( 4 * marginX)
        let cardHeight = scrollView.frame.width/2
        let cardMargin = cardHeight/4
        var cardCursurY = marginY
        
        for aCardData in NetworkManager.shared.profileObs.value.cards{
            let acard = CardView(frame: CGRect(x: 2*marginX, y: cardCursurY, width: cardwidth, height: cardHeight))
            acard.cardNo1.text = aCardData.card_number?.slice(From: 0, To: 3)
            acard.cardNo2.text = aCardData.card_number?.slice(From: 4, To: 7)
            acard.cardNo3.text = aCardData.card_number?.slice(From: 8, To: 11)
            acard.cardNo4.text = aCardData.card_number?.slice(From: 12, To: 15)
            let bankPrefixNum = aCardData.card_number?.slice(From: 0, To: 5)
            if aCardData.bank_logo == nil || aCardData.bank_name == nil {
                getBankData(bankPrefixNum!)
                    .subscribe(onNext: { innerBank in
                        if innerBank.logo != nil {
                            let imageUrl = NetworkManager.shared.baseURLString + SlidesAndPaths.shared.path_bank_logo_image + (innerBank.logo ?? "")
                            if let castedUrl = URL(string: imageUrl) {
                                acard.bankLogo.setImageFromCache(PlaceHolderName: "icon_poldarsho", Scale: 1, ImageURL: castedUrl, ImageName: innerBank.logo!)
                            }else{
                                print("ShowProfileUI : Bank Str -> URL Can not be casted ")
                            }
                        }
                        acard.nameLabel.text = innerBank.bank ?? "نامشخص"
                    }).disposed(by: myDisposeBag)
            }else{
                if aCardData.bank_logo != nil {
                    let imageUrl = NetworkManager.shared.baseURLString + SlidesAndPaths.shared.path_bank_logo_image + (aCardData.bank_logo ?? "")
                    if let castedUrl = URL(string: imageUrl) {
                        acard.bankLogo.setImageFromCache(PlaceHolderName: "icon_poldarsho", Scale: 1, ImageURL: castedUrl, ImageName: aCardData.bank_logo!)
                    }
                }
                acard.nameLabel.text = aCardData.bank_name
            }
            scrollView.addSubview(acard)
            cardCursurY = cardCursurY + marginY + acard.frame.height + cardMargin
        }
        let newCard = NewCardView(frame: CGRect(x: 2*marginX, y: cardCursurY, width: cardwidth, height: cardHeight))
        scrollView.addSubview(newCard)
        newCard.addButton.addTarget(self, action: #selector(addCardTapped), for: .touchUpInside)
        cardCursurY = cardCursurY + marginY + newCard.frame.height + cardMargin
        
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: cardCursurY)
        views["leftFormView"]!.addSubview(scrollView)
        self.delegate.paneView.addSubview(views["leftFormView"]!)
        
    }
    func getBankData(_ aPrefixNo : String) -> Observable<Bank> {
        let aParameter = ["card_number":aPrefixNo]
        return Observable.create { observer -> Disposable in
            Alamofire.request(NetworkManager.shared.baseURLString + "/" + "check-bank", method: HTTPMethod.post, parameters: aParameter, encoding: JSONEncoding.default, headers: NetworkManager.shared.headers)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error!)
                            return
                        }
                        do {
                            let newBank = try JSONDecoder().decode(Bank.self, from: data)
                            print("NewBankDecoded : ",newBank)
                            observer.onNext(newBank)
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }
    
    @objc func addCardTapped(_ sender : Any){
        self.delegate.coordinator!.pushNewCard()
    }
    
    func getProfileData() {
        let aParameter = ["user id":"\(LoginKey.shared.userID)"]
        NetworkManager.shared.run(API: "profile", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil,WithRetry: true)
    }
    
    func getAndSubscribeToPointsScores() {
        //let aParameter = ["user id":"\(LoginKey.shared.userID)"]
        NetworkManager.shared.run(API: "points-user", QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil,WithRetry: true)
        NetworkManager.shared.userPointsObs
            .subscribe(onNext: { [unowned self] aUserPoint in
                //print("Subscribed and Received : ",aUserPoint)
                self.delegate.cupScoreLabel.text = "\(aUserPoint.points_total ?? 0)"
            }).disposed(by: myDisposeBag)
    }

}
