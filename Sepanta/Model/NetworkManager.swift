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
import SwiftyJSON

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
    var status : CallStatus //No used Yet
    
    let netObjectsDispose = DisposeBag()
    var headers : HTTPHeaders
    var statusMessage : String
    var message : String
    // Result of Parser :
    var provinceDictionaryObs = BehaviorRelay<Dictionary<String,String>>(value: Dictionary<String,String>())
    var cityDictionaryObs = BehaviorRelay<Dictionary<String,String>>(value: Dictionary<String,String>())
    
    // Initialization
    
    private init() {
        self.baseURLString = "http://www.favecard.ir/api/takamad/"
        self.status = .ready
        self.message = ""
        self.statusMessage = ""
        self.headers = [
            "Accept": "application/json",
            "Content-Type":"application/x-www-form-urlencoded"
        ]
        
    }
    
    func run(API apiName : String, QueryString aQuery : String, Method aMethod : HTTPMethod, Parameters aParameter : Dictionary<String, String>?, Header  aHeader : HTTPHeaders?  ) {
        self.status = CallStatus.inprogress
        let urlAddress = self.baseURLString + apiName + aQuery
        
        var headerToSend = self.headers
        if (aHeader) != nil{
            headerToSend = aHeader!
        }
        //print("Calling Alamofire with Header : ",headerToSend.count,"  Tok :",LoginKey.shared.token,"  ID : ",LoginKey.shared.userID)
        //print("Header : ",headerToSend)
        
        print("URL CONV : ",urlAddress)
        RxAlamofire.requestJSON(aMethod, urlAddress , parameters: aParameter, encoding: JSONEncoding.default, headers: headerToSend)
        .observeOn(MainScheduler.instance)
        .timeout(2, scheduler: MainScheduler.instance)
        .retry(4)
        //.debug()
        .subscribe(onNext: { [weak self] (ahttpURLRes,jsonResult) in
            if let aresult = jsonResult as? NSDictionary {
                self?.result = aresult
                self?.parser = JSONParser(API: apiName,Method : aMethod)
                if let aparser = self?.parser! {
                    aparser.resultSubject.accept(aresult)
                }
            } else {
                self?.status = CallStatus.error
            }
            if let amessage = self?.result["message"] as? String {
                if amessage == "Unauthenticated." {
                    print("User is not authorized")
                }
                self?.message = amessage
            }
            if let astatus = self?.result["status"] as? String {
                self?.message = astatus
            }
            if let acontent = self?.result["content"] as? NSDictionary {
                self?.content = acontent
            }
            }, onError: { (err) in
                if err.localizedDescription == "The Internet connection appears to be offline." {
                    print("No Internet")
                }
                print("NetworkManager rxAlamo On Error : >",err.localizedDescription,"<")
                Spinner.stop()
                self.status = CallStatus.error
            }, onCompleted: {
                self.status = CallStatus.ready
                print("Completed")
                self.parser = nil
            }, onDisposed: {
                print("NetworkManager Disposed")
        }).disposed(by: netObjectsDispose)
    }
    
}
