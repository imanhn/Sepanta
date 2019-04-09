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
}

class NetworkManager {
    
    // MARK: - Properties
    
    static let shared = NetworkManager()
    var parser : JSONParser?
    var result = NSDictionary()
    var content = NSDictionary()
    //var resultSubject = BehaviorRelay<NSDictionary>(value : NSDictionary())
    let baseURLString: String
    let websiteRootAddress = "http://www.panel.ipsepanta.ir"
    var status = BehaviorRelay<CallStatus>(value: CallStatus.ready) //No used Yet
    
    let netObjectsDispose = DisposeBag()
    var headers : HTTPHeaders
    var statusMessage : String
    var message : String
    // Result of Parser :
    var provinceDictionaryObs = BehaviorRelay<Dictionary<String,String>>(value: Dictionary<String,String>())
    var cityDictionaryObs = BehaviorRelay<Dictionary<String,String>>(value: Dictionary<String,String>())
    var catagoriesObs = BehaviorRelay<[Any]>(value: [Any]())
    var shopObs = BehaviorRelay<[Any]>(value: [Any]())
    var postDetailObs = BehaviorRelay<Post>(value: Post(id: 0, shopId: 0, viewCount: 0, comments: [], isLiked: false, countLike: 0, title: "", content: "", image: ""))
    
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
        return queryString
    }
    
    func run(API apiName : String, QueryString aQuery : String, Method aMethod : HTTPMethod, Parameters aParameter : Dictionary<String, String>?, Header  aHeader : HTTPHeaders?  ) {
        self.status.accept(CallStatus.inprogress)
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
        .timeout(2, scheduler: MainScheduler.instance)
        .retry(4)
        //.debug()
        .subscribe(onNext: { [unowned self] (ahttpURLRes,jsonResult) in
            if let aresult = jsonResult as? NSDictionary {
                self.result = aresult
                self.parser = JSONParser(API: apiName,Method : aMethod)
                if let aparser = self.parser {
                    aparser.resultSubject.accept(aresult)
                }
            } else {
                
                self.status.accept(CallStatus.error)
            }
            if let amessage = self.result["message"] as? String {
                if amessage == "Unauthenticated." {
                    print("User is not authorized")
                }
                self.message = amessage
            }
            if let astatus = self.result["status"] as? String {
                self.message = astatus
            }
            if let acontent = self.result["content"] as? NSDictionary {
                self.content = acontent
            }
            }, onError: { (err) in
                if err.localizedDescription == "The Internet connection appears to be offline." {
                    print("No Internet")
                }
                if err.localizedDescription == "Could not connect to the server." {
                    print("No Server Connection")
                }
                print("NetworkManager RXAlamofire Raised an Error : >",err.localizedDescription,"<")
                Spinner.stop()
                self.status.accept(CallStatus.error)
            }, onCompleted: {
                self.status.accept(CallStatus.ready)
                //print("Completed")
                self.parser = nil
            }, onDisposed: {
                //print("NetworkManager Disposed")
        }).disposed(by: netObjectsDispose)
    }
    
}
