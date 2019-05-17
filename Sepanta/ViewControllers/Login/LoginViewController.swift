//
//  ViewController.swift
//  Sepanta
//
//  Created by Iman on 11/11/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import UIKit
import Alamofire
import RxAlamofire
import RxSwift
import RxCocoa

class LoginViewController: UIViewControllerWithKeyboardNotificationWithErrorBar,Storyboarded {
    var myDisposeBag  = DisposeBag()
    var disposeList = [Disposable]()
    weak var coordinator : HomeCoordinator?
    @IBOutlet var PageView: UIView!
    @IBOutlet weak var LoginPanelView: RightTabbedView!
    @IBOutlet weak var SignupButton: TabbedButton!
    @IBOutlet weak var EnterButton: UIButton!
    @IBOutlet weak var MobileTextField: UnderLinedTextField!
    @IBOutlet weak var submitButton: SubmitButtonOnRedBar!
    
    @IBAction func MobileTypeEnded(_ sender: Any) {
        _ = (sender as AnyObject).resignFirstResponder()
    }
    @IBAction func mobileNoTypeDone(_ sender: Any) {
        _ = (sender as AnyObject).resignFirstResponder()
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        if coordinator == nil {
            
        }else{
            coordinator!.pushSignup()
        }
    }
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
        SendClicked(sender)
    }
    
    @IBAction func SendClicked(_ sender: Any) {
        self.view.endEditing(true)

        print("no : ",self.MobileTextField.text!)
        print("Converted : ",(self.MobileTextField.text ?? "").toEnglishNumbers())
        let aMobileNo = (self.MobileTextField.text ?? "").toEnglishNumbers()
        let aParameter = ["cellphone":"\(aMobileNo)"]
        NetworkManager.shared.run(API: "login", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: false)
    }
    
    func setMobileNumber(_ astring : String){
        guard self.MobileTextField != nil else {
            print("LoginViewController is nil. Not loaded yet!")
            return
        }
        //self.MobileTextField.insertText(astring.toEnglishNumbers())
        self.MobileTextField.text =  astring.toEnglishNumbers()
    }

    func doSubscribtions(){
        print("**** Subscribing **** ")
        let submitDisp = MobileTextField.rx.text
            .subscribe(onNext: { [unowned self] (atext) in
                if atext?.count == 11 {
                    self.submitButton.isEnabled = true
                }else{
                    self.submitButton.isEnabled = false
                }
                
            })
        submitDisp.disposed(by: self.myDisposeBag)
        disposeList.append(submitDisp)
        
        let smsDisp = NetworkManager.shared.SMSConfirmed
            .filter({$0})
            //.observeOn(MainScheduler.a2syncInstance)
            .subscribe(onNext: { [unowned self] _ in
                print("Pushing SMSVC")
                NetworkManager.shared.SMSConfirmed.accept(false)
                self.pushSMSConfirm()
            })
        smsDisp.disposed(by: self.myDisposeBag)
        disposeList.append(smsDisp)

        let messageDisp = NetworkManager.shared.messageObs
            .filter({$0.count > 0 })
            .subscribe(onNext: { [unowned self] (aMessage) in
                self.alert(Message: aMessage)
                NetworkManager.shared.messageObs = BehaviorRelay<String>(value: "")
            })
        messageDisp.disposed(by: self.myDisposeBag)
        disposeList.append(messageDisp)
    }
    
    func pushSMSConfirm(){
        disposeList.forEach({$0.dispose()})
        let toEnglishMobileNo =  (self.MobileTextField.text ?? "").toEnglishNumbers()
        self.coordinator!.pushSMSVerification(Set: toEnglishMobileNo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        self.submitButton.isEnabled = false
        doSubscribtions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }


}

