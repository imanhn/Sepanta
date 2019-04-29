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
    var shopDisposable : Disposable!
    var generalDisposable : Disposable!
    var shopSelectedDisposable : Disposable!
    var generalSelectedDisposable : Disposable!
    
    weak var coordinator : HomeCoordinator?
    
    @IBAction func backTapped(_ sender: Any) {
        self.coordinator!.popOneLevel()
    }
    
    @IBAction func homeTapped(_ sender: Any) {
        self.coordinator!.popHome()
    }

    @IBAction func shopNotifTapped(_ sender: Any) {
        //generalSelectedDisposable.dispose()
        generalDisposable.dispose()
        bindShopNotification()
        self.tabbedView.tabJust = TabViewJustification.Right
        self.tabbedView.setNeedsDisplay()
    }
    @IBAction func generalNotifTapped(_ sender: Any) {
        shopDisposable.dispose()
        shopSelectedDisposable.dispose()
        bindGeneralNotification()
        self.tabbedView.tabJust = TabViewJustification.Left
        self.tabbedView.setNeedsDisplay()
        
    }
    
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
    }
    

    func bindShopNotification(){
        shopDisposable = NetworkManager.shared.shopNotifObs.bind(to: NotifTableView!.rx.items(cellIdentifier: "ShopNotifCell")) { row, aShopNotif, cell in
            if let aCell = cell as? ShopNotifCell {
                let model = aShopNotif
                aCell.bodyLabel.text = "پست جدید گذاشته شد"
                aCell.titleLabel.text = model.shop_name
                /* //USE SHOP IMAGE
                 if let imageUrl = URL(string: NetworkManager.shared.websiteRootAddress+SlidesAndPaths.shared.path_profile_image+(model.shop_image ?? "")) {
                    aCell.postImage.setImageFromCache(PlaceHolderName: "logo_shape_in", Scale: 1, ImageURL: imageUrl, ImageName: (model.shop_image ?? ""))
                 }*/
                // USE Post Image
                if let imageUrl = URL(string: NetworkManager.shared.websiteRootAddress+SlidesAndPaths.shared.path_post_image+(model.post_image ?? "")) {
                    aCell.postImage.setImageFromCache(PlaceHolderName: "logo_shape_in", Scale: 1, ImageURL: imageUrl, ImageName: (model.post_image ?? ""))
                }

            }
        }
        shopDisposable.disposed(by: myDisposeBag)
        
        shopSelectedDisposable = NotifTableView!.rx.modelSelected(ShopNotification.self)
            .subscribe(onNext: { [unowned self] selectedShop in
                //print("Pushing Post with : ", selectedShop.post_id )
                //self.coordinator!.pushShop(Shop: aShop)
                if selectedShop.post_id == nil {
                    self.alert(Message: "اطلاعات این پست هنوز کامل نیست")
                }else{
                    self.coordinator!.PushAPost(PostID : selectedShop.post_id!)
                }
            })
        shopSelectedDisposable.disposed(by: myDisposeBag)
        
    }
    
    func bindGeneralNotification(){
        generalDisposable = NetworkManager.shared.generalNotifObs.bind(to: NotifTableView!.rx.items(cellIdentifier: "ShopNotifCell")) { row, aShopNotif, cell in
            if let aCell = cell as? ShopNotifCell {
                let model = aShopNotif
                aCell.bodyLabel.text = model.body
                aCell.titleLabel.text = model.title
                if model.image != nil && (model.image?.count)! > 0 {
                    if let imageUrl = URL(string: NetworkManager.shared.websiteRootAddress+SlidesAndPaths.shared.path_profile_image+(model.image ?? "")) {
                        aCell.postImage.setImageFromCache(PlaceHolderName: "logo_shape_in", Scale: 1, ImageURL: imageUrl, ImageName: (model.image ?? ""))
                    }
                }
            }
            }
        generalDisposable.disposed(by: myDisposeBag)
        /*
        generalSelectedDisposable = NotifTableView!.rx.modelSelected(GeneralNotification.self)
            .subscribe(onNext: { [unowned self] selectedShop in
                let aShop = Shop(shop_id: 0, user_id: selectedShop.user_id, shop_name: selectedShop.shop_name, shop_off: 0, lat: 0, long: 0, image: selectedShop.shop_image, rate: "", follower_count: 0, created_at: selectedShop.created_at)
                print("Pushing Shop Post with : ", aShop)
                self.coordinator!.pushShop(Shop: aShop)
            })
        generalSelectedDisposable.disposed(by: myDisposeBag)
        */
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        bindShopNotification()
        
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
