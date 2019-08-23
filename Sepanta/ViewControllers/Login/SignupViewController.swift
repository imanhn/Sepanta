//
//  SignupViewController.swift
//  Sepanta
//
//  Created by Iman on 11/13/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RxSwift
import RxCocoa

class SignupViewController: UIViewControllerWithKeyboardNotificationWithErrorBar, UITextFieldDelegate, Storyboarded {
    weak var coordinator: HomeCoordinator?
    var disposeList = [Disposable]()
    var userID: String = ""
    var signupUI: SignUPUI!
    var smsVerificationCode: String = ""
    var currentStateCodeObs = BehaviorRelay<String>(value: String())
    var currentCityCodeObs = BehaviorRelay<String>(value: String())
    var myDisposeBag = DisposeBag()
    var TermsAgreed = false

    @IBOutlet weak var submitButton: SubmitButtonOnRedBar!
    @IBOutlet weak var enterButton: TabbedButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signUpFormView: UIView!

    @IBAction func enterTapped(_ sender: Any) {
        //self.coordinator!.popLogin(Set: self.mobileNoText.text ?? "")
    }
    @IBAction func termsClicked(_ sender: Any) {
    }

    @IBAction func gotoLogin(_ sender: Any) {
        self.coordinator!.popLogin()
    }

    func showPopup(_ controller: UIViewController, sourceView: UIView) {
        //print("Showing POPUP : ",sourceView)
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.isEnabled = false
        signupUI = SignUPUI(self)
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func SubmitSignupFormClicked(_ sender: Any) {
        var gender_code = 1 // default to Men
        if self.signupUI.genderText.text == "زن" || self.signupUI.genderText.text?.count == 2 {gender_code = 0}

        let aParameter = [
            "cellphone": "\(self.signupUI.mobileText.text ?? "")",
            "username": "\(self.signupUI.usernameText.text ?? "")",
            "gender": "\(gender_code)",
            "state": "\(self.signupUI.stateCode!)",
            "city_code": "\(self.signupUI.cityCode!)"
        ]
        print("aParameter : \(aParameter)")
        NetworkManager.shared.run(API: "register", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: false)
        let messageDisp = NetworkManager.shared.messageObs
            .filter({$0.count > 0})
            .subscribe(onNext: { aMessage in
                self.alert(Message: aMessage)
                NetworkManager.shared.messageObs = BehaviorRelay<String>(value: "")
            })
        messageDisp.disposed(by: myDisposeBag)
        disposeList.append(messageDisp)

        let useridDisp = LoginKey.shared.userIDObs
            .share(replay: 1, scope: .whileConnected)
            .filter({$0.count > 0})
            .subscribe(onNext: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    self.coordinator!.pushSMSVerification(Set: self.signupUI.mobileText.text ?? "")
                })
            })
        useridDisp.disposed(by: myDisposeBag)
        disposeList.append(useridDisp)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

}
