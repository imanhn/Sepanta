//
//  CallServices.swift
//  Sepanta
//
//  Created by Iman on 11/25/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import RxAlamofire
import MapKit

enum CallStatus {
    case ready
    case inprogress
    case error
    case InternalServerError
    case IncompleteData
}

enum ToggleStatus {
    case YES
    case NO
    case UNKNOWN
}

class NetworkManager {
    
    // MARK: - Properties
    
    static let shared = NetworkManager()
    var parser : JSONParser?
    var result = NSDictionary()
    var content = NSDictionary()
    //var resultSubject = BehaviorRelay<NSDictionary>(value : NSDictionary())
    let baseURLString: String
    //let websiteRootAddress = "https://www.sepantaclubs.com"
    let websiteRootAddress = "https://www.ipsepanta.ir"
    var status = BehaviorRelay<CallStatus>(value: CallStatus.ready) //No used Yet
    var shopFav = BehaviorRelay<ToggleStatus>(value: ToggleStatus.UNKNOWN)
    let netObjectsDispose = DisposeBag()
    var headers : HTTPHeaders
    var statusMessage : String
    var message : String
    var messageObs = BehaviorRelay<String>(value: "")
    var postsObs = BehaviorRelay<[Post]>(value: [Post]())
    var serverMessageObs = BehaviorRelay<String>(value: "")
    // Result of Parser :
    var allProvinceListObs = BehaviorRelay<[String]>(value: [String]())
    var catagoriesProvinceListObs = BehaviorRelay<[String]>(value: [String]())
    var serviceTypeObs = BehaviorRelay<[String]>(value: [String]())
    var selectedLocation = BehaviorRelay<CLLocationCoordinate2D>(value: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    
    var cityDictionaryObs = BehaviorRelay<Dictionary<String,String>>(value: Dictionary<String,String>())
    //var regionDictionaryObs = BehaviorRelay<Dictionary<String,String>>(value: Dictionary<String,String>())
    var regionListObs = BehaviorRelay<[String]>(value: [String]())
    
    var catagoriesObs = BehaviorRelay<[Any]>(value: [Any]())
    var shopObs = BehaviorRelay<[Shop]>(value: [Shop]())
    var newShopObs = BehaviorRelay<[Shop]>(value: [Shop]())
    var favShopObs = BehaviorRelay<[Shop]>(value: [Shop]())
    var postDetailObs = BehaviorRelay<Post>(value: Post())
    var postCommentsObs = BehaviorRelay<[Comment]>(value: [Comment]())
    var commentSendingSuccessful = BehaviorRelay<Bool>(value: false)
    var contactSendingSuccessful = BehaviorRelay<ToggleStatus>(value: ToggleStatus.UNKNOWN)
    var toggleLiked = BehaviorRelay<ToggleStatus>(value: ToggleStatus.UNKNOWN)
    var updateProfileInfoSuccessful = BehaviorRelay<Bool>(value: false)
    var shopSearchResultObs = BehaviorRelay<[ShopSearchResult]>(value: [ShopSearchResult]())
    var profileObs = BehaviorRelay<Profile>(value: Profile())
    var shopProfileObs = BehaviorRelay<ShopProfile>(value: ShopProfile())
    var loginSucceed =  BehaviorRelay<Bool>(value: false)
    var SMSConfirmed =  BehaviorRelay<Bool>(value: false)
    var bankObs = BehaviorRelay<Bank>(value: Bank())
    var mobileObs = BehaviorRelay<Mobile>(value: Mobile())
    var nationalCodeCityObs = BehaviorRelay<String>(value: "")
    
    var pollObs = BehaviorRelay<Int>(value: 0)
    var userPointsObs = BehaviorRelay<UserPoints>(value: UserPoints())
    var pointsElementsObs = BehaviorRelay<[PointElement]>(value: [PointElement]())
    var notificationForUserObs = BehaviorRelay<[NotificationForUser]>(value: [NotificationForUser]())
    var notificationForShopObs = BehaviorRelay<[NotificationForShop]>(value: [NotificationForShop]())
    var generalNotifObs = BehaviorRelay<[GeneralNotification]>(value: [GeneralNotification]())
    var shopRateObs = BehaviorRelay<Rate>(value: Rate())
    var versionObs = BehaviorRelay<Float>(value: 0.0)
    // Initialization
    
    private init() {
        self.baseURLString = websiteRootAddress + "/api/v1"
        self.message = ""
        self.statusMessage = ""
        self.headers = [
            "Accept": "application/json",
            "Content-Type":"application/x-www-form-urlencoded"
        ]
        
    }
    func buildQueryStringSuffix(_ aDic : Dictionary<String,String>) -> String{
        if aDic.count == 0 {return ""}
        var queryString : String = "?"
        for akey in aDic.keys {
            queryString = queryString + "\(akey)=\(aDic[akey]!)&"
        }
        _ = queryString.removeLast()
        //return queryString
        let escapedString = queryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        //print(escapedString!)
        return escapedString!
    }
    func run(API apiName : String, QueryString aQuery : String, Method aMethod : HTTPMethod, Parameters aParameter : Dictionary<String, String>?, Header  aHeader : HTTPHeaders? ,WithRetry : Bool,TargetObs targetObs : String = "") {

        var retryTime = 4
        var timeOut : Double = 5
        if WithRetry == false {
            print("NOT Retrying / High Timeout - \(apiName)")
            retryTime = 1
            timeOut = 10
        }
        
        self.status.accept(CallStatus.inprogress)
        Spinner.start()
        let urlAddress = self.baseURLString + "/" + apiName
        let headerToSend = self.headers
        
        print("RXAlamofire : Requesting JSON over URL : ",urlAddress)
        /*
        print("      Parameter : \(aParameter)")
        print("      Header : \(headerToSend)")
        print("      Method : \(aMethod)")
        */
        var anEncoding = URLEncoding.httpBody
        if aMethod == HTTPMethod.get {anEncoding = URLEncoding.default}
        RxAlamofire.requestJSON(aMethod, urlAddress , parameters: aParameter, encoding: anEncoding, headers: headerToSend)
        .observeOn(MainScheduler.instance)
        .timeout(timeOut, scheduler: MainScheduler.instance)
        .retry(retryTime)
        //.debug()
        .subscribe(onNext: { [unowned self] (ahttpURLRes,jsonResult) in
            
            print("urlAddress : ",urlAddress)
            print(" \(apiName) Response Code : ",ahttpURLRes.statusCode)
            //print(" Parameters : ",aParameter)
            print(" Method : ",aMethod)
            print("Heeader : ",headerToSend)
             
            if let aresult = jsonResult as? NSDictionary {
                
                self.result = aresult
                self.parser = JSONParser(API: apiName,Method : aMethod,TargetObs : targetObs)


                if let aparser = self.parser {
                    aparser.resultSubject.accept(aresult)                    
                }
                if ahttpURLRes.statusCode >= 400 {
                    print("Result All Key : ",self.result.allKeys)
                    print("Error : ",self.result["error"] ?? "[Error happened but no Error Key in response!]")
                    if let amessage = self.result["message"] as? String {
                        print("Setting : ",amessage)
                        self.messageObs.accept(amessage)
                    }
                }
                self.status.accept(CallStatus.ready)
            } else {
                
                self.status.accept(CallStatus.error)
            }
            if ahttpURLRes.statusCode == 500 {
                self.status.accept(CallStatus.InternalServerError)
                print("Result with Error : ",self.result)
            }
            Spinner.stop()
            }, onError: { (err) in
                if err.localizedDescription == "The Internet connection appears to be offline." {
                    print("No Internet")
                }
                if err.localizedDescription == "Could not connect to the server." {
                    print("No Server Connection")
                }
                if err.localizedDescription == "The operation couldn’t be completed." {
                    print("Server is too lazy to repond!")                    
                }
                print("NetworkManager RXAlamofire Raised an Error : >",err.localizedDescription,"<")
                Spinner.stop()
                self.status.accept(CallStatus.error)
            }, onCompleted: {
                self.status.accept(CallStatus.ready)
                //print("NetWorkManager Completed")
                Spinner.stop()
                self.parser = nil
            }, onDisposed: {
                self.status.accept(CallStatus.ready)
                Spinner.stop()
                //print("NetworkManager Disposed")
        }).disposed(by: netObjectsDispose)
    }
    
}
