//
//  SMSConfirmViewController.swift
//  Sepanta
//
//  Created by Iman on 11/13/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Alamofire

class SMSConfirmViewController: UIViewControllerWithKeyboardNotificationWithErrorBar, Storyboarded {
    weak var coordinator: HomeCoordinator?
    @IBOutlet weak var MobileTextField: UnderLinedTextField!
    @IBOutlet weak var SMSTextField: UnderLinedTextField!
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var submitButton: SubmitButtonOnRedBar!
    var countdownTimer: Timer!
    var disposeList = [Disposable]()
    var totalTime = 60
    var mobileNumber: String?
    var myDisposeBag = DisposeBag()

    func initUI() {
        MobileTextField.isEnabled = false
        if mobileNumber != nil {
            setMobileNumber(mobileNumber!)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        initUI()
        doSubscribtions()
    }

    @objc override func ReloadViewController(_ sender: Any) {
        super.ReloadViewController(sender)
        submitTapped(sender)
    }

    @IBAction func submitTapped(_ sender: Any) {
        self.view.endEditing(true)
        stopTimer()
        let aParameter = ["userId": "\(LoginKey.shared.userID)",
                            "sms_verification_code": "\(self.SMSTextField.text ?? "")",
            "os_version": UIDevice.current.systemVersion,
            "os_mobile": "iOS",
            "push_platform": "abc",
            "push_token": "abc",
            "device_model": UIDevice.current.model
        ]
        NetworkManager.shared.messageObs = BehaviorRelay<String>(value: "")
        NetworkManager.shared.run(API: "check-sms-code", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: false)
        let messageDisp = NetworkManager.shared.messageObs
            .filter({$0.count > 0 })
            .subscribe(onNext: { [unowned self] (aMessage) in
                self.alert(Message: aMessage)
                NetworkManager.shared.messageObs = BehaviorRelay<String>(value: "")
            })
        messageDisp.disposed(by: self.myDisposeBag)
        disposeList.append(messageDisp)

    }

    func setMobileNumber(_ astring: String) {
        guard self.MobileTextField != nil else {
                return
        }
        self.MobileTextField.text = astring.toEnglishNumbers()
        startTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signupClicked(_ sender: Any) {
        stopTimer()
        disposeList.forEach({$0.dispose()})
        self.coordinator!.pushSignup()
    }

    func doSubscribtions() {
        let submitDisp = Observable.combineLatest([MobileTextField.rx.text,
                                  SMSTextField.rx.text
            ])
            .subscribe(onNext: { (combinedTexts) in
                //print("combinedTexts : ",combinedTexts)
                if (combinedTexts[0]?.count == 11 && combinedTexts[1]?.count == 5) {
                    self.submitButton.isEnabled = true
                } else {
                    self.submitButton.isEnabled = false
                }
            })
        submitDisp.disposed(by: self.myDisposeBag)
        disposeList.append(submitDisp)

        let loginSucceedDisp = NetworkManager.shared.loginSucceed
            .filter({$0})
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self] _ in
                print("Pushing Home Page ")
                NetworkManager.shared.loginSucceed.accept(false)
                self.gotoHomePage()
            })
        loginSucceedDisp.disposed(by: self.myDisposeBag)
        disposeList.append(loginSucceedDisp)

    }

    func gotoHomePage() {
        stopTimer()
        disposeList.forEach({$0.dispose()})
        self.coordinator!.pushHomePage()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

}

// TIMER
extension SMSConfirmViewController {

    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    func stopTimer() {
        if (countdownTimer) != nil {
            countdownTimer.invalidate()
        } else {
            print("Timer is already stoped")
        }
        countdownTimer = nil
    }
    @objc func updateTime() {
        print("Timer is Counting down!")
        TimerLabel.text = "\(timeFormatted(totalTime))"

        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }

    func endTimer() {
        print("************* ENDED TIMER ****************")
        countdownTimer.invalidate()
        //alert(Message: "وقت شما تمام شد لطفا مجددا تلاش کنید")
        disposeList.forEach({$0.dispose()})
        self.coordinator!.popOneLevel()
    }

    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
