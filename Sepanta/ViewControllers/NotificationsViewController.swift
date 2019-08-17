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
import RxCocoa

class ShopNotifCell : UITableViewCell {
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
}

class NotificationsViewController : UIViewControllerWithErrorBar,XIBView,UITableViewDelegate{
    @IBOutlet weak var NotifTableView: UITableView!
    var generalNotificationObs = BehaviorRelay<[GeneralNotification]>(value: [GeneralNotification]())
    var clubsNotificationObs = BehaviorRelay<[NotificationForUser]>(value: [NotificationForUser]())
    var myDisposeBag = DisposeBag()
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tabbedView: TabbedViewWithWhitePanel!
    var disposeList = [Disposable]()
    
    weak var coordinator : HomeCoordinator?

    @objc override func willPop() {
        disposeList.forEach({$0.dispose()})
    }

    @IBAction func backTapped(_ sender: Any) {
        self.coordinator!.popOneLevel()
    }
    
    @IBAction func homeTapped(_ sender: Any) {        
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        getAndSubscribeToNotifications()
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
