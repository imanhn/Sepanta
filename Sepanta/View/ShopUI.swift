//
//  ShopUI.swift
//  Sepanta
//
//  Created by Iman on 12/20/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import Alamofire

class ButtonCell : UICollectionViewCell {
    
    var aButton : UIButton = UIButton(type: .custom)
}

class ShopUI : NSObject, UICollectionViewDelegateFlowLayout {
    var delegate : ShopViewController
    var disposeList = [Disposable]()
    var updateFromProfileDisposable : Disposable!
    var views = Dictionary<String,UIView>()
    var buttons = Dictionary<String,UIButton>()
    var postsView = UIView()
    let myDisposeBag = DisposeBag()
    var rightPanelscrollView = UIScrollView()
    var collectionView : UICollectionView!
    var posts = BehaviorRelay<[Post]>(value: [Post]())
    let numberOfPostInARow : CGFloat = 4
    var isShop : Bool
    var cursurY : CGFloat = 0
    let marginY : CGFloat = 20
    let marginX : CGFloat = 10
    init(_ vc : ShopViewController) {
        self.delegate = vc
        if  LoginKey.shared.role.uppercased() == "SHOP" || LoginKey.shared.role.uppercased() == "OPTIONAL(SHOP)" ||
            LoginKey.shared.role.uppercased() == "SELLER" || LoginKey.shared.role.uppercased() == "OPTIONAL(SELLER)" {
            isShop = true
        }else
        {
            isShop = false
        }
        //isShop = true
        super.init()
        buildPostToolbar()
        bindUIwithDataSource()
        showShopPosts()
        manageLogoutButton()
    }
    
    func manageLogoutButton(){
        //if self.delegate.
        if isShop && self.delegate.editAuthorized() {
            self.delegate.logoutButton.isHidden = false
        }
        else{
            self.delegate.logoutButton.isHidden = true
        }
        //self.delegate.logoutButton.
    }
    
    @objc func shareTapped(sender : Any){
        var shopURL = NetworkManager.shared.profileObs.value.url
        if shopURL == nil {
            if let ashopID = NetworkManager.shared.profileObs.value.shop_id  {
                shopURL = "/shop/\(ashopID)"
            }
        }
        
        guard shopURL != nil else {
            self.delegate.alert(Message: "اطلاعات فروشگاه برای به اشتراک گذاری کامل نیست")
            return
        }
        let activityVC = UIActivityViewController(activityItems: ["www.ipsepanta.ir"+shopURL!], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.delegate.view
        self.delegate.present(activityVC, animated: true, completion: nil)
    }
    
    @objc func cupTapped(sender : Any){
        if (NetworkManager.shared.userPointsObs.value.status ?? "").count == 0 {
            NetworkManager.shared.run(API: "points-user", QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil,WithRetry: true)
        }
        NetworkManager.shared.userPointsObs
            .filter({($0.status ?? "").count > 0})
            .share(replay: 1, scope: .whileConnected)
            .subscribe(onNext: { [unowned self] aUserPoint in
                //print("Subscribed and Received : ",aUserPoint)
                self.delegate.coordinator!.pushScores()
            }).disposed(by: myDisposeBag)
    }
    
    @objc func sepantaieTapped(sender : Any){
        updateFromProfileDisposable?.dispose()
        self.delegate.coordinator!.pushMyFollowingShops()
    }
    
    @objc func newPostTapped(sender : Any){
        self.delegate.coordinator!.pushAddPost()
    }
    
    @objc func followTapped(sender : Any){
        if buttons["followButton"] == nil {
            print("Error ShopUI: Odd!, followbutton should not be NIL here!")
            return
        }
        buttons["followButton"]!.setDisable()
        Spinner.start()
        var aProfile = NetworkManager.shared.profileObs.value
        let aParameter = ["shop id":"\(aProfile.shop_id ?? 0)"]
        NetworkManager.shared.run(API: "follow-unfollow-request", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil,WithRetry: false)
        let statusDisp = NetworkManager.shared.status
            .filter({$0 == CallStatus.ready})
            .subscribe(onNext: { [unowned self] (innerStatus) in
            print("innerStatus : ",innerStatus)
            if innerStatus == CallStatus.ready {
                //print("Before : \(String(describing: aProfile.is_follow))")
                aProfile.is_follow = !(aProfile.is_follow ?? false )
               // print("After : \(String(describing: aProfile.is_follow))")
                NetworkManager.shared.profileObs.accept(aProfile)
                self.buttons["followButton"]!.setEnable()
                //print("Done")
            }else{
                self.buttons["followButton"]!.setEnable()
                print("Follow request Not Done! because status is not ready Status : ",innerStatus)
            }
            Spinner.stop()
            NetworkManager.shared.status = BehaviorRelay<CallStatus>(value: CallStatus.ready)
        }, onError: { _ in
            print("Error")
            self.buttons["followButton"]!.setEnable()
            self.delegate.alert(Message: "عضویت قابل انجام نیست، احتمالاْ شبکه قطع می باشد مجددا تلاش فرمایید.")
            NetworkManager.shared.status = BehaviorRelay<CallStatus>(value: CallStatus.ready)
            Spinner.stop()
        })
        statusDisp.disposed(by: myDisposeBag)
        disposeList.append(statusDisp)
    }
    

    func buildPostToolbar(){
        let marginXBTWButtons : CGFloat = 10
        //let leadingMarginX = self.delegate.offLabelLeading.constant
        //let trailingMarginX = self.delegate.shopLogoTrailing.constant
        let viewWidth = self.delegate.PostToolbarView.frame.width
        let viewHeight = self.delegate.PostToolbarView.frame.height
        var buttonDim = viewHeight*0.9
        
        if isShop && self.delegate.editAuthorized() {
            buttonDim = (viewWidth - (3 * marginXBTWButtons))/6
            buttons["shareButton"] = RoundedButton(type: .custom)
            var xCursor : CGFloat = 0
            buttons["shareButton"]!.frame = CGRect(x: xCursor, y: 0, width: buttonDim, height: buttonDim)
            buttons["shareButton"]!.setImage(UIImage(named: "icon_share"), for: .normal)
            buttons["shareButton"]!.contentMode = .scaleAspectFit
            buttons["shareButton"]!.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
            self.delegate.PostToolbarView.addSubview(buttons["shareButton"]!)
            xCursor = xCursor + marginXBTWButtons + buttonDim
            
            buttons["cupButton"] = RoundedButton(type: .custom)
            buttons["cupButton"]!.frame = CGRect(x: xCursor, y: 0, width: buttonDim, height: buttonDim)
            buttons["cupButton"]!.layer.cornerRadius = 5
            buttons["cupButton"]!.layer.borderColor = UIColor(hex: 0xDA3A5C).cgColor
            buttons["cupButton"]!.setImage(UIImage(named: "icon_profile_cup"), for: .normal)
            buttons["cupButton"]!.imageEdgeInsets = UIEdgeInsetsMake(buttonDim/6, buttonDim/5, buttonDim/6, buttonDim/5)
            buttons["cupButton"]!.contentMode = .scaleAspectFit
            buttons["cupButton"]!.addTarget(self, action: #selector(cupTapped), for: .touchUpInside)
            self.delegate.PostToolbarView.addSubview(buttons["cupButton"]!)
            xCursor = xCursor + marginXBTWButtons + buttonDim
            
            buttons["sepantaieButton"] = RoundedButton(type: .custom)
            buttons["sepantaieButton"]!.frame = CGRect(x: xCursor, y: 0, width: buttonDim, height: buttonDim)
            buttons["sepantaieButton"]!.layer.cornerRadius = 5
            buttons["sepantaieButton"]!.layer.borderColor = UIColor(hex: 0xDA3A5C).cgColor
            buttons["sepantaieButton"]!.setImage(UIImage(named: "icon_sepantaei"), for: .normal)
            buttons["sepantaieButton"]!.imageEdgeInsets = UIEdgeInsetsMake(buttonDim/6, buttonDim/4, buttonDim/6, buttonDim/4)
            buttons["sepantaieButton"]!.addTarget(self, action: #selector(sepantaieTapped), for: .touchUpInside)
            self.delegate.PostToolbarView.addSubview(buttons["sepantaieButton"]!)
            xCursor = xCursor + marginXBTWButtons + buttonDim
            
            //let buttonWidth = viewWidth - xCursor - trailingMarginX - leadingMarginX -  marginXBTWButtons
            let buttonWidth = buttonDim * 3
            
            buttons["newPostButton"] = RoundedButton(type: .custom)
            buttons["newPostButton"]!.frame = CGRect(x: xCursor, y: 0, width: buttonWidth, height: buttonDim)
            buttons["newPostButton"]!.layer.cornerRadius = 5
            buttons["newPostButton"]!.layer.borderColor = UIColor(hex: 0xDA3A5C).cgColor
            buttons["newPostButton"]!.setImage(UIImage(named: "icon_btn_add"), for: .normal)
            buttons["newPostButton"]!.setTitle("پست جدید", for: .normal)
            buttons["newPostButton"]!.setTitleColor(UIColor(hex: 0xDA3A5C), for: .normal)
            buttons["newPostButton"]!.titleLabel?.font = UIFont(name: "Shabnam-FD", size: 16)
            buttons["newPostButton"]!.semanticContentAttribute = .forceRightToLeft
            buttons["newPostButton"]!.imageEdgeInsets = UIEdgeInsetsMake(0, buttonDim/2, 0, 0)
            buttons["newPostButton"]!.addTarget(self, action: #selector(newPostTapped), for: .touchUpInside)
            self.delegate.PostToolbarView.addSubview(buttons["newPostButton"]!)
            //print("buttons[newPostButton].wd : ",buttons["newPostButton"]!.frame.width)
            
        }else{
            buttons["shareButton"] = RoundedButton(type: .custom)
            var xCursor : CGFloat = 0
            buttons["shareButton"]!.frame = CGRect(x: xCursor, y: 0, width: buttonDim, height: buttonDim)
            buttons["shareButton"]!.setImage(UIImage(named: "icon_share"), for: .normal)
            buttons["shareButton"]!.contentMode = .scaleAspectFit
            buttons["shareButton"]!.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
            self.delegate.PostToolbarView.addSubview(buttons["shareButton"]!)
            
            xCursor = xCursor + marginXBTWButtons + buttonDim
            let totalTrailingDistanceToRight = self.delegate.shopLogoTrailing.constant + self.delegate.shopLogoShopTitleDistance.constant + self.delegate.shopLogo.frame.width
            let buttonWidth = viewWidth - xCursor - totalTrailingDistanceToRight
            buttons["followButton"] = SubmitButton(type: .custom)
            buttons["followButton"]!.frame = CGRect(x: xCursor, y: 0, width: buttonWidth, height: buttonDim)
            buttons["followButton"]!.setTitle("بررسی عضویت...", for: .normal)
            buttons["followButton"]!.addTarget(self, action: #selector(followTapped), for: .touchUpInside)
            buttons["followButton"]!.setDisable()
            self.delegate.PostToolbarView.addSubview(buttons["followButton"]!)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 30) / numberOfPostInARow // compute your cell width
        //print("WOW Calling layout cell width : ",cellWidth," index : ",indexPath)
        //return CGSize(width: 50 , height: 50)
        return CGSize(width: cellWidth, height: cellWidth)
    }

    
    func bindUIwithDataSource(){
        let shopFavDisp = NetworkManager.shared.shopFav
            .filter({$0 != ToggleStatus.UNKNOWN})
            .subscribe(onNext: { [unowned self] (favShopStatus) in
                if self.delegate.favButton != nil {
                    if favShopStatus == ToggleStatus.YES {
                        self.delegate.favButton.setImage(UIImage(named: "icon_star_fav_dark"), for: .normal)
                    }else{
                        self.delegate.favButton.setImage(UIImage(named: "icon_star_fav_gray"), for: .normal)
                    }
                }
            })
        shopFavDisp.disposed(by: myDisposeBag)
        disposeList.append(shopFavDisp)
        
        updateFromProfileDisposable = NetworkManager.shared.profileObs
            .filter({$0.id != nil})
            .subscribe(onNext: { [weak self] aProfile in
                //print("SUBSCRIPTION UPDATE",aProfile)
                //print("Before Shop : ",self.delegate.shop)
                self?.delegate.shop.updateFromProfile(Profile: aProfile)
                //print("After Shop : ",self.delegate.shop)
                self?.delegate.shopTitle.text = aProfile.shop_name
                self?.delegate.scoreLabel.text = "امتیاز " + "\(aProfile.follower_count ?? 0)"
                self?.delegate.followersNumLabel.text = "\(aProfile.follower_count ?? 0)"
                self?.delegate.offLabel.text = "\(aProfile.shop_off ?? 0)%"
                self?.delegate.rateLabel.text = "(\(aProfile.rate ?? "0"))"
                let rate : Float = Float(aProfile.rate ?? "0.0") ?? 0
                if rate > 0.5 {self?.delegate.star1.image = UIImage(named: "icon_star_on")}
                if rate > 1.5 {self?.delegate.star2.image = UIImage(named: "icon_star_on")}
                if rate > 2.5 {self?.delegate.star3.image = UIImage(named: "icon_star_on")}
                if rate > 3.5 {self?.delegate.star4.image = UIImage(named: "icon_star_on")}
                if rate > 4.5 {self?.delegate.star5.image = UIImage(named: "icon_star_on")}
                //print("ShopUI : setting shopui.posts to  :: ",aProfile.content)
                if let postContents = aProfile.content as? [Post] {
                    self?.posts.accept(postContents)
                }else{
                    print("aProfile.content has shops but expected to have posts")
                    self?.delegate.alert(Message: "خطای داخلی اتفاق افتاده است")
                    return
                }
                //print("Profile : ",aProfile)
                if self?.buttons["followButton"] != nil {
                    if aProfile.is_follow != nil  {
                        if aProfile.is_follow! {
                            self?.buttons["followButton"]!.setTitle("عضو شده اید", for: .normal)
                            self?.buttons["followButton"]!.setEnable()
                        }else{
                            self?.buttons["followButton"]!.setTitle("عضویت", for: .normal)
                            self?.buttons["followButton"]!.setEnable()
                        }
                    }
                }
                
                if (self?.delegate.favButton != nil){ //Otherwise the fav button is removed!
                    if aProfile.is_favorite != nil{
                        if aProfile.is_favorite! {
                            self?.delegate.favButton.setImage(UIImage(named: "icon_star_fav_dark"), for: .normal)
                        }else{
                            self?.delegate.favButton.setImage(UIImage(named: "icon_star_fav_gray"), for: .normal)
                        }
                    }
                }
                
                if aProfile.image != nil {
                    let imageURL = URL(string: NetworkManager.shared.websiteRootAddress + SlidesAndPaths.shared.path_profile_image + aProfile.image!)
                    //print("Shop Image : ",imageURL ?? "Nil")
                    if imageURL != nil {
                        self?.delegate.shopImage.setImageFromCache(PlaceHolderName: "logo_shape@1x", Scale: 1.0, ImageURL: imageURL!, ImageName: aProfile.image!,ContentMode: UIViewContentMode.scaleToFill)
                        self?.delegate.shopLogo.setImageFromCache(PlaceHolderName: "logo_shape@1x", Scale: 1.0, ImageURL: imageURL!, ImageName: aProfile.image!)
                        self?.delegate.shopLogo.layer.shadowColor = UIColor.black.cgColor
                        self?.delegate.shopLogo.layer.shadowOffset = CGSize(width: 3, height: 3)
                        self?.delegate.shopLogo.layer.shadowRadius = 3
                        self?.delegate.shopLogo.layer.shadowOpacity = 0.3
                    }
                }
                //if aProfil
            })
        updateFromProfileDisposable.disposed(by: myDisposeBag)
        disposeList.append(updateFromProfileDisposable)
    }
    
    func bindCollectionView(){
        let postsCollectionViewDisp = self.posts.bind(to: collectionView.rx.items(cellIdentifier: "buttoncell")) { [weak self] row, model, cell in
            if let aCell = cell as? ButtonCell {
                //if aCell.aButton == nil {aCell.aButton = UIButton(type: .custom)}
                let strURL = NetworkManager.shared.websiteRootAddress + SlidesAndPaths.shared.path_post_image + model.image!
                let imageURL = URL(string: strURL)
                let dim = ((self?.collectionView.bounds.width ?? 50) * 0.8) / (self?.numberOfPostInARow ?? 3)
                //print("ROW:\(row) UICollectionView binding : ",imageURL ?? "NIL"," Cell : ",aCell,"  model : ",model)
                //print("ShopUI Binding Posts : ",model)
                //self?.collectionView.addSubview(aCell)
                aCell.aButton.frame = CGRect(x: 0, y: 0, width: dim, height: dim)
                aCell.addSubview(aCell.aButton)
                if imageURL == nil {
                    //print("     Post URL is not valid : ",model.image)
                    aCell.aButton.setImage(UIImage(named: "logo_shape"), for: .normal)
                }else{
                    //aCell.aButton.af_setImage(for: .normal, url: imageURL!) //Also Works!
                    aCell.aButton.setImageFromCache(PlaceHolderName: "logo_shape", Scale: 1, ImageURL: imageURL!, ImageName: model.image!)
                }
                aCell.aButton.layer.shadowColor = UIColor.black.cgColor
                aCell.aButton.layer.shadowOffset = CGSize(width: 3, height: 3)
                aCell.aButton.layer.shadowRadius = 2
                aCell.aButton.layer.shadowOpacity = 0.2
                aCell.aButton.tag = model.id ?? 0
                aCell.aButton.addTarget(self, action: #selector(self?.showPostDetail), for: .touchUpInside)
            }else{
                print("\(cell) can not be casted to ButtonCell")
            }
            }
        postsCollectionViewDisp.disposed(by: myDisposeBag)
        disposeList.append(postsCollectionViewDisp)

    }
    //Create Gradient on PageView
    func showShopPosts() {
        //print("reseller Request : ",views["leftFormView"] ?? "Nil")
        
        self.delegate.contentView.subviews.forEach({$0.removeFromSuperview()})

        self.delegate.PostsButton.setTitleColor(UIColor(hex: 0x515152), for: .normal)
        self.delegate.ContactButton.setTitleColor(UIColor(hex: 0xD6D7D9), for: .normal)

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        let collectionViewRect = CGRect(x: marginX, y: marginY, width: self.delegate.contentView.frame.width-(2*marginX), height: self.delegate.contentView.frame.height-2*marginY)
        collectionView = UICollectionView(frame: collectionViewRect, collectionViewLayout: flowLayout)
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: "buttoncell")
        collectionView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        _ = collectionView.rx.setDelegate(self) //Delegate method to call
        bindCollectionView()
        self.delegate.contentView.addSubview(collectionView)
    }
    
    func showContacts() {
        
        self.delegate.contentView.subviews.forEach({$0.removeFromSuperview()})
        
        self.delegate.PostsButton.setTitleColor(UIColor(hex: 0xD6D7D9), for: .normal)
        self.delegate.ContactButton.setTitleColor(UIColor(hex: 0x515152), for: .normal)

        self.delegate.contentView.subviews.forEach({$0.removeFromSuperview()})
        disposeList.forEach({$0.dispose()})
        cursurY = 0
        let aProfile = NetworkManager.shared.profileObs.value
        let buttonHeight = self.delegate.contentView.frame.height / 7
        let textFieldWidth = (self.delegate.contentView.bounds.width) - (2 * marginX)
        var shopView = UIView()
        let sepantaText = aProfile.shop_name ?? ""
        (shopView,_) = CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight).buildALabelView(Image: "icon_profile_05",  LabelText: sepantaText,Lines : 3)
        cursurY = cursurY + shopView.frame.height + marginY/2
        self.delegate.contentView.addSubview(shopView)
        
        let sepantaAddress = aProfile.address ?? ""
        var addressView = UIView()
        (addressView,_) = CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight).buildALabelView(Image: "icon_profile_06",  LabelText: sepantaAddress,Lines : 2)
        cursurY = cursurY + addressView.frame.height + marginY/2
        self.delegate.contentView.addSubview(addressView)
        
        var telView = UIView()
        let shopTel = (aProfile.phone ?? "").toPersianNumbers()
        (telView,_) = CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight).buildALabelView(Image: "icon_profile_07",  LabelText: shopTel,Lines: 1)
        cursurY = cursurY + telView.frame.height + marginY/2
        self.delegate.contentView.addSubview(telView)
        
        var webView = UIView()
        let webAddress = "www.ipsepanta.ir" + (aProfile.url ?? "")
        (webView,_) = CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight).buildALabelView(Image: "web",  LabelText: webAddress,Lines: 1)
        cursurY = cursurY + webView.frame.height + marginY/2
        self.delegate.contentView.addSubview(webView)
        
        /*var emailAddress = aProfile. ?? ""
        var emailView = UIView()
        (emailView,_) = CGRect(x: marginX, y: cursurY, width: textFieldWidth, height: buttonHeight).buildALabelView(Image: "black-back-closed-envelope-shape",  LabelText: "info@ipsepanta.ir",Lines: 1)
        cursurY = cursurY + emailView.frame.height + marginY/2
        self.delegate.contentView.addSubview(emailView)
        */
    }
    
    @objc func showPostDetail(_ sender : Any){
        let aButton = (sender as? UIButton)
        guard aButton?.tag != nil else {return}
        var selectedPost : Post!
        for apost in self.posts.value {
            if apost.id == aButton?.tag {
                selectedPost = apost
                break
            }
        }
        self.delegate.coordinator!.PushAPost(PostID: selectedPost.id ?? (aButton?.tag)!, OwnerUserID: self.delegate.shop.user_id!)
        /*
        let postID = (sender as! UIButton).tag
        print("ShopUI : Pushing Post with ID : ",postID)
        self.delegate.coordinator?.PushAPost(PostID: postID)
         */
    }
}
