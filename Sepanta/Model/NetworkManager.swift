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
    let websiteRootAddress = "http://www.ipsepanta.ir"
    var status = BehaviorRelay<CallStatus>(value: CallStatus.ready) //No used Yet
    var shopFav = BehaviorRelay<ToggleStatus>(value: ToggleStatus.UNKNOWN)
    let netObjectsDispose = DisposeBag()
    var headers : HTTPHeaders
    var statusMessage : String
    var message : String
    var messageObs = BehaviorRelay<String>(value: "")
    // Result of Parser :
    var provinceDictionaryObs = BehaviorRelay<Dictionary<String,String>>(value: Dictionary<String,String>())
    var cityDictionaryObs = BehaviorRelay<Dictionary<String,String>>(value: Dictionary<String,String>())
    var catagoriesObs = BehaviorRelay<[Any]>(value: [Any]())
    var shopObs = BehaviorRelay<[Any]>(value: [Any]())
    var postDetailObs = BehaviorRelay<Post>(value: Post(id: 0, shopId: 0, viewCount: 0, comments: [], isLiked: false, countLike: 0, title: "", content: "", image: ""))
    var postCommentsObs = BehaviorRelay<[Comment]>(value: [Comment]())
    var commentSendingSuccessful = BehaviorRelay<Bool>(value: false)
    var contactSendingSuccessful = BehaviorRelay<ToggleStatus>(value: ToggleStatus.UNKNOWN)
    var toggleLiked = BehaviorRelay<ToggleStatus>(value: ToggleStatus.UNKNOWN)
    var updateProfileInfoSuccessful = BehaviorRelay<Bool>(value: false)
    var shopSearchResultObs = BehaviorRelay<[ShopSearchResult]>(value: [ShopSearchResult]())
    var profileObs = BehaviorRelay<Profile>(value: Profile())
    var bankObs = BehaviorRelay<Bank>(value: Bank())
    var pollObs = BehaviorRelay<Int>(value: 0)
    var userPointsObs = BehaviorRelay<UserPoints>(value: UserPoints())
    var pointsElementsObs = BehaviorRelay<[PointElement]>(value: [PointElement]())
    var shopNotifObs = BehaviorRelay<[ShopNotification]>(value: [ShopNotification]())
    var generalNotifObs = BehaviorRelay<[GeneralNotification]>(value: [GeneralNotification]())
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
    func run(API apiName : String, QueryString aQuery : String, Method aMethod : HTTPMethod, Parameters aParameter : Dictionary<String, String>?, Header  aHeader : HTTPHeaders? ,WithRetry : Bool) {
        var retryTime = 4
        if WithRetry == false {
            print("NOT Retrying - \(apiName)")
            retryTime = 1
        }
        
        self.status.accept(CallStatus.inprogress)
        Spinner.start()
        var urlAddress = self.baseURLString + "/" + apiName + aQuery
        
        var headerToSend = self.headers
        if (aHeader) != nil{
            headerToSend = aHeader!
        }
        //print("Calling Alamofire with Header : ",headerToSend.count,"  Tok :",LoginKey.shared.token,"  ID : ",LoginKey.shared.userID)
        
        if aParameter != nil {
            let queryString = buildQueryStringSuffix(aParameter!)
            urlAddress = self.baseURLString + "/" + apiName + queryString
            print("Built urlAddress : ",urlAddress)
        }
        
        print("RXAlamofire : Requesting JSON over URL : ",urlAddress)
        /*
        print("      Parameter : \(aParameter)")
        print("      Header : \(headerToSend)")
        print("      Method : \(aMethod)")
        */
        RxAlamofire.requestJSON(aMethod, urlAddress , parameters: aParameter, encoding: JSONEncoding.default, headers: headerToSend)
        .observeOn(MainScheduler.instance)
        .timeout(4, scheduler: MainScheduler.instance)
        .retry(retryTime)
        //.debug()
        .subscribe(onNext: { [unowned self] (ahttpURLRes,jsonResult) in
            
            print(" Response Code : ",ahttpURLRes.statusCode)
            if let aresult = jsonResult as? NSDictionary {
                self.result = aresult
                self.parser = JSONParser(API: apiName,Method : aMethod)
                if let aparser = self.parser {
                    aparser.resultSubject.accept(aresult)                    
                }
                if ahttpURLRes.statusCode >= 400 {
                    if let amessage = self.result["message"] as? String {
                        print("Setting : ",amessage)
                        self.messageObs.accept(amessage)
                    }
                }
                self.status.accept(CallStatus.ready)
            } else {
                
                self.status.accept(CallStatus.error)
            }
            if ahttpURLRes.statusCode == 500 { self.status.accept(CallStatus.InternalServerError)}
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
