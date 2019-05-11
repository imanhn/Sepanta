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
    var version : Float = 1.0
    var myDisposeBag = DisposeBag()
    static let shared = LoginKey()
    var userIDObs = BehaviorRelay<String>(value: String())
    var tokenObs = BehaviorRelay<String>(value: String())

    init() {
    }
    
    func registerTokenAndUserID() -> Bool {
        print("************************")
        print("self.token : ",self.token)
        print("************************")
        print("Registering Token :",self.token.count,"  USERID :",self.userID,"  Role : ",self.role)
        let tokenSucceed = KeychainWrapper.standard.set(self.token, forKey:"TOKEN")
        if tokenSucceed { print("Token Saved Successfully") } else {
            print("Token Can not be saved")
            fatalError()
        }
        
        let useridSucceed = KeychainWrapper.standard.set(self.userID, forKey:"USERID")
        if useridSucceed { print("UserID Saved Successfully") } else {
            print("UserID Can not be saved")
            fatalError()
        }

        let usernameSucceed = KeychainWrapper.standard.set(self.username, forKey:"USERNAME")
        if usernameSucceed { print("UserName Saved Successfully") } else {
            print("UserName Can not be saved")
            fatalError()
        }

        let roleSucceed = KeychainWrapper.standard.set(self.role, forKey:"ROLE")
        if roleSucceed { print("Role Saved Successfully") } else {
            print("Role Can not be saved")
            fatalError()
        }

        if tokenSucceed && useridSucceed && roleSucceed {
            let loginDataSaved = KeychainWrapper.standard.set("YES", forKey:"LOGIN")
            return loginDataSaved
        } else {
            print("Unable to save login data....")            
             _ = KeychainWrapper.standard.set("NO", forKey:"LOGIN")
            fatalError()
            //return loginDataSaved
        }
    }
    
    func isLoggedIn() -> Bool{
        let loginDataSaved : String? = KeychainWrapper.standard.string(forKey: "LOGIN")
        let tokenSaved : String? = KeychainWrapper.standard.string(forKey: "TOKEN")
        print("loginDataSaved : \(String(describing: loginDataSaved))")
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
        //let arole : String? = KeychainWrapper.standard.string(forKey: "ROLE")
        if loginDataSaved == "YES" {
            if let atoken  = KeychainWrapper.standard.string(forKey: "TOKEN") {
                self.token = atoken
            }else{
                print("ERROR : No Token could be read")
            }
            if let auserid = KeychainWrapper.standard.string(forKey: "USERID") {
                self.userID = auserid
            }
            if let arole = KeychainWrapper.standard.string(forKey: "ROLE") {
                self.role = arole
            }
            if let auserName = KeychainWrapper.standard.string(forKey: "USERNAME") {
                self.username = auserName
            }
            print("Your USERID : ",self.userID)
            print("Your UserName : ",self.username)
            print("Your token : ",self.token.count)
            print("Your role would be : ",self.role)
            return true
        } else {
            return false
        }
    }

    func getUserID(_ phoneNumber : String){
        let parameters = [
            "cellphone": phoneNumber
        ]
        Spinner.start()
        NetworkManager.shared.run(API: "login",QueryString: "", Method: HTTPMethod.post, Parameters: parameters, Header: nil,WithRetry: false)
    }
    
    func getToken(_ smsCode : String){
        let parameters = [
            "sms_verification_code": smsCode,
            "userId":self.userID
        ]
        let queryString = "?sms_verification_code=\(smsCode)&userId=\(self.userID)"
        print("Getting URL : ",queryString)
        Spinner.start()
        NetworkManager.shared.run(API: "check-sms-code",QueryString: queryString, Method: HTTPMethod.post, Parameters: parameters, Header: nil,WithRetry: true)
    }

}
