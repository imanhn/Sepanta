//
//  PaymentViewController.swift
//  Sepanta
//
//  Created by Iman on 8/4/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RxCocoa
import RxSwift

class PaymentViewController : UIViewControllerWithKeyboardNotificationWithErrorBar, Storyboarded {
    var myDisposeBag = DisposeBag()
    var disposeList = [Disposable]()
    weak var coordinator: HomeCoordinator?
    
    @objc override func willPop() {
        disposeList.forEach({$0.dispose()})
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.coordinator!.popOneLevel()
    }
    
    @IBAction func homeTapped(_ sender: Any) {
        self.coordinator!.popHome()
    }
    @objc override func ReloadViewController(_ sender: Any) {
        super.ReloadViewController(sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
    }
}
