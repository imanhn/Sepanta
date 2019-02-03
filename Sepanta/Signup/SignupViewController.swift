//
//  SignupViewController.swift
//  Sepanta
//
//  Created by Iman on 11/13/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation

import UIKit


struct genders {
    var type : String = "جنسیت"
}

struct provinces {
    var type : String = "انتخاب استان"
}

struct cities {
    var type : String = "انتخاب شهر"
}

class SignupViewController: UIViewController  {

    var genderModel = genders() {
        didSet {
            updateGender()
            self.view.setNeedsLayout()
        }
    }
    var provinceModel = provinces() {
        didSet {
            updateProvince()
            self.view.setNeedsLayout()
        }
    }
    var cityModel = cities() {
        didSet {
            updateCity()
            self.view.setNeedsLayout()
        }
    }
    var TermsAgreed = false;
    
    @IBOutlet weak var mobileNoText: UnderLinedTextField!
    @IBOutlet weak var usernameText: UnderLinedTextField!
    @IBOutlet weak var genderTextField: UnderLinedSelectableTextField!
    @IBOutlet weak var enterButton: TabbedButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var checkTerms: UIButton!
    @IBOutlet weak var selectProvince: UnderLinedSelectableTextField!
    @IBOutlet weak var selectCity: UnderLinedSelectableTextField!
    @IBOutlet weak var termsLabel: UILabel!
    
    @IBAction func termsClicked(_ sender: Any) {
        TermsAgreed = !TermsAgreed;
        if TermsAgreed {
            checkTerms.setImage(UIImage(named: "icon_tik_dark"), for: UIControlState.normal)
            termsLabel.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        } else {
            checkTerms.setImage(UIImage(named: "icon_tik_gray"), for: UIControlState.normal)
            termsLabel.textColor = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1)
        }
    }
    func updateGender(){
        self.genderTextField.text = genderModel.type
    }
    func updateProvince(){
        self.selectProvince.text = provinceModel.type
    }
    func updateCity(){
        self.selectCity.text = cityModel.type
    }
    func getAllProvinceList() -> Array<String> {
        return ["آذربایجان","تهران","البرز","اصفهان","کرمان"]
    }
    func getGendersList() -> Array<String> {
        return ["زن","مرد"]
    }
    func getCitiesList(_ aProvince : String) -> Array<String> {
        return ["رودهن","دماوند","شهریار"]
    }
    @IBAction func provinceTextTouchDown(_ sender: Any) {
        let controller = ArrayChoiceTableViewController(getAllProvinceList()) {
            (type) in self.provinceModel.type = type
        }
        controller.preferredContentSize = CGSize(width: (sender as! UITextField).bounds.width, height: 300)
        showPopup(controller, sourceView: sender as! UIView)
        
    }
    @IBAction func cityTextTouchDown(_ sender: Any) {
        let aprovince = provinceModel.type
        let controller = ArrayChoiceTableViewController(getCitiesList(aprovince)) {
            (type) in self.cityModel.type = type
        }
        controller.preferredContentSize = CGSize(width: (sender as! UITextField).bounds.width, height: 200)
        showPopup(controller, sourceView: sender as! UIView)
    }
    
    @IBAction func GenderTextTouchDown(_ sender: Any) {
       
        let controller = ArrayChoiceTableViewController(getGendersList()) {
            (type) in self.genderModel.type = type
        }
        controller.preferredContentSize = CGSize(width: (sender as! UITextField).bounds.width, height: 150)
        showPopup(controller, sourceView: sender as! UIView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
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
        if !(TermsAgreed) {
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


