//
//  SignupViewController.swift
//  Sepanta
//
//  Created by Iman on 11/13/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

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
    var provincesCache : [String] = []
    var provinceDict : Dictionary = ["TEST":"TEST"];
    var cityDict : Dictionary = ["TEST":"TEST"];
    var cityCache : [String] = []
    var currentStateCode : String = ""
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
    func getAllProvince() {
        var provinceList : [String]=[];
        /*let parameters = [
         "username": "foo",
         "password": "123456"
         ]*/
        let urlAddress = NSURL(string: "http://www.favecard.ir/api/takamad/get-state-and-city")
        let aMethod : HTTPMethod = HTTPMethod.get
        print("Calling API")
        Alamofire.request(urlAddress! as URL, method: aMethod, parameters: nil, encoding: JSONEncoding.default,  headers: nil).responseJSON { (response:DataResponse<Any>) in
            print("Processing Response....")
            switch(response.result) {
            case .success(_):
                
                if response.result.value != nil
                {
                    let jsonResult = JSON(response.result.value!)
                    provinceList = Array<String>(repeating: "", count: jsonResult["states"].count)
                    for aProv in jsonResult["states"]
                    {
                        print(aProv.0," ",aProv.1)
                        let provName : String = aProv.0
                        let idx = Int(aProv.1.rawString()!)!
                        //self.provinceDict.setValue(aProv.1.rawString(), forKey: provName)
                        self.provinceDict[provName] = aProv.1.rawString()!
                        //setValue(provName, forKey: aProv.1.rawString()!)
                        provinceList[idx] = provName
                        
                    }
                    
                    print("Fetched : ",provinceList.count," record")
                    //print("Provinces : ",provinceList)
                    print("Successful")
                    self.provincesCache = provinceList
                }
                break
                
            case .failure(_):
                if response.result.error != nil
                {
                    print("Not Successful")
                    print(response.result.error!)
                }
                break
            }
            
        }
    }
    
    func getAllProvinceList() -> Array<String> {
        if provincesCache.count == 0 {
            print("Province list not ready yet")
            getAllProvince()
            return ["مجدد تلاش کنید"];
        }else{
            return provincesCache
        }
    }
    func getAllCity(_ stateCode : String) {
        var cityList : [String]=[];
        let parameters = [
         "state%20code": stateCode
         ]
        let urlAddress = NSURL(string: "http://www.favecard.ir/api/takamad/get-state-and-city")
        let aMethod : HTTPMethod = HTTPMethod.post
        print("Calling City API")
        Alamofire.request(urlAddress! as URL, method: aMethod, parameters: parameters, encoding: JSONEncoding.default,  headers: parameters).responseJSON { (response:DataResponse<Any>) in
            print("Processing City Response....")
            switch(response.result) {
            case .success(_):
                
                if response.result.value != nil
                {
                    let jsonResult = JSON(response.result.value!)
                    cityList = Array<String>(repeating: "", count: jsonResult["cities"].count)
                    for aCity in jsonResult["cities"]
                    {
                        print(aCity.0," ",aCity.1)
                        let cityName : String = aCity.0
                        let idx = Int(aCity.1.rawString()!)!
                        self.cityDict[cityName] = aCity.1.rawString()!
                        cityList[idx] = cityName
                        
                    }
                    
                    print("Fetched : ",cityList.count," record")
                    //print("Cities : ",cityList)
                    print("Successful")
                    self.cityCache = cityList
                }
                break
                
            case .failure(_):
                if response.result.error != nil
                {
                    print("Not Successful")
                    print(response.result.error!)
                }
                break
            }
            
        }
    }
    
    func getAllCityList() -> Array<String> {
        if cityCache.count == 0 {
            print("City list not ready yet for ",currentStateCode)
            getAllCity(currentStateCode)
           return ["مجدد تلاش کنید"];
        }else{
            return cityCache
        }
    }
    func findStateCodeFor(provinceName : String) -> String! {
        for aprov in provinceDict {
            if aprov.value == provinceName {
                return aprov.key
            }
        }
        return nil
    }
    
    func getGendersList() -> Array<String> {
        return ["زن","مرد"]
    }

    @IBAction func provinceTextTouchDown(_ sender: Any) {
        let controller = ArrayChoiceTableViewController(getAllProvinceList()) {
            (type) in self.provinceModel.type = type
            print("stateCode : ",self.provinceDict[type])
            self.currentStateCode = self.provinceDict[type] as! String
            //self.getAllCity(self.provinceDict[type]!)
            self.getAllCity("23")
            //print("State-code : ",self.findStateCodeFor(provinceName : type))
        }
        controller.preferredContentSize = CGSize(width: 250, height: 300)
        showPopup(controller, sourceView: sender as! UIView)
        
    }
    @IBAction func cityTextTouchDown(_ sender: Any) {
        let controller = ArrayChoiceTableViewController(getAllCityList()) {
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
        getAllProvince()
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


