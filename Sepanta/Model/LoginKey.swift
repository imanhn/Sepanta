//
//  KeyChainInterface.swift
//  Sepanta
//
//  Created by Iman on 11/29/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import RxCocoa
import Alamofire
import RxSwift
import SwiftKeychainWrapper

class LoginKey {
    var token = String()
    var userID = String()
    var username = String()
    var role = String()
    var myDisposeBag = DisposeBag()
    static let shared = LoginKey()
    var userIDObs = BehaviorRelay<String>(value: String())
    var tokenObs = BehaviorRelay<String>(value: String())

    init() {
    }
    
    func registerTokenAndUserID() -> Bool {
        let tokenSucceed = KeychainWrapper.standard.set(self.token, forKey:"TOKEN")
        if tokenSucceed { print("Token Saved Successfully") } else { print("Token Can not be saved") }
        
        let useridSucceed = KeychainWrapper.standard.set(self.userID, forKey:"USERID")
        if useridSucceed { print("UserID Saved Successfully") } else { print("UserID Can not be saved") }
        
        if tokenSucceed && useridSucceed {
            let loginDataSaved = KeychainWrapper.standard.set("YES", forKey:"LOGIN")
            return loginDataSaved
        } else {
            print("Unable to save login data....")
            let loginDataSaved = KeychainWrapper.standard.set("NO", forKey:"LOGIN")
            return loginDataSaved
        }
    }
    
    func isLoggedIn() -> Bool{
        let loginDataSaved : String? = KeychainWrapper.standard.string(forKey: "LOGIN")
        let tokenSaved : String? = KeychainWrapper.standard.string(forKey: "TOKEN")
        print("loginDataSaved : ",loginDataSaved)
        if loginDataSaved != nil && tokenSaved != nil{
            if loginDataSaved! == "YES" && tokenSaved!.count > 2 { return true} else {return false}
        }else {
            return false
        }
    }
    
    func deleteTokenAndUserID(){
        let deleteSucceed = KeychainWrapper.standard.set("NO", forKey:"LOGIN")
        if deleteSucceed {print("Logout registered in KeyChain")}else{print("Logout Unsuccessfull")}
    }
    
    func retrieveTokenAndUserID() -> Bool {
        let loginDataSaved : String? = KeychainWrapper.standard.string(forKey: "LOGIN")
        if loginDataSaved == "YES" {
            self.token = KeychainWrapper.standard.string(forKey: "TOKEN")!
            self.userID = KeychainWrapper.standard.string(forKey: "USERID")!
            print("Your USERID : ",self.userID)
            return true
        } else {
            return false
        }

    }

    func getUserID(_ phoneNumber : String){
        let parameters = [
            "cellphone": phoneNumber
        ]
        let queryString = "?cellphone=\(phoneNumber)"
        Spinner.start()
        NetworkManager.shared.run(API: "login",QueryString: queryString, Method: HTTPMethod.post, Parameters: parameters, Header: nil)
    }
    
    func getToken(_ smsCode : String){
        let parameters = [
            "sms_verification_code": smsCode,
            "userId":self.userID
        ]
        let queryString = "?sms_verification_code=\(smsCode)&userId=\(self.userID)"
        print("Getting URL : ",queryString)
        Spinner.start()
        NetworkManager.shared.run(API: "check-sms-code",QueryString: queryString, Method: HTTPMethod.post, Parameters: parameters, Header: nil)
    }

}
