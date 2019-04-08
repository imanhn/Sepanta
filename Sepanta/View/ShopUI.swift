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


class PostCell : UICollectionViewCell {
    
    var aPost : UIButton = UIButton(type: .custom)
}

class ShopUI : NSObject, UICollectionViewDelegateFlowLayout {
    var delegate : ShopViewController
    var views = Dictionary<String,UIView>()
    var buttons = Dictionary<String,UIButton>()
    var postsView = UIView()
    let myDisposeBag = DisposeBag()
    var rightPanelscrollView = UIScrollView()
    var collectionView : UICollectionView!
    var posts = BehaviorRelay<[Post]>(value: [Post]())
    let numberOfPostInARow : CGFloat = 4
    /*
    {
        didSet {
            sectionDataController.update(items: items, updateMode: .partial(animated: true), completion: {
                // Completed update
            })
        }
    }
    let sectionDataController = SectionDataController<Model, CollectionViewAdapter>(
        adapter: CollectionViewAdapter(collectionView: self.collectionView),
        isEqual: { $0.id == $1.id } // If Model has Equatable, you can omit this closure.
    )
   */
    init(_ vc : ShopViewController) {
        self.delegate = vc
        super.init()
        showShopPosts()
        buildPostToolbar()
        bindUIwithDataSource()
        
    }
    
    @objc func shareTapped(sender : Any){
        
    }
    @objc func addTapped(sender : Any){
        
    }
    @objc func editTapped(sender : Any){
        
    }
    @objc func newPostTapped(sender : Any){
        
    }
    @objc func followTapped(sender : Any){
        
    }
    
    func buildPostToolbar(){
        let marginY : CGFloat = 10
        let marginXBTWButtons : CGFloat = 10
        let leadingMarginX = self.delegate.offLabelLeading.constant
        let trailingMarginX = self.delegate.shopLogoTrailing.constant
        let viewWidth = self.delegate.PostToolbarView.frame.width
        let viewHeight = self.delegate.PostToolbarView.frame.height
        let buttonDim = viewHeight - (2 * marginY)
        if LoginKey.shared.role.uppercased() == "SHOP" || LoginKey.shared.role.uppercased() == "OPTIONAL(SHOP)"{
            
            let shareButton = RoundedButton(type: .custom)
            var xCursor = leadingMarginX
            shareButton.frame = CGRect(x: xCursor, y: marginY, width: buttonDim, height: buttonDim)
            shareButton.setImage(UIImage(named: "icon_share"), for: .normal)
            shareButton.contentMode = .scaleAspectFit
            shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
            self.delegate.PostToolbarView.addSubview(shareButton)

            xCursor = xCursor + marginXBTWButtons + buttonDim
            let addButton = UIButton(type: .custom)
            addButton.frame = CGRect(x: xCursor, y: marginY, width: buttonDim, height: buttonDim)
            addButton.layer.cornerRadius = 5
            addButton.layer.borderColor = UIColor(hex: 0xDA3A5C).cgColor
            addButton.setImage(UIImage(named: "icon_add_white"), for: .normal)
            addButton.backgroundColor = UIColor(hex: 0x9FDA64)
            addButton.contentMode = .scaleAspectFit
            addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
            self.delegate.PostToolbarView.addSubview(addButton)

            xCursor = xCursor + marginXBTWButtons + buttonDim
            let editButton = RoundedButton(type: .custom)
            editButton.frame = CGRect(x: xCursor, y: marginY, width: buttonDim, height: buttonDim)
            editButton.setImage(UIImage(named: "icon_edit"), for: .normal)
            editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
            self.delegate.PostToolbarView.addSubview(editButton)

            xCursor = xCursor + marginXBTWButtons + buttonDim
            let buttonWidth = viewWidth - xCursor - trailingMarginX
            let newPostButton = RoundedButton(type: .custom)
            newPostButton.frame = CGRect(x: xCursor, y: marginY, width: buttonWidth, height: buttonDim)
            newPostButton.layer.cornerRadius = 5
            newPostButton.layer.borderColor = UIColor(hex: 0xDA3A5C).cgColor
            newPostButton.setImage(UIImage(named: "icon_btn_add"), for: .normal)
            newPostButton.setTitle("پست جدید", for: .normal)
            newPostButton.setTitleColor(UIColor(hex: 0xDA3A5C), for: .normal)
            newPostButton.titleLabel?.font = UIFont(name: "Shabnam-FD", size: 16)
            newPostButton.semanticContentAttribute = .forceRightToLeft
            newPostButton.imageEdgeInsets = UIEdgeInsetsMake(0, buttonDim/2, 0, 0)
            newPostButton.addTarget(self, action: #selector(newPostTapped), for: .touchUpInside)
            self.delegate.PostToolbarView.addSubview(newPostButton)
            
        }else if LoginKey.shared.role.uppercased() == "USER" || LoginKey.shared.role.uppercased() == "OPTIONAL(USER)"{
            let shareButton = RoundedButton(type: .custom)
            var xCursor = leadingMarginX
            shareButton.frame = CGRect(x: xCursor, y: marginY, width: buttonDim, height: buttonDim)
            shareButton.setImage(UIImage(named: "icon_share"), for: .normal)
            shareButton.contentMode = .scaleAspectFit
            shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
            self.delegate.PostToolbarView.addSubview(shareButton)
            
            xCursor = xCursor + marginXBTWButtons + buttonDim
            let totalTrailingDistanceToRight = self.delegate.shopLogoTrailing.constant + self.delegate.shopLogoShopTitleDistance.constant + self.delegate.shopLogo.frame.width
            let buttonWidth = viewWidth - xCursor - totalTrailingDistanceToRight
            let followButton = RoundedButtonWithDarkBackground(type: .custom)
            followButton.frame = CGRect(x: xCursor, y: marginY, width: buttonWidth, height: buttonDim)
            followButton.setImage(UIImage(named: "icon_tick_white"), for: .normal)
            followButton.setTitle("عضویت", for: .normal)
            followButton.setTitleColor(UIColor(hex: 0xFFFFFF), for: .normal)
            followButton.titleLabel?.font = UIFont(name: "Shabnam-FD", size: 16)
            followButton.semanticContentAttribute = .forceRightToLeft
            followButton.imageEdgeInsets = UIEdgeInsetsMake(0, buttonDim/2, 0, 0)
            followButton.addTarget(self, action: #selector(followTapped), for: .touchUpInside)
            self.delegate.PostToolbarView.addSubview(followButton)

        }else{
            print("No Role Found : >\(LoginKey.shared.role.uppercased())<")
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
        self.delegate.profileRelay.subscribe(onNext: { [unowned self] aProfile in
            self.delegate.shopTitle.text = aProfile.shop_name
            self.delegate.scoreLabel.text = "امتیاز " + "\(aProfile.follower_count ?? 0)"
            self.delegate.followersNumLabel.text = "\(aProfile.follower_count ?? 0)"
            self.delegate.offLabel.text = "\(aProfile.shop_off ?? 0)%"
            self.posts.accept(aProfile.content)
            if aProfile.is_follow != nil  {
                if aProfile.is_follow! {
                    //self.delegate.followButton.setTitle("عضو شده اید", for: .normal)
                }
            }
            if aProfile.image != nil {
                let imageURL = URL(string: NetworkManager.shared.websiteRootAddress + SlidesAndPaths.shared.path_profile_image + aProfile.image!)
                //print("Shop Image : ",imageURL ?? "Nil")
                if imageURL != nil {
                    self.delegate.shopImage.setImageFromCache(PlaceHolderName: "logo_shape@1x", Scale: 1.0, ImageURL: imageURL!, ImageName: aProfile.image!)
                    
                }
            }
        })
    }
    
    func bindCollectionView(){
        self.posts.bind(to: collectionView.rx.items(cellIdentifier: "postcell")) { [unowned self] row, model, cell in
            if let aCell = cell as? PostCell {
                if aCell.aPost == nil {aCell.aPost = UIButton(type: .custom)}
                let strURL = NetworkManager.shared.websiteRootAddress + SlidesAndPaths.shared.path_post_image + model.image
                let imageURL = URL(string: strURL)
                //print("ROW:\(row) UICollectionView binding : ",imageURL ?? "NIL"," Cell : ",aCell,"  model : ",model)
                //print("URL : ",strURL)
                self.collectionView.addSubview(aCell)
                aCell.addSubview(aCell.aPost)
                if imageURL == nil {
                    //print("     Post URL is not valid : ",model.image)
                    let dim = (self.collectionView.bounds.width * 0.8) / self.numberOfPostInARow
                    aCell.aPost.frame = CGRect(x: 0, y: 0, width: dim, height: dim)
                    aCell.aPost.setImage(UIImage(named: "logo_shape"), for: .normal)
                }else{
                    let dim = (self.collectionView.bounds.width * 0.8) / self.numberOfPostInARow
                    aCell.aPost.frame = CGRect(x: 0, y: 0, width: dim, height: dim)
                    //aCell.aPost.af_setImage(for: .normal, url: imageURL!) //Also Works!
                    aCell.aPost.setImageFromCache(PlaceHolderName: "logo_shape", Scale: 1, ImageURL: imageURL!, ImageName: model.image)
                }
            }else{
                print("\(cell) can not be casted to PostCell")
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
        //let textFieldWidth = (views["rightFormView"]?.bounds.width)! - (2 * marginX)
        
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
        cursurY = cursurY + buttonHeight + marginY+20
        
        let flowLayout = UICollectionViewFlowLayout()
        /*
        flowLayout.itemSize = CGSize(width: 50, height: 50)
        flowLayout.minimumLineSpacing = 10
        flowLayout.headerReferenceSize = CGSize(width: 50, height: 50)
        flowLayout.headerReferenceSize = CGSize(width: 20 , height: 20)
        flowLayout.scrollDirection = .horizontal
 */
        flowLayout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: CGRect(x: marginX, y: cursurY, width: views["rightFormView"]!.frame.width-(2*marginX), height: views["rightFormView"]!.frame.height-cursurY), collectionViewLayout: flowLayout)
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: "postcell")
        collectionView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        collectionView.rx.setDelegate(self) //Delegate method to call
        views["rightFormView"]!.addSubview(collectionView)
        self.delegate.paneView.addSubview(views["rightFormView"]!)
        bindCollectionView()
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
        //let textFieldWidth = (views["leftFormView"]!.bounds.width) - (2 * marginX)
        
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
