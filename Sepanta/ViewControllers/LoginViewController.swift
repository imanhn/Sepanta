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

class LoginViewController: UIViewControllerWithCoordinator,Storyboarded {
    var myDisposeBag  = DisposeBag()
    @IBOutlet var PageView: UIView!
    @IBOutlet weak var LoginPanelView: RightTabbedView!
    @IBOutlet weak var SignupButton: TabbedButton!
    @IBOutlet weak var EnterButton: UIButton!
    @IBOutlet weak var MobileTextField: UnderLinedTextField!
    
    @IBAction func MobileTypeEnded(_ sender: Any) {
        (sender as AnyObject).resignFirstResponder()
    }
    @IBAction func mobileNoTypeDone(_ sender: Any) {
        (sender as AnyObject).resignFirstResponder()
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        guard let acoordinator = coordinator as? LoginCoordinator else {
            return
        }
        acoordinator.gotoSignup()
    }
    
    @IBAction func SendClicked(_ sender: Any) {
        if !(MobileTextField.text!.isEmpty)  {
            guard let acoordinator = coordinator as? LoginCoordinator else {
                print("Wrong Coordinator for SendClick in LoginViewController")
                return
            }
            LoginKey.shared.getUserID(MobileTextField.text!)
            LoginKey.shared.userIDObs
                //.debug()
                .subscribe(onNext: { [weak self] (innerUserIDObs) in
                    LoginKey.shared.userID = innerUserIDObs
                    Spinner.stop()
                    LoginKey.shared.userIDObs = BehaviorRelay<String>(value: String())
                    acoordinator.gotoSMSVerification(Set : (self?.MobileTextField.text)!)
                    }, onError: { _ in
                        Spinner.stop()
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
        self.MobileTextField.insertText(astring)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
       self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

