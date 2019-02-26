//
//  JSONParser.swift
//  Sepanta
//
//  Created by Iman on 11/25/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift
import RxCocoa

class JSONParser {
    
    // MARK: - Properties
    
    var netObjectsDispose = DisposeBag()
    var resultSubject = BehaviorRelay<NSDictionary>(value : NSDictionary())
//    var result : JSON
    init(API apiName : String, Method aMethod : HTTPMethod) {
       // aMethod is not being used here for network operation.
       // It has only added to distinguish services with same API name and different Method
       // So they need their own Observable type
        resultSubject.asObservable()
            //.debug()
            .filter{ $0.count > 0 }
            .subscribe(onNext: { [weak self] (aDic) in
                //print("Dictionary Received : ",aDic.count,"  ",aDic)
                if (apiName == "get-state-and-city") && (aMethod == HTTPMethod.get){
                    var processedDic = Dictionary<String,String>()
                    (processedDic) = (self?.processAsProvinceList(Result: aDic))!
                    NetworkManager.shared.provinceDictionaryObs.accept(processedDic)//onNext(processedDic)//
                } else if (apiName == "get-state-and-city") && (aMethod == HTTPMethod.post) {
                    var processedDic = Dictionary<String,String>()
                    processedDic = (self?.processAsCityList(Result: aDic))!
                    NetworkManager.shared.cityDictionaryObs.accept(processedDic)
                } else if (apiName == "login") && (aMethod == HTTPMethod.post) {
                    if let aUserID = aDic["userId"] {
                        LoginKey.shared.userID = String(describing: aUserID)
                        LoginKey.shared.userIDObs.accept(LoginKey.shared.userID)
                    }
                } else if (apiName == "categories-filter") && (aMethod == HTTPMethod.get) {
                    if let cities = aDic["cities"] {
                        if let castedCities = cities as? NSDictionary
                        {
                            NetworkManager.shared.cityDictionaryObs.accept(castedCities.toStringDictionary)
                        }
                    }
                    if let cat = aDic["categories"] {
                        NetworkManager.shared.catagoriesObs.accept([cat])
                    }
                } else if (apiName == "check-sms-code") && (aMethod == HTTPMethod.post) {
                    if let aToken = aDic["token"] {
                        LoginKey.shared.token = String(describing: aToken)
                        LoginKey.shared.username = String(describing: aDic["username"] )
                        LoginKey.shared.role = String(describing: aDic["role"] )
                        LoginKey.shared.tokenObs.accept(LoginKey.shared.token)
                        _ = LoginKey.shared.registerTokenAndUserID()
                    }
                } else if (apiName == "category-state-list") && (aMethod == HTTPMethod.get) {
                    var processedDic = Dictionary<String,String>()
                    (processedDic) = (self?.processAsProvinceList(Result: aDic))!
                    NetworkManager.shared.provinceDictionaryObs.accept(processedDic)
                }
                }, onDisposed: {
                    //print("Parser Disposed")
                }
            ).disposed(by: netObjectsDispose)
    }
    
    func processAsProvinceList(Result aResult : NSDictionary) -> (Dictionary<String,String>) {
        var provinceDict = Dictionary<String,String>()
        var provName : String
        if let aDic = aResult["states"] as? NSDictionary {
            for aProv in aDic
            {
                //print(aProv.key," ",aProv.value)
                if let aName = aProv.key as? String {provName = aName} else { print("Error in State data from Backend");continue}
                if let idx = aProv.value as? String {provinceDict[provName] = idx} else { print("Error in State data from Backend");continue}
                
            }
        } else {
            
        }
        print("Province Fetched : ",provinceDict.count," record")
        //print("Parsing State List Successful")

        return provinceDict
        
    }
    
    func processAsCityList(Result aResult : NSDictionary) -> (Dictionary<String,String>) {
        var cityDict = Dictionary<String,String>()
        var cityName : String
        if let aDic = aResult["cities"] as? NSDictionary {
            for aCity in aDic
            {
                if let aName = aCity.key as? String {cityName = aName} else { print("Parser : Error in City data from Backend");continue}
                if let idx = aCity.value as? String {cityDict[cityName] = idx} else { print("Parser : Error in City data from Backend");continue}
                //print("Adding : ",cityName)
            }
        } else {
            print("Parser : Result for cities is empty!")
        }
        print("City Fetched : ",cityDict.count," record")
        //print("Parsing City List Successful")
        return cityDict
        
    }

}
