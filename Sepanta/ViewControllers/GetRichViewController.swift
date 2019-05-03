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

class GetRichViewController : UIViewControllerWithKeyboardNotificationWithErrorBar,UITextFieldDelegate,Storyboarded{
   var myDisposeBag = DisposeBag()
    var profileInfo : ProfileInfo?
    @IBOutlet weak var scrollView: UIScrollView!
    var getRichUI : GetRichUI?
    
    weak var coordinator : HomeCoordinator?

    @objc func cardRequestTapped(_ sender : Any) {
        getRichUI!.showCardRequest(self)
    }
    @IBAction func homeTapped(_ sender: Any) {
        if getRichUI != nil {
            getRichUI!.disposeList.forEach({$0.dispose()})
        }
        getRichUI = nil
        self.coordinator!.popHome()
    }
    @objc func resellerRequestTapped(_ sender : Any) {
        getRichUI!.showResellerRequest(self)
    }
    
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
        if getRichUI != nil {
            getRichUI!.showResellerRequest(self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        getRichUI = GetRichUI()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        getRichUI!.showResellerRequest(self)
        //resellerRequestTapped(nil)
        
    }
    @IBAction func menuClicked(_ sender: Any) {
        print("self.coordinator : ",self.coordinator ?? "was Nil in GetRichViewController")
        self.coordinator!.openButtomMenu()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //print("View DID Disapear!")
        self.getRichUI = nil
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
