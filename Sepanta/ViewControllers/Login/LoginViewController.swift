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
    weak var coordinator : LoginCoordinator?
    @IBOutlet var PageView: UIView!
    @IBOutlet weak var LoginPanelView: RightTabbedView!
    @IBOutlet weak var SignupButton: TabbedButton!
    @IBOutlet weak var EnterButton: UIButton!
    @IBOutlet weak var MobileTextField: UnderLinedTextField!
    
    @IBAction func MobileTypeEnded(_ sender: Any) {
        _ = (sender as AnyObject).resignFirstResponder()
    }
    @IBAction func mobileNoTypeDone(_ sender: Any) {
        _ = (sender as AnyObject).resignFirstResponder()
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        if coordinator == nil {
            
        }else{
            coordinator!.gotoSignup()
        }
    }
    @objc override func ReloadViewController(_ sender:Any) {
        super.ReloadViewController(sender)
    }
    @IBAction func SendClicked(_ sender: Any) {
        NetworkManager.shared.status
            .filter({$0 == CallStatus.error})
            .subscribe(onNext: { [unowned self] (innerNetworkCallStatus) in
                Spinner.stop()
                self.alert(Message: "دسترسی به سرور امکان پذیر نیست یا سیستم با مشکل مواجه شده است"+"\n"+NetworkManager.shared.message)
                return 
            }, onError: { _ in
                
            }, onCompleted: {
                
            }, onDisposed: {
                
            }).disposed(by: myDisposeBag)
        
        if !(MobileTextField.text!.isEmpty)  {
            // Convert to English
            //MobileTextField.insertText(MobileTextField.text!.toEnglishNumbers())
            MobileTextField.text = MobileTextField.text!.toEnglishNumbers()
            
            LoginKey.shared.getUserID(MobileTextField.text!)
            LoginKey.shared.userIDObs
                //.debug()
                .subscribe(onNext: { [unowned self] (innerUserIDObs) in
                    LoginKey.shared.userID = innerUserIDObs
                    print("USERID : ",LoginKey.shared.userID)
                    print("inner USERID : ",innerUserIDObs)
                    Spinner.stop()
                    if LoginKey.shared.userID == nil || LoginKey.shared.userID == "" {return}
                    LoginKey.shared.userIDObs = BehaviorRelay<String>(value: String())
                    self.coordinator!.gotoSMSVerification(Set : (self.MobileTextField.text)!)
                    }, onError: { _ in
                        
                }, onCompleted: {
                }, onDisposed: {
                }).disposed(by: myDisposeBag)
        }
        else {
            let alert = UIAlertController(title: "توجه", message: "لطفاْ شماره همراه خود را وارد کنید", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "بلی", style: .default))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func setMobileNumber(_ astring : String){
        guard self.MobileTextField != nil else {
            print("LoginViewController is nil. Not loaded yet!")
            return
        }
        //self.MobileTextField.insertText(astring.toEnglishNumbers())
        self.MobileTextField.text =  astring.toEnglishNumbers()
    }



    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    
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

