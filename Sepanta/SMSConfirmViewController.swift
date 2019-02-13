//
//  SMSConfirmViewController.swift
//  Sepanta
//
//  Created by Iman on 11/13/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

class SMSConfirmViewController: UIViewController,Storyboarded {
    
    @IBOutlet weak var MobileTextField: UnderLinedTextField!
    @IBOutlet weak var SMSTextField: UnderLinedTextField!
    @IBOutlet weak var TimerLabel: UILabel!
    var countdownTimer: Timer!
    var totalTime = 10
    var token : String?
    var userID : String?
    var mobileNumber : String?
    weak var coordinator: LoginCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
         self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        if mobileNumber != nil {
            setMobileNumber(mobileNumber!)
        }
    }
    func setUserID(anID : String){
        self.userID = anID
    }

    func setToken(aToken : String){
        self.token = aToken
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
    func gotoMainViewController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : MainViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        self.present(vc, animated: false, completion: nil)
        if token != nil {
            vc.setToken(aToken: token!)
        }
        if userID != nil {
            vc.setUserID(anID: userID!)
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ConfirmCodeClicked(_ sender: Any) {
        guard SMSTextField.text != nil else {
            print("SMS Field not filled!")
            let alert = UIAlertController(title: "توجه", message: "لطفاْ کد ارسال شده را وارد نمایید", preferredStyle: .alert)
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
            return
        }
        if (countdownTimer) != nil {
            countdownTimer.invalidate()
        } else {
            print("Timer is already stoped")
        }
        gotoMainViewController()
    }
    
}

