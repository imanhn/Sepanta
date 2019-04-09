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

class SMSConfirmViewController: UIViewControllerWithKeyboardNotificationWithErrorBar,Storyboarded {
    weak var coordinator : LoginCoordinator?
    @IBOutlet weak var MobileTextField: UnderLinedTextField!
    @IBOutlet weak var SMSTextField: UnderLinedTextField!
    @IBOutlet weak var TimerLabel: UILabel!
    var countdownTimer: Timer!
    var totalTime = 60
    var mobileNumber : String?
    var myDisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
         self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        if mobileNumber != nil {
            setMobileNumber(mobileNumber!)
        }
    }

    @IBAction func MobileNoTypeDoen(_ sender: Any) {
        _ = (sender as AnyObject).resignFirstResponder()
    }
    
    @IBAction func SMSCodeTypeDone(_ sender: Any) {
        _ = (sender as AnyObject).resignFirstResponder()
    }
    
    @IBAction func MobileTextEditEnd(_ sender: Any) {
        _ = (sender as AnyObject).resignFirstResponder()
        startTimer()
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    @objc func updateTime() {
        TimerLabel.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
        alert(Message: "وقت شما تمام شد لطفا مجددا تلاش کنید")
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    func setMobileNumber(_ astring : String){
        guard self.MobileTextField != nil else {
                return
        }
         self.MobileTextField.insertText(astring)
        self.MobileTextField.text = astring.toEnglishNumbers()
        startTimer()
        //self.MobileTextField.text = astring
    }
    
    func backToLoginViewController() {
        self.coordinator?.gotoLogin(Set: self.MobileTextField.text!)
    }
    
    func gotoHomeViewController() {
        self.coordinator!.gotoHomePage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        self.coordinator!.gotoSignup()
    }
    
    @IBAction func ConfirmCodeClicked(_ sender: Any) {
        print("Confirm Clicked : ",SMSTextField.text)
        guard (SMSTextField.text != nil) && (SMSTextField.text != "") else {
            alert(Message: "لطفاْ کد ارسال شده را وارد نمایید")
            return
        }
        SMSTextField.text = SMSTextField.text!.toEnglishNumbers()
        //SMSTextField.insertText(SMSTextField.text!.toEnglishNumbers())
        if (countdownTimer) != nil {
            countdownTimer.invalidate()
        } else {
            print("Timer is already stoped")
        }
        Spinner.start()
        print("Getting Token")
        LoginKey.shared.getToken(self.SMSTextField.text!)
        LoginKey.shared.tokenObs
            .filter({$0.count > 0})
            .debug()
            .subscribe(onNext: { [unowned self] (innerTokenObs) in
                print("Token Received : ",innerTokenObs)
                LoginKey.shared.token = innerTokenObs
                _ = LoginKey.shared.registerTokenAndUserID()
                Spinner.stop()
                LoginKey.shared.tokenObs = BehaviorRelay<String>(value: String())
                self.coordinator!.gotoHomePage()
                }, onError: { _ in
                    Spinner.stop()
            }, onCompleted: {
            }, onDisposed: {
            }).disposed(by: myDisposeBag)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    
}

