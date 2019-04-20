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
import RxSwift
import RxCocoa


class SignupViewController: UIViewControllerWithKeyboardNotificationWithErrorBar,UITextFieldDelegate,Storyboarded   {
    weak var coordinator : LoginCoordinator?
    var userID : String = ""
    var smsVerificationCode : String = ""
    var currentStateCodeObs = BehaviorRelay<String>(value : String())
    var currentCityCodeObs = BehaviorRelay<String>(value : String())
    var myDisposeBag = DisposeBag()
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
    
    @IBAction func enterTapped(_ sender: Any) {
        self.coordinator!.gotoLogin(Set: self.mobileNoText.text ?? "")
    }
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
        genderTextField.resignFirstResponder()
    }
    func updateProvince(){
        self.selectProvince.text = provinceModel.type
        selectProvince.resignFirstResponder()
    }
    func updateCity(){
        self.selectCity.text = cityModel.type
        selectCity.resignFirstResponder()
    }
    @IBAction func mobileNoTypeDone(_ sender: Any) {
        _=(sender as AnyObject).resignFirstResponder()
    }
    
    @IBAction func usernameTypeDone(_ sender: Any) {
        _=(sender as AnyObject).resignFirstResponder()
    }
    
    
    func getGendersList() -> Array<String> {
        return ["زن","مرد"]
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == selectProvince || textField == selectCity || textField == genderTextField {
            return false
        } else {
            return true
        }
    }
    
    @IBAction func provinceTextTouchDown(_ sender: Any) {
        //var outsideController = ArrayChoiceTableViewController<String>()
        Spinner.start()
        NetworkManager.shared.run(API: "get-state-and-city",QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil,WithRetry: true)
        NetworkManager.shared.provinceDictionaryObs
            //.debug()
            .filter({$0.count > 0})
            .subscribe(onNext: { [weak self] (innerProvinceDicObs) in
                print("innerProvinceDicObs : ",innerProvinceDicObs.count)
                let controller = ArrayChoiceTableViewController(innerProvinceDicObs.keys.sorted(){$0 < $1}) {
                    (type) in self?.provinceModel.type = type
                    self?.selectCity.text = ""
                    print("State Code : ",innerProvinceDicObs[type]!)
                    self?.currentStateCodeObs.accept(innerProvinceDicObs[type]!)
                }
                controller.preferredContentSize = CGSize(width: 250, height: 300)
                Spinner.stop()
                //print("Setting controller")
                self?.showPopup(controller, sourceView: sender as! UIView)
                NetworkManager.shared.provinceDictionaryObs = BehaviorRelay<Dictionary<String,String>>(value: Dictionary<String,String>())
            }, onError: { _ in
                print("Province Call Raised Error")
                Spinner.stop()
            }, onCompleted: {
                print("Province Call Completed")
            }, onDisposed: {
            }).disposed(by: myDisposeBag)
    }

    @IBAction func cityTextTouchDown(_ sender: Any) {
        let parameters = [
            "state code": self.currentStateCodeObs.value
        ]
        let queryString = "?state code=\(self.currentStateCodeObs.value)"
        Spinner.start()
        NetworkManager.shared.run(API: "get-state-and-city",QueryString: queryString, Method: HTTPMethod.post, Parameters: parameters, Header: nil,WithRetry: true)
        NetworkManager.shared.cityDictionaryObs
            //.debug()
            .filter({$0.count > 0})
            .subscribe(onNext: { [weak self] (innerCityDicObs) in
                let controller = ArrayChoiceTableViewController(innerCityDicObs.keys.sorted(){$0 < $1}) {
                    (type) in self?.cityModel.type = type
                    print("City Code : ",innerCityDicObs[type]!)
                    self?.currentCityCodeObs.accept(innerCityDicObs[type]!)
                }
                controller.preferredContentSize = CGSize(width: 250, height: 300)
                Spinner.stop()
                //print("Setting controller")
                self?.showPopup(controller, sourceView: sender as! UIView)
                NetworkManager.shared.cityDictionaryObs = BehaviorRelay<Dictionary<String,String>>(value: Dictionary<String,String>())
                }, onError: { _ in
                    Spinner.stop()
            }, onCompleted: {
            }, onDisposed: {
            }).disposed(by: myDisposeBag)
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
        //print("Showing POPUP : ",sourceView)
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
    override func viewDidLoad() {        
        super.viewDidLoad()
        subscribeToInternetDisconnection().disposed(by: myDisposeBag)
        definesPresentationContext = true
        selectCity.delegate = self
        selectProvince.delegate = self
        genderTextField.delegate = self
        mobileNoText.delegate = self
        usernameText.delegate = self
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
        
//        var signupResultMessage : String = ""
//        let headers: HTTPHeaders = [
//            "Accept": "application/json",
//            "Content-Type":"application/x-www-form-urlencoded"
//        ]
//        let parameters = [
//            "phone" : MobileNumber,
//            "gender" : GenderCode,
//            "state" : self.currentStateCodeObs.value,
//            "city" : self.currentCityCodeObs.value,
//            "username" : Username
//        ]
// 
//        var signupSucceed : Bool = false
//        
//        let urlString = NetworkManager.shared.baseURLString+"/register?phone="+MobileNumber+"&gender="+GenderCode+"&state="+self.currentStateCodeObs.value+"&city="+self.currentCityCodeObs.value+"&username="+Username
//        let postURL = NSURL(string: urlString)! as URL
//
//        let aMethod : HTTPMethod = HTTPMethod.post
//        print("Calling Register API")

        /*
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
 */
    }
    
    func showSuccessfullSignupAndGoToMainView(){
       // showMessage(aMessage : "ثبت نام با موفقیت انجام شد")
        let alert = UIAlertController(title: "توجه", message: "ثبت نام با موفقیت انجام شد", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "بلی", style: .default, handler: { action in
            switch action.style{
            case .default:
                // Goto Main Page to show businesses
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc : HomeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
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
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

}


