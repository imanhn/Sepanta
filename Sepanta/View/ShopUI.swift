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

class PostCell : UICollectionViewCell {
    var aPost : UIButton!
}

class ShopUI : NSObject, UICollectionViewDelegateFlowLayout {
    var delegate : ShopViewController
    var views = Dictionary<String,UIView>()
    var buttons = Dictionary<String,UIButton>()
    var postsView = UIView()
    var myDisposeBag = DisposeBag()
    var rightPanelscrollView = UIScrollView()
    var collectionView: UICollectionView!
    var posts = BehaviorRelay<[Post]>(value: [Post]())
    init(_ vc : ShopViewController) {
        self.delegate = vc
        super.init()
        showShopPosts()
        bindUIwithDataSource()
    }


    func bindUIwithDataSource(){
        self.delegate.profileRelay.subscribe(onNext: { [unowned self] aProfile in
            self.delegate.shopTitle.text = aProfile.shop_name
            self.delegate.scoreLabel.text = "امتیاز " + "\(aProfile.follower_count ?? 0)"
            self.delegate.followersNumLabel.text = "\(aProfile.follower_count ?? 0)"
            self.delegate.offLabel.text = "\(aProfile.shop_off ?? 0)%"
            self.posts.accept(aProfile.content)
            if aProfile.is_follow != nil  {
                if aProfile.is_follow! {
                    self.delegate.followButton.setTitle("عضو شده اید", for: .normal)
                }
            }
            if aProfile.image != nil {
                let imageURL = URL(string: NetworkManager.shared.websiteRootAddress + SlidesAndPaths.shared.path_profile_image + aProfile.image!)
                print("Shop Image : ",imageURL)
                if imageURL != nil {
                    self.delegate.shopImage.setImageFromCache(PlaceHolderName: "logo_shape@1x", Scale: 1.0, ImageURL: imageURL!, ImageName: aProfile.image!)
                    
                }
            }
            let margin : CGFloat = 10
            let buttonDim = self.postsView.frame.height - (2 * margin)
            let frameWidth = self.postsView.frame.width
            let frameHeight = self.postsView.frame.height
            let row : CGFloat = 1
            var col : CGFloat = 1
            for acontent in aProfile.content {
                print("Adding a button ")
                let aPostButton = UIButton(type: .custom)
                //aPostButton.frame = CGRect(x: (frameWidth - (col * (buttonDim+margin))), y: ((row * margin) + (row-1) * buttonDim), width: buttonDim, height: buttonDim)
                aPostButton.frame = CGRect(x: ( (col-1) * buttonDim + col*margin), y: ((row * margin) + (row-1) * buttonDim), width: buttonDim, height: buttonDim)
                let imageURL = URL(string: NetworkManager.shared.websiteRootAddress + SlidesAndPaths.shared.path_post_image + acontent.image)
                //aPostButton.backgroundColor = UIColor(hex: 0x515151)
                aPostButton.layer.cornerRadius = 5
                aPostButton.layer.masksToBounds = true
                print("Adding a button URL : ",aPostButton.frame)
                //aPostButton.imageView?.setImageFromCache(PlaceHolderName: "logo_shapein_boxed", Scale: 1.0, ImageURL: imageURL!, ImageName: acontent.image)
                aPostButton.af_setBackgroundImage(for: .normal, url: imageURL!)
                aPostButton.setImageFromCache(PlaceHolderName: "logo_shape@1x", Scale: 1.0, ImageURL: imageURL!, ImageName: acontent.image)
                //aPostButton.setTitle("HELO", for: .normal)
                self.postsView.addSubview(aPostButton)
                col = col + 1
            }
            self.rightPanelscrollView.contentSize = CGSize(width: self.postsView.frame.width*2, height: self.postsView.frame.height)
            //self.rightPanelscrollView.frame = CGRect(x: (frameWidth - (col * (buttonDim+margin)))-30, y: 0, width: self.postsView.frame.width*2, height: self.postsView.frame.height)
        })
        
        self.posts.bind(to: collectionView.rx.items(cellIdentifier: "cell")) { row, model, cell in
            if let aCell = cell as? PostCell {
//                aCell.shopName.text = model.name
                let strURL = NetworkManager.shared.baseURLString + SlidesAndPaths.shared.path_post_image + model.image
                let imageURL = URL(string: strURL)
                if imageURL != nil {
                    aCell.aPost.af_setImage(for: .normal, url: imageURL!)
                }else{
                    print("Error parsing Image URL for Post in Bind section of ShopUI")
                }
            }
            }.disposed(by: myDisposeBag)

    }
    //Create Gradient on PageView
    func showShopPosts() {
        //print("reseller Request : ",views["leftFormView"] ?? "Nil")
        if views["leftFormView"] != nil && views["leftFormView"]?.superview != nil { views["leftFormView"]?.removeFromSuperview()}
        var cursurY : CGFloat = 0
        let marginY : CGFloat = 0
        let marginX : CGFloat = 10
        
        //self.delegate.paneView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height * 2)+40)
        
        views["rightFormView"] = RightTabbedView(frame: CGRect(x: marginX, y: marginY, width: self.delegate.paneView.frame.width-2*marginX, height: self.delegate.paneView.frame.height-marginY))
        views["rightFormView"]!.backgroundColor = UIColor.clear
        let buttonsFont = UIFont(name: "Shabnam-Bold-FD", size: 14)
        let buttonHeight = (views["rightFormView"] as! RightTabbedView).getHeight()
        let textFieldWidth = (views["rightFormView"]?.bounds.width)! - (2 * marginX)
        
        buttons["leftButton"] = UIButton(frame: CGRect(x: 0, y: 0, width: (views["rightFormView"]?.bounds.width)!/2, height: buttonHeight))
        buttons["leftButton"]!.setTitle("اطلاعات ارتباطی", for: .normal)
        buttons["leftButton"]!.titleLabel?.font = buttonsFont
        buttons["leftButton"]!.addTarget(self.delegate, action: #selector(self.delegate.contactTapped), for: .touchUpInside)
        buttons["leftButton"]!.setTitleColor(UIColor(hex: 0x515152), for: .normal)
        
        buttons["rightButton"] = UIButton(frame: CGRect(x: views["rightFormView"]!.bounds.width/2, y: 0, width: views["rightFormView"]!.bounds.width/2, height: buttonHeight))
        buttons["rightButton"]!.setTitle("مطالب ارسال شده", for: .normal)
        buttons["rightButton"]!.titleLabel?.font = buttonsFont
        buttons["rightButton"]!.setTitleColor(UIColor(hex: 0x515152), for: .normal)
        
        views["rightFormView"]!.addSubview(buttons["leftButton"]!)
        views["rightFormView"]!.addSubview(buttons["rightButton"]!)
        cursurY = cursurY + buttonHeight + marginY
//        postsView.frame = CGRect(x: marginX, y: cursurY, width: views["rightFormView"]!.frame.width, height: views["rightFormView"]!.frame.height-cursurY)
        
        /*
        rightPanelscrollView = UIScrollView(frame: CGRect(x: 0, y: cursurY, width: views["rightFormView"]!.frame.width, height: views["rightFormView"]!.frame.height-cursurY))
        
        postsView.frame = CGRect(x: 0, y: 0, width: views["rightFormView"]!.frame.width, height: views["rightFormView"]!.frame.height-cursurY)
        
        rightPanelscrollView.addSubview(postsView)
        views["rightFormView"]!.addSubview(rightPanelscrollView)
 */
        
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect(x: 0, y: cursurY, width: views["rightFormView"]!.frame.width, height: views["rightFormView"]!.frame.height-cursurY), collectionViewLayout: flowLayout)
        self.collectionView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.0)
        views["rightFormView"]!.addSubview(collectionView)
        self.delegate.paneView.addSubview(views["rightFormView"]!)
    }
    
    
    
    func showContacts() {
        //print("Card Request  : ",views["rightFormView"]!,"  SuperView : ",views["rightFormView"]!.superview ?? "Nil")
        if views["rightFormView"]?.superview != nil { views["rightFormView"]?.removeFromSuperview()}
        var cursurY : CGFloat = 0
        let marginY : CGFloat = 0
        let marginX : CGFloat = 10
        views["leftFormView"] = LeftTabbedView(frame: CGRect(x: marginX, y: marginY, width: self.delegate.paneView.frame.width-2*marginX, height: self.delegate.paneView.frame.height-marginY))
        views["leftFormView"]!.backgroundColor = UIColor.clear
        
        
        let buttonsFont = UIFont(name: "Shabnam-Bold-FD", size: 14)
        let buttonHeight = (views["leftFormView"] as! LeftTabbedView).getHeight()
        let textFieldWidth = (views["leftFormView"]!.bounds.width) - (2 * marginX)
        
        buttons["leftButton"] = UIButton(frame: CGRect(x: 0, y: 0, width: views["leftFormView"]!.bounds.width/2, height: buttonHeight))
        buttons["leftButton"]!.setTitle("اطلاعات ارتباطی", for: .normal)
        buttons["leftButton"]!.titleLabel?.font = buttonsFont
        //buttons["leftButton"]!.addTarget(self, action: #selector(self.cardRequestTapped(_:)), for: .touchUpInside)
        buttons["leftButton"]!.setTitleColor(UIColor(hex: 0x515152), for: .normal)
        
        
        buttons["rightButton"] = UIButton(frame: CGRect(x: views["leftFormView"]!.bounds.width/2, y: 0, width: views["leftFormView"]!.bounds.width/2, height: buttonHeight))
        buttons["rightButton"]!.setTitle("مطالب ارسال شده", for: .normal)
        buttons["rightButton"]!.titleLabel?.font = buttonsFont
        buttons["rightButton"]!.addTarget(self.delegate, action: #selector(self.delegate.showPostTapped), for: .touchUpInside)
        buttons["rightButton"]!.setTitleColor(UIColor(hex: 0x515152), for: .normal)
        
        views["leftFormView"]!.addSubview(buttons["leftButton"]!)
        views["leftFormView"]!.addSubview(buttons["rightButton"]!)
        cursurY = cursurY + buttonHeight + marginY
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: cursurY, width: views["rightFormView"]!.frame.width, height: views["rightFormView"]!.frame.height-buttonHeight))
        views["rightFormView"]!.addSubview(scrollView)
        
        self.delegate.paneView.addSubview(views["leftFormView"]!)
        
    }

}
