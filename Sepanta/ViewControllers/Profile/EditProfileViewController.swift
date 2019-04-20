//
//  EditProfileViewController.swift
//  Sepanta
//
//  Created by Iman on 12/19/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RxAlamofire
import RxSwift
class EditProfileViewController : UIViewControllerWithKeyboardNotificationWithErrorBar,Storyboarded,VCWithCityAndState {
    
    @IBOutlet weak var formView: UIView!
    @IBOutlet var topView: UIView!
    var selectProvince: UITextField?
    var selectCity: UITextField?
    weak var genderTextField: UITextField?
    weak var coordinator : HomeCoordinator?
    var editProfileUI : EditProfileUI! = EditProfileUI()
    var myDisposeBag = DisposeBag()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func selectProfileImage(_ sender: Any) {
        
    }
    
    @IBAction func backTapped(_ sender: Any) {
        editProfileUI = nil
        self.coordinator?.popOneLevel()
    }
    
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
        editProfileUI.sendEditedData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        editProfileUI.showForm(self)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
}
