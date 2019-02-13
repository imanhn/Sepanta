//
//  ViewController.swift
//  Sepanta
//
//  Created by Iman on 11/11/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController,Storyboarded {
    @IBOutlet var PageView: UIView!
    @IBOutlet weak var LoginPanelView: RightTabbedView!
    @IBOutlet weak var SignupButton: TabbedButton!
    @IBOutlet weak var EnterButton: UIButton!
    @IBOutlet weak var MobileTextField: UnderLinedTextField!
    weak var coordinator: LoginCoordinator?
    
    @IBAction func MobileTypeEnded(_ sender: Any) {
        (sender as AnyObject).resignFirstResponder()
    }
    @IBAction func mobileNoTypeDone(_ sender: Any) {
        (sender as AnyObject).resignFirstResponder()
    }
    @IBAction func SendClicked(_ sender: Any) {
        // Jump to MainView
        /*
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : MainViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        self.present(vc, animated: false, completion: nil)
        return
        */
        if !(MobileTextField.text!.isEmpty)  {
            // REQUEST SENDING SMS and GET the CODE
            //
            //presentSMSConfirmViewController()
            coordinator?.gotoSMSVerification(Set : MobileTextField.text!)
        }
        else{
            let alert = UIAlertController(title: "توجه", message: "لطفاْ شماره همراه خود را وارد کنید", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "بلی", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            self.present(alert, animated: true, completion: nil)        }
    }
    
    func setMobileNumber(_ astring : String){
        guard self.MobileTextField != nil else {
            print("LoginViewController is nil. Not loaded yet!")
            return
        }
        self.MobileTextField.insertText(astring)
    }
    /*
    func presentSMSConfirmViewController() {
        self.coordinator?.SMSVerification()
        /*
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : SMSConfirmViewController = mainStoryboard.instantiateViewController(withIdentifier: "SMSConfirmViewController") as! SMSConfirmViewController
        print(" Entered : ",self.MobileTextField.text!)
        self.present(vc, animated: false, completion: nil)
        vc.setMobileNumber(self.MobileTextField.text!)
        */
    }
    */

    override func viewDidLoad() {
        super.viewDidLoad()
       self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        

        // Do any additional setup after loading the view, tßypically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

