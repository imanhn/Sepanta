//
//  NotificationsViewController.swift
//  Sepanta
//
//  Created by Iman on 2/1/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ShopNotifCell : UITableViewCell {
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
}

class NotificationsViewController : UIViewControllerWithErrorBar,XIBView,UITableViewDelegate{
    @IBOutlet weak var NotifTableView: UITableView!
    var myDisposeBag = DisposeBag()
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tabbedView: TabbedViewWithWhitePanel!
    var disposeList = [Disposable]()
    
    weak var coordinator : HomeCoordinator?
    
    @IBAction func backTapped(_ sender: Any) {
        disposeList.forEach({$0.dispose()})
        self.coordinator!.popOneLevel()
    }
    
    @IBAction func homeTapped(_ sender: Any) {
        disposeList.forEach({$0.dispose()})
        self.coordinator!.popHome()
    }

    @IBAction func shopNotifTapped(_ sender: Any) {
        disposeList.forEach({$0.dispose()})
        bindNotificationForUser()
        self.tabbedView.tabJust = TabViewJustification.Right
        self.tabbedView.setNeedsDisplay()
    }
    @IBAction func generalNotifTapped(_ sender: Any) {
        disposeList.forEach({$0.dispose()})
        bindGeneralNotification()
        self.tabbedView.tabJust = TabViewJustification.Left
        self.tabbedView.setNeedsDisplay()
        
    }
    
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
    }
    

    func bindNotificationForUser(){
        if LoginKey.shared.role == "Shop"{
            let shopNotifDisposable = NetworkManager.shared.notificationForShopObs.bind(to: NotifTableView!.rx.items(cellIdentifier: "ShopNotifCell")) { row, aShopNotif, cell in
                if let aCell = cell as? ShopNotifCell {
                    let model = aShopNotif
                    aCell.bodyLabel.text = model.comment
                    aCell.titleLabel.text = (model.first_name ?? "") + " " + (model.last_name ?? "")
                    self.NotifTableView.rowHeight = UIScreen.main.bounds.height/9
                    /* //USE SHOP IMAGE
                     if let imageUrl = URL(string: NetworkManager.shared.websiteRootAddress+SlidesAndPaths.shared.path_profile_image+(model.shop_image ?? "")) {
                     aCell.postImage.setImageFromCache(PlaceHolderName: "logo_shape_in", Scale: 1, ImageURL: imageUrl, ImageName: (model.shop_image ?? ""))
                     }*/
                    // USE Post Image
                    if let imageUrl = URL(string: NetworkManager.shared.websiteRootAddress+SlidesAndPaths.shared.path_profile_image+(model.image ?? "")) {
                        aCell.postImage.setImageFromCache(PlaceHolderName: "logo_shape_in", Scale: 1, ImageURL: imageUrl, ImageName: (model.image ?? ""))
                    }
                }
            }
            shopNotifDisposable.disposed(by: myDisposeBag)
            disposeList.append(shopNotifDisposable)
            
            let shopNotifSelectedDisp = NotifTableView!.rx.modelSelected(NotificationForShop.self)
                .subscribe(onNext: { [unowned self] selectedNotiForShop in
                    print("Notification : Pushing Post with : ", selectedNotiForShop )
                    //self.coordinator!.pushShop(Shop: aShop)
                    
                    if selectedNotiForShop.post_id == nil {
                        self.alert(Message: "اطلاعات این پست هنوز کامل نیست")
                    }else{
                        self.coordinator!.PushAPost(PostID : selectedNotiForShop.post_id!, OwnerUserID: selectedNotiForShop.user_id!)
                    }
                })
            shopNotifSelectedDisp.disposed(by: myDisposeBag)
            disposeList.append(shopNotifSelectedDisp)

        }else{
            let userNotifDisposable = NetworkManager.shared.notificationForUserObs.bind(to: NotifTableView!.rx.items(cellIdentifier: "ShopNotifCell")) { row, aShopNotif, cell in
                if let aCell = cell as? ShopNotifCell {
                    let model = aShopNotif
                    aCell.bodyLabel.text = "پست جدید گذاشته شد"
                    aCell.titleLabel.text = model.shop_name
                    self.NotifTableView.rowHeight = UIScreen.main.bounds.height/9
                    if let imageUrl = URL(string: NetworkManager.shared.websiteRootAddress+SlidesAndPaths.shared.path_post_image+(model.post_image ?? "")) {
                        aCell.postImage.setImageFromCache(PlaceHolderName: "logo_shape_in", Scale: 1, ImageURL: imageUrl, ImageName: (model.post_image ?? ""))
                    }
                    
                }
                
            }
            userNotifDisposable.disposed(by: myDisposeBag)
            disposeList.append(userNotifDisposable)
            
            let userSelectedDisposable = NotifTableView!.rx.modelSelected(NotificationForUser.self)
                .subscribe(onNext: { [unowned self] selectedNotiForUser in
                    //print("Pushing Post with : ", selectedNotiForUser.post_id )
                    //self.coordinator!.pushShop(Shop: aShop)
                    if selectedNotiForUser.post_id == nil {
                        self.alert(Message: "اطلاعات این پست هنوز کامل نیست")
                    }else{
                        self.coordinator!.PushAPost(PostID : selectedNotiForUser.post_id!, OwnerUserID: selectedNotiForUser.user_id!)
                    }
                })
            userSelectedDisposable.disposed(by: myDisposeBag)
            disposeList.append(userSelectedDisposable)
        }
        
        
        
    }
    
    func bindGeneralNotification(){
        let generalDisposable = NetworkManager.shared.generalNotifObs.bind(to: NotifTableView!.rx.items(cellIdentifier: "ShopNotifCell")) { row, aShopNotif, cell in
            if let aCell = cell as? ShopNotifCell {
                let model = aShopNotif
                aCell.bodyLabel.text = model.body
                aCell.titleLabel.text = model.title
                self.NotifTableView.rowHeight = UIScreen.main.bounds.height/9
                if model.image != nil && (model.image?.count)! > 0 {
                    if let imageUrl = URL(string: NetworkManager.shared.websiteRootAddress+SlidesAndPaths.shared.path_profile_image+(model.image ?? "")) {
                        aCell.postImage.setImageFromCache(PlaceHolderName: "logo_shape_in", Scale: 1, ImageURL: imageUrl, ImageName: (model.image ?? ""))
                    }
                }
            }
            }
        generalDisposable.disposed(by: myDisposeBag)
        disposeList.append(generalDisposable)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        bindNotificationForUser()
        
    }
    @IBAction func menuClicked(_ sender: Any) {
        //print("self.coordinator : ",self.coordinator ?? "was Nil in GetRichViewController")
        self.coordinator!.openButtomMenu()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //print("View DID Disapear!")
    }
    
}
