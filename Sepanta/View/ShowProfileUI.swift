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


class ShowProfileUI : NSObject,UICollectionViewDelegateFlowLayout {
    var delegate : ProfileViewController!
    var views = Dictionary<String,UIView>()
    var buttons = Dictionary<String,UIButton>()
    var collectionView : UICollectionView!
    var myDisposeBag = DisposeBag()
    var shops = BehaviorRelay<[Shop]>(value: [Shop]())
    let numberOfFollowedShopInARow : CGFloat = 4
    
    init(_ vc : ProfileViewController) {
        super.init()
        self.delegate = vc
        showMyClub()
        bindUIwithDataSource()
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
        let marginY : CGFloat = 20
        let marginX : CGFloat = 10
        
        //self.delegate.paneView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height * 2)+40)
        
        views["rightFormView"] = RightTabbedView(frame: CGRect(x: marginX, y: marginY, width: self.delegate.paneView.frame.width-2*marginX, height: self.delegate.paneView.frame.height-marginY))
        views["rightFormView"]!.backgroundColor = UIColor.clear
        let buttonsFont = UIFont(name: "Shabnam-Bold-FD", size: 14)
        let buttonHeight = (views["rightFormView"] as! RightTabbedView).getHeight()
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
        getProfileData()
        bindCollectionView()
        bindUIwithDataSource()
    }
    
    func bindUIwithDataSource() {
       NetworkManager.shared.profileObs
        .subscribe(onNext: { [unowned self] aProfile in
            if aProfile.image != nil && aProfile.image!.count > 0 {
                let imageUrl = NetworkManager.shared.baseURLString + SlidesAndPaths.shared.path_profile_image + aProfile.image!
                let castedUrl = URL(string: imageUrl)
                if castedUrl != nil {
                    self.delegate.profilePicture.setImageFromCache(PlaceHolderName: "icon_profile_img", Scale: 1, ImageURL: castedUrl!, ImageName: aProfile.image!)
                }else{
                    print("URL Can not be casted : ",imageUrl)
                }
            }
            self.delegate.nameLabel.text =  aProfile.fullName
            self.delegate.descLabel.text = aProfile.fullName
            //self.delegate.cupLabel
            self.delegate.clubNumLabel.text = "\(aProfile.follow_count ?? 0)"
            //print("aProfile.content : ",aProfile.content)
            self.shops.accept(aProfile.content as! [Shop])
        }).disposed(by: myDisposeBag)
    }
    
    func bindCollectionView(){
        self.shops.bind(to: collectionView.rx.items(cellIdentifier: "shopcell")) { [unowned self] row, model, cell in
            if let aCell = cell as? ButtonCell {
                //if aCell.aButton == nil {aCell.aButton = UIButton(type: .custom)}
                let strURL = NetworkManager.shared.websiteRootAddress + SlidesAndPaths.shared.path_post_image + model.image!
                let imageURL = URL(string: strURL)
                //print("ROW:\(row) UICollectionView binding : ",imageURL ?? "NIL"," Cell : ",aCell,"  model : ",model)
                //print("ShopUI Binding Posts : ",model)
                self.collectionView.addSubview(aCell)
                aCell.addSubview(aCell.aButton)
                if imageURL == nil {
                    print("     Post URL is not valid : ",model.image)
                    let dim = (self.collectionView.bounds.width * 0.8) / self.numberOfFollowedShopInARow
                    aCell.aButton.frame = CGRect(x: 0, y: 0, width: dim, height: dim)
                    aCell.aButton.setImage(UIImage(named: "logo_shape"), for: .normal)
                }else{
                    let dim = (self.collectionView.bounds.width * 0.8) / self.numberOfFollowedShopInARow
                    aCell.aButton.frame = CGRect(x: 0, y: 0, width: dim, height: dim)
                    //aCell.aButton.af_setImage(for: .normal, url: imageURL!) //Also Works!
                    aCell.aButton.setImageFromCache(PlaceHolderName: "logo_shape", Scale: 1, ImageURL: imageURL!, ImageName: model.image!)
                }
                aCell.aButton.layer.shadowColor = UIColor.black.cgColor
                aCell.aButton.layer.shadowOffset = CGSize(width: 3, height: 3)
                aCell.aButton.layer.shadowRadius = 2
                aCell.aButton.layer.shadowOpacity = 0.2

                aCell.aButton.tag = model.user_id ?? 0
                aCell.aButton.addTarget(self, action: #selector(self.shopShopDetail), for: .touchUpInside)
            }else{
                print("\(cell) can not be casted to PostCell")
            }
            }.disposed(by: myDisposeBag)
        
        
    }
    
    @objc func shopShopDetail(){
        
    }
    
    func showContacts() {
        //print("Card Request  : ",views["rightFormView"]!,"  SuperView : ",views["rightFormView"]!.superview ?? "Nil")
        if views["rightFormView"]?.superview != nil { views["rightFormView"]?.removeFromSuperview()}
        var cursurY : CGFloat = 0
        let marginY : CGFloat = 20
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

        let scrollView = UIScrollView(frame: CGRect(x: 0, y: cursurY, width: views["rightFormView"]!.frame.width, height: views["rightFormView"]!.frame.height-buttonHeight))
        views["rightFormView"]!.addSubview(scrollView)

        self.delegate.paneView.addSubview(views["leftFormView"]!)
        
    }
    
    func getProfileData() {
        let aParameter = ["user id":"\(LoginKey.shared.userID)"]
        NetworkManager.shared.run(API: "profile", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil,WithRetry: true)
    }
}
