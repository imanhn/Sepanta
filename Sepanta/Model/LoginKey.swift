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

    func loadShopDemoLoginCredentials(){
        print("*** DEMO (Shop) ***")
        self.userID = "81"
        self.role = "Shop"
        self.username = "zich"
        self.token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjU2OTY0ZTJjOTk3NGQ3YjAwZjdkODZlOWQwMWNkZWM1NTI5ZGQ5OGE1ZmI2NGFiMmY5NTdkNGE5MzY2MGVjOGFlYzgwZDJhMWFlMzRkMmQ0In0.eyJhdWQiOiIzIiwianRpIjoiNTY5NjRlMmM5OTc0ZDdiMDBmN2Q4NmU5ZDAxY2RlYzU1MjlkZDk4YTVmYjY0YWIyZjk1N2Q0YTkzNjYwZWM4YWVjODBkMmExYWUzNGQyZDQiLCJpYXQiOjE1NTg2MDQ1OTAsIm5iZiI6MTU1ODYwNDU5MCwiZXhwIjoxNTkwMjI2OTkwLCJzdWIiOiI4MSIsInNjb3BlcyI6W119.UCA2X6MZFUohhfXmdKBlrsM8HE1TfLaVug55xva0otjxS8Fp1vXAaT1XIhGxyAu6j7HgL62qenY5vq08tljVWU5KBu_EuPJNiGps6uj3ZbH1coilJYj92xVZfMgAlPnZ9vp01_AQeV0gyojsBREy3eGXE7d80O6zgeemxxR-0ENTeD5-MiJn7MSThcAHrZPLXiQTnavkWTbcn4iygRVxf7tk_n8pKtqIApKKCecMahKo0YGDi8RgSVypz6Fh3K_tlk6LYiF7in1RjhkQinpgee3lPtnSTa2vRYA2lyer9zxJaTPLViY8_ZgCOjh11pRqAoAsTcx_SD2dxzdhZR3PNSnGW-Wc2rj51ZGNemYOUD7lOtnQxdmXiI3K-1YZFObl6iRprLgvmWarstNCmrTzBq1KR8VD1UkDAzJ_miLGJjQAsvtCdXR1as7ZYW9_rN7lqR05LzoAic3zOWwYGoaUjabTK37zFw8a_ioNch1S63k3_5dqw8jm4HF1OMuW2efvE1xvbdiloofzvdoqInobQ5XV6BQ0Skc2xwxO6cK-InfIpp2DJOpmy6LdrAmUvkYMfOpobwH_RCbLguhRD-Gx3jnSbYzaakiLmvT2wToNYwzihNlqsr23ttMJ10o988pOaKxXkHDK-GL5605c6keE3I1mbweWhf_YIsk5ADGz9Q4"
        _ = registerTokenAndUserID()
        // shopid = 2162
    }
    func loadUserDemoLoginCredentials(){
        print("*** DEMO (User) ***")
        self.userID = "49"
        self.role = "User"
        self.username = "imanKhan"
        self.token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjRkNjZjYjQyNWIwM2YzYzhlYzUyYzRiNzYzNzcyOTNkMDkzYTVkZWFlN2VkM2VmNzQ0YTM3YTRkOGEyNmNhNzcyOGRiM2NkNmY1YTQ4ZTQ4In0.eyJhdWQiOiIzIiwianRpIjoiNGQ2NmNiNDI1YjAzZjNjOGVjNTJjNGI3NjM3NzI5M2QwOTNhNWRlYWU3ZWQzZWY3NDRhMzdhNGQ4YTI2Y2E3NzI4ZGIzY2Q2ZjVhNDhlNDgiLCJpYXQiOjE1NTg2MDYxMTEsIm5iZiI6MTU1ODYwNjExMSwiZXhwIjoxNTkwMjI4NTExLCJzdWIiOiI0OSIsInNjb3BlcyI6W119.fYDuRmvxZNHcP92YnKPz2e1q-FF9aBYJ_FpYcrwvO90GZKD7Qm_Z6fIArbg3bNl21hcF1qO_TMOi5Gtp_ChkD65vnjMRq9i6a84fny1ImG6ejtry4sydLQ65LWLDXSRXFmp-pE0JLYcYqoE0Ki5y-29A8seel3GpqxrUV-lL383pzcT38wxU3I2YYF_-6P0kLEjDp2S1Fmem3KTWSPbUoxSqIz9SpTEZOvRv8GozgmV0ZOHnmPdBI3AkXMOPy3CaPBUwkdU6cHr7CqDGiWXIY10f4kuanCeAt3zlbI58c1VS6JyLf9k9y2kVbF05Mwu2iHl9AV5RDwZVWOvyFqEiYIhHYFCqjPD_QFSCymgv2t0fCGXODSDeU7p2RBY5Y7y0l5NHB-C4RlwvkYlcuHzkl2JDJ0cAXJneRFGcovI4GM5y9U4pqUSpQnsuFnfVVGN-MG7RD_9FZoC_voki1nMy409-iH8DOxNyOJE_NEcxfdhShhkTHkO5yduPQjbLJX921TOsGBBCzgonAoVK6v8ZKKaAylD-9glYVx8mgjzTi0dNdMwVGRIR7UmbgTBcJ2z0uOsGOgOaGnEv54WK_XeOd9sliLm5g2cz7ESn6dci58Vh8qkll7woP4Q3t1CZh-pupu4Bf0YBTze924q2z9fUDeQGIQTLUkQCsPTvnPeTPyc"
        _ = registerTokenAndUserID()
    }

}
