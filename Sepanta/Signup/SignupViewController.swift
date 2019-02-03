//
//  SignupViewController.swift
//  Sepanta
//
//  Created by Iman on 11/13/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation

import UIKit


enum Gender : String {
    
    case male = "مرد",female = "زن"
    static var allLabels = ["زن","مرد"]
}

struct genders {
    var type : String = "جنسیت"//Gender.allLabels.first!
}

class SignupViewController: UIViewController  {

    var model = genders() {
        didSet {
            self.view.setNeedsLayout()
        }
    }
    var TermsAgreed = false;
    
    @IBOutlet weak var mobileNoText: UnderLinedTextField!
    @IBOutlet weak var usernameText: UnderLinedTextField!
    @IBOutlet weak var genderTextField: UnderLinedTextField!
    @IBOutlet weak var enterButton: TabbedButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var checkTerms: UIButton!
    @IBOutlet weak var selectProvince: UnderLinedTextField!
    @IBOutlet weak var selectCity: UnderLinedTextField!
    
    @IBAction func termsClicked(_ sender: Any) {
        TermsAgreed = !TermsAgreed;
        if TermsAgreed {
            checkTerms.setImage(UIImage(named: "icon_tik_dark"), for: UIControlState.normal)
        } else {
            checkTerms.setImage(UIImage(named: "icon_tik_gray"), for: UIControlState.normal)
        }
    }
    
    @IBAction func GenderTextTouchDown(_ sender: Any) {
       
        let controller = ArrayChoiceTableViewController(Gender.allLabels) {
            (type) in self.model.type = type
        }
        controller.preferredContentSize = CGSize(width: (sender as! UITextField).bounds.width, height: 150)
        showPopup(controller, sourceView: sender as! UIView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.genderTextField.text = model.type
        //insertText(String(describing: model.type))
    }
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkUsernameAvailability() -> Array<Any> {
        
        return [true,""]
    }
    
    func validateForm() -> Array<Any>{
        
        if (mobileNoText.text?.isEmpty)! {
            return [false,"لطفا شماره همراه خود را وارد نمایید"]
        }
        if mobileNoText.text?.count != 11 {
            return [false,"شماره همراه باید ۱۱ رقم باشد"]
        }
        if !(mobileNoText.text?.starts(with: "09"))! {
            return [false,"شماره همراه صحیح با ۰۹ شروع می شود"]
        }
        if (usernameText.text?.isEmpty)! {
            return [false,"لطفا نام کاربری را مشخص فرمایید"]
        }
        if (genderTextField.text?.isEmpty)!{
            return [false,"لطفا جنسیت را مشخص فرمایید"]
        }
        if (selectProvince.text?.isEmpty)! {
            return [false,"لطفا استان خود را انتخاب بفرمایید"]
        }
        if (selectCity.text?.isEmpty)!{
            return [false,"لطفا شهر خود را انتخاب بفرمایید"]
        }
        if !TermsAgreed {
            return [false,"لطفا با قوانین و مقررات موافقت بفرمایید"]
        }
        return checkUsernameAvailability()
        
    }
    @IBAction func SubmitSignupFormClicked(_ sender: Any) {
        var validationResult = validateForm();
        if validationResult[0] as! Bool == false
        {
            let alert = UIAlertController(title: "توجه", message: (validationResult[1] as! String), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "بلی", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            self.present(alert, animated: true, completion: nil)
        }
    }
}


