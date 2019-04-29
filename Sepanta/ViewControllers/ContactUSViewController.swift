//
//  ContactUSViewController.swift
//  Sepanta
//
//  Created by Iman on 2/9/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//
import UIKit
import RxSwift
import Alamofire

class ContactUSViewController: UIViewControllerWithKeyboardNotificationWithErrorBar,UITextFieldDelegate {
    var myDisposeBag = DisposeBag()
    var contactUSUI : ContactUSUI?
    weak var coordinator : HomeCoordinator?
    @IBOutlet weak var panelView: TabbedViewWithWhitePanel!
    
    @IBAction func backTapped(_ sender: Any) {
        self.coordinator!.popOneLevel()
    }
    
    @IBAction func goHome(_ sender: Any) {
        self.coordinator!.popHome()
    }
    
    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        contactUSUI = ContactUSUI(self)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        contactUSUI!.showContactInfo()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
}
