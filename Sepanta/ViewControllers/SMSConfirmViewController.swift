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

class SMSConfirmViewController: UIViewControllerWithCoordinator,Storyboarded {
    
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
        (sender as AnyObject).resignFirstResponder()
    }
    
    @IBAction func SMSCodeTypeDone(_ sender: Any) {
        (sender as AnyObject).resignFirstResponder()
    }
    
    @IBAction func MobileTextEditEnd(_ sender: Any) {
        (sender as AnyObject).resignFirstResponder()
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
        let alert = UIAlertController(title: "توجه", message: "وقت شما تمام شد لطفا مجددا تلاش کنید", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "بلی", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                self.backToLoginViewController()
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
       
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
        startTimer()
        //self.MobileTextField.text = astring
    }
    
    func backToLoginViewController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : LoginViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        print(" Entered : ",self.MobileTextField.text!)
        self.present(vc, animated: false, completion: nil)
         vc.setMobileNumber(self.MobileTextField.text!)
    }
    func gotoHomeViewController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : HomeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.present(vc, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        guard let acoordinator = coordinator as? LoginCoordinator else {
            return
        }
        acoordinator.gotoSignup()
    }
    
    @IBAction func ConfirmCodeClicked(_ sender: Any) {
        print("Confirm Clicked")
        guard SMSTextField.text != nil else {
            print("SMS Field not filled!")
            let alert = UIAlertController(title: "توجه", message: "لطفاْ کد ارسال شده را وارد نمایید", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "بلی", style: .default))
            return
        }
        if (countdownTimer) != nil {
            countdownTimer.invalidate()
        } else {
            print("Timer is already stoped")
        }
        guard let acoordinator = coordinator as? LoginCoordinator else {
            print("Wrong Coordinator for Confirm SMS Code Clicked")
            return
        }
        Spinner.start()
        print("Getting Token")
        LoginKey.shared.getToken(self.SMSTextField.text!)
        LoginKey.shared.tokenObs
            .debug()
            .subscribe(onNext: { (innerTokenObs) in
                print("Token Received")
                var loginDataRegistered = false
                loginDataRegistered = LoginKey.shared.registerTokenAndUserID()
                if loginDataRegistered
                {
                    print("Login Token and UserID Saved....")
                } else {
                    print("Login Token and UserID did not saved..")
                }
                LoginKey.shared.token = innerTokenObs
                Spinner.stop()
                LoginKey.shared.tokenObs = BehaviorRelay<String>(value: String())
                acoordinator.gotoHomePage()
                }, onError: { _ in
                    Spinner.stop()
            }, onCompleted: {
            }, onDisposed: {
            }).disposed(by: myDisposeBag)
    }
    
}

