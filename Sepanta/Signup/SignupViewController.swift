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

class SignupViewController: UIViewController,UITextFieldDelegate   {
    var userID : String = ""
    var smsVerificationCode : String = ""
    var provincesCache : [String] = []
    var provinceDict : Dictionary = ["TEST":"TEST"];
    var cityDict : Dictionary = ["TEST":"TEST"];
    var cityCache : [String] = []
    var currentStateCode : String = ""
    var currentCityCode : String = ""
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
                    for aProv in jsonResult["states"]
                    {
                        print(aProv.0," ",aProv.1)
                        let provName : String = aProv.0
                        self.provinceDict[provName] = aProv.1.rawString()!
                        provinceList.append(provName)
                        
                    }
                    
                    print("Fetched : ",provinceList.count," record")
                    //print("Provinces : ",provinceList)
                    print("Successful")
                    self.provincesCache = provinceList.sorted()
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
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type":"application/x-www-form-urlencoded"
        ]
        let parameters = [
         "state code": stateCode
         ]
//        let urlAddress = NSURL(string: "http://www.favecard.ir/api/takamad/get-state-and-city?state code="+stateCode)
        let postURL = NSURL(string: "http://www.favecard.ir/api/takamad/get-state-and-city?state%20code="+stateCode)! as URL
        let aMethod : HTTPMethod = HTTPMethod.post
        print("Calling City API")
        Alamofire.request(postURL, method: aMethod, parameters: parameters, encoding: JSONEncoding.default,  headers: headers).responseJSON { (response:DataResponse<Any>) in
            print("Processing City Response....")
            switch(response.result) {
            case .success(_):
                
                if response.result.value != nil
                {
                    let jsonResult = JSON(response.result.value!)
                    //cityList = Array<String>(repeating: "", count: jsonResult["cities"].count)
                    for aCity in jsonResult["cities"]
                    {
                        print(aCity.0," ",aCity.1)
                        let cityName : String = aCity.0
                        let idx = Int(aCity.1.rawString()!)!
                        self.cityDict[cityName] = aCity.1.rawString()!
                        cityList.append(cityName)
                        
                    }
                    
                    print("Fetched : ",cityList.count," record")
                    //print("Cities : ",cityList)
                    print("Successful")
                    self.cityCache = cityList.sorted()
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

    
    func getGendersList() -> Array<String> {
        return ["زن","مرد"]
    }

    @IBAction func provinceTextTouchDown(_ sender: Any) {
        let controller = ArrayChoiceTableViewController(getAllProvinceList()) {
            (type) in self.provinceModel.type = type
            self.selectCity.text = ""
            print("State Code : ",self.provinceDict[type]!)
            self.currentStateCode = self.provinceDict[type] as! String
            self.getAllCity(self.provinceDict[type]!)
            
        }
        controller.preferredContentSize = CGSize(width: 250, height: 300)
        showPopup(controller, sourceView: sender as! UIView)
        
    }
    @IBAction func cityTextTouchDown(_ sender: Any) {
        let controller = ArrayChoiceTableViewController(getAllCityList()) {
            (type) in self.cityModel.type = type
             print("City Code : ",self.cityDict[type]!)
            self.currentCityCode = self.cityDict[type] as! String
        }
        controller.preferredContentSize = CGSize(width: (sender as! UITextField).bounds.width, height: 200)
        showPopup(controller, sourceView: sender as! UIView)
        selectCity.resignFirstResponder()
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
        definesPresentationContext = true
        selectCity.delegate = self
        selectProvince.delegate = self
        genderTextField.delegate = self
        mobileNoText.delegate = self
        usernameText.delegate = self
        
        selectCity.resignFirstResponder()
        selectProvince.resignFirstResponder()
        genderTextField.resignFirstResponder()
        mobileNoText.resignFirstResponder()
        usernameText.resignFirstResponder()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return [true,""]
        
    }
    func registerUser(MobileNumber : String,GenderCode : String,Username : String){
        
        var signupResultMessage : String = ""
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type":"application/x-www-form-urlencoded"
        ]
        let parameters = [
            "phone" : MobileNumber,
            "gender" : GenderCode,
            "state" : currentStateCode,
            "city" : currentCityCode,
            "username" : Username
        ]
 
        var signupSucceed : Bool = false
        
        let urlString = "http://www.favecard.ir/api/takamad/register?phone="+MobileNumber+"&gender="+GenderCode+"&state="+currentStateCode+"&city="+currentCityCode+"&username="+Username
        let postURL = NSURL(string: urlString)! as URL

        
/*
        var request = URLRequest(url: postURL)
         var afManager : SessionManager!
         request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 100
        let postString = "phone=\(MobileNumber)&gender=\(GenderCode)&state=\(currentStateCode)&city=\(currentCityCode)&username=\(Username)"
        request.httpBody = postString.data(using: .utf8)
        let configuration = URLSessionConfiguration.default
        afManager = Alamofire.SessionManager(configuration: configuration)
        afManager.request(request).responseJSON
          { (response:DataResponse<Any>) in
*/
 
        let aMethod : HTTPMethod = HTTPMethod.post
        print("Calling Register API")
        Alamofire.request(postURL, method: aMethod, parameters: parameters, encoding: JSONEncoding.default,  headers: headers).responseJSON { (response:DataResponse<Any>) in
 
            print("Processing Register Response....")
            switch(response.result) {
            case .success(_):
                
                if response.result.value != nil
                {
                    let jsonResult = JSON(response.result.value!)
                    
                    if jsonResult["status"] == JSON.null {
                        print("No Status")
                    }else{
                        print("Status : ",jsonResult["status"])
                        if jsonResult["status"].string != nil {
                            let statusMessage = jsonResult["status"].string!
                            if statusMessage.uppercased() == "successful".uppercased() {
                                signupSucceed = true
                            }
                        }
                    }
                    
                    if jsonResult["userId"] == JSON.null {
                        print("No userId")
                    }else{
                        print("userId : ",jsonResult["userId"])
                        if jsonResult["userId"].string != nil {
                            self.userID = jsonResult["userId"].string!
                        }
                        signupSucceed = true
                    }

                    if jsonResult["message"] == JSON.null {
                        print("No message")
                    }else{
                        print("message : ",jsonResult["message"])
                        if jsonResult["message"].string != nil {
                            signupResultMessage = jsonResult["message"].string!
                            signupSucceed = true
                        }
                    }
/*
                    if jsonResult["sms_verification_code"] == JSON.null {
                        print("No sms_verification_code")
                    }else{
                        print("sms_verification_code : ",jsonResult["sms_verification_code"])
                        self.smsVerificationCode = jsonResult["sms_verification_code"].arrayValue[0].string!
                        signupSucceed = true
                    }
 */
                    
                    if jsonResult["phone"] == JSON.null {
                        print("No phone")
                    }else{
                        let str = jsonResult["phone"].arrayValue[0].string!
                        print("Phone : ",str)
                        signupResultMessage = signupResultMessage + str + "\n"
                        signupSucceed = false
                    }
                    
                    if jsonResult["username"] == JSON.null {
                        print("No username")
                    }else{
                        let str = jsonResult["username"].arrayValue[0].string!
                        print("username : ",str)
                        signupResultMessage = signupResultMessage + str + "\n"
                        signupSucceed = false
                    }
                    if signupSucceed {
                        self.showSuccessfullSignupAndGoToMainView()
                    }else {
                        self.showMessage(aMessage : signupResultMessage)
                    }
                    print("Message : ",signupResultMessage)
                    print("Successful")
                }
                break
                
            case .failure(_):
                if response.result.error != nil
                {
                    print("Not Successful")
                    print(response.result.error!)
                    signupResultMessage = "ارتباط با سرور برقرار نشد"
                    signupSucceed = false
                    self.showMessage(aMessage : "ارتباط با سرور برقرار نشد لطفا مجددا تلاش کنید")
                    
                }
                break
            }
            
        }
    }
    
    func showSuccessfullSignupAndGoToMainView(){
       // showMessage(aMessage : "ثبت نام با موفقیت انجام شد")
        let alert = UIAlertController(title: "توجه", message: "ثبت نام با موفقیت انجام شد", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "بلی", style: .default, handler: { action in
            switch action.style{
            case .default:
                // Goto Main Page to show businesses
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc : MainViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                self.present(vc, animated: false, completion: nil)
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }

    
    func showMessage(aMessage : String){
        let alert = UIAlertController(title: "توجه", message: aMessage, preferredStyle: .alert)
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
    
    @IBAction func SubmitSignupFormClicked(_ sender: Any) {
/*
        currentCityCode = "01"
        currentStateCode = "23"
        registerUser(MobileNumber: "09121325452", GenderCode: "1", Username: "iman2")
        return
 */
        var validationResult = validateForm();
        var genderCode : String = "1"
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
            return
        }
        // Registering user
        
        if genderTextField.text! == "زن" {
            genderCode = "0"
        }else{
            genderCode = "1"
        }
        registerUser(MobileNumber: mobileNoText.text!, GenderCode: genderCode, Username: usernameText.text!)
    }
}


