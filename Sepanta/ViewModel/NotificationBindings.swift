//
//  NotificationBindings.swift
//  Sepanta
//
//  Created by Iman on 5/7/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension NotificationsViewController {
    func bindNotificationForUser() {
        if LoginKey.shared.role.uppercased() == "Shop".uppercased() {
            let shopNotifDisposable = NetworkManager.shared.notificationForShopObs.bind(to: NotifTableView!.rx.items(cellIdentifier: "ShopNotifCell")) { _, aShopNotif, cell in
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
                    } else {
                        NetworkManager.shared.postDetailObs = BehaviorRelay<Post>(value: Post())
                        self.coordinator!.PushAPost(PostID: selectedNotiForShop.post_id!, OwnerUserID: selectedNotiForShop.user_id ?? 0)
                    }
                })
            shopNotifSelectedDisp.disposed(by: myDisposeBag)
            disposeList.append(shopNotifSelectedDisp)

        } else {
            let userNotifDisposable = clubsNotificationObs.bind(to: NotifTableView!.rx.items(cellIdentifier: "ShopNotifCell")) { _, aShopNotif, cell in
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
                    } else {
                        NetworkManager.shared.postDetailObs = BehaviorRelay<Post>(value: Post())
                        self.coordinator!.PushAPost(PostID: selectedNotiForUser.post_id!, OwnerUserID: selectedNotiForUser.user_id!)
                    }
                })
            userSelectedDisposable.disposed(by: myDisposeBag)
            disposeList.append(userSelectedDisposable)
        }

    }
    func bindGeneralNotification() {
        let generalDisposable = generalNotificationObs.bind(to: NotifTableView!.rx.items(cellIdentifier: "ShopNotifCell")) { _, aShopNotif, cell in
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
        let generalSelectDisp = NotifTableView!.rx.modelSelected(GeneralNotification.self)
            .subscribe(onNext: { [unowned self] aNotif in
                self.showNotificationModel(aNotif)
            })
        generalSelectDisp.disposed(by: myDisposeBag)
        disposeList.append(generalSelectDisp)
    }

    func showNotificationModel(_ anotif: GeneralNotification) {
        let offsetY = self.view.frame.height*0.1
        let offsetX = self.view.frame.width*0.1
        let aTermView = TermsView(frame: CGRect(x: offsetX, y: offsetY, width: self.view.frame.width-(2*offsetX), height: self.view.frame.height-(2*offsetY)))
        aTermView.textView.text = anotif.body
        aTermView.titleLabel.text = anotif.title ?? "اعلان سپنتایی"
        aTermView.okButton.setTitle("بستن", for: .normal)
        self.view.addSubview(aTermView)
    }

    func getAndSubscribeToNotifications() {
       let notifDisp = getNotifications(Page: 1)
            .results()
            .subscribe(onNext: { [unowned self] notifs in
                self.generalNotificationObs.accept(notifs.notifications_manager ?? [GeneralNotification]())
                self.clubsNotificationObs.accept(notifs.notifications_user?.data ?? [NotificationForUser]())
                }, onError: {_ in })
        notifDisp.disposed(by: myDisposeBag)
        disposeList.append(notifDisp)

    }
}
