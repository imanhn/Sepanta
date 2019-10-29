//
//  GetRichViewController.swift
//  Sepanta
//
//  Created by Iman on 12/14/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class GetRichViewController: UIViewControllerWithKeyboardNotificationWithErrorBar, UITextFieldDelegate, Storyboarded {
   var myDisposeBag = DisposeBag()
    var profileInfo: ProfileInfo?
    var cardNo: String?
    var loadLastCard : Bool!
    @IBOutlet weak var scrollView: NoDelayScrollView!
    var getRichUI: GetRichUI?
    weak var coordinator: HomeCoordinator?

    @objc override func willPop() {
        if getRichUI != nil {
            getRichUI!.disposeList.forEach({$0.dispose()})
        }
        getRichUI = nil
    }

    @IBAction func backTapped(_ sender: Any) {
        self.coordinator!.popOneLevel()
    }

    @IBAction func homeTapped(_ sender: Any) {
        self.coordinator!.popHome()
    }

    @objc func cardRequestTapped(_ sender: Any) {
        getRichUI!.showCardRequest(self)
    }

    @objc func resellerRequestTapped(_ sender: Any) {
        getRichUI!.showResellerRequest(self)
    }

    @objc override func ReloadViewController(_ sender: Any) {
        super.ReloadViewController(sender)
        if getRichUI != nil {
            getRichUI!.showResellerRequest(self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //scrollView.canCancelContentTouches = false
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        getRichUI = GetRichUI()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))

        // This one is used by ProfileUI to Edit the last Card which
        // is the card that is issued today.
        if loadLastCard == true {
            getRichUI!.showCardRequest(self)
        }
        if cardNo != nil {
            getRichUI!.showCardRequest(self)
        } else {
            getRichUI!.showResellerRequest(self)
        }
        //resellerRequestTapped(nil)

    }
    @IBAction func menuClicked(_ sender: Any) {
        print("self.coordinator : ", self.coordinator ?? "was Nil in GetRichViewController")
        self.coordinator!.openButtomMenu()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //print("View DID Disapear!")
        //self.getRichUI = nil
    }

    func showPopup(_ controller: UIViewController, sourceView: UIView) {
        //print("Showing POPUP : ",sourceView)
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
}
