//
//  JSONParser.swift
//  Sepanta
//
//  Created by Iman on 11/25/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift
import RxCocoa

class JSONParser {
    
    // MARK: - Properties
    
    var netObjectsDispose = DisposeBag()
    var resultSubject = BehaviorRelay<NSDictionary>(value : NSDictionary())
//    var result : JSON
    init(API apiName : String) {
       // self.result = JSON()
        resultSubject.asObservable()
            //.debug()
            .filter{ $0.count > 0 }
            .subscribe(onNext: { [weak self] (aDic) in
                print("Dictionary Received : ",aDic.count)
                if apiName == "get-state-and-city"{
                    var processedDic = Dictionary<String,String>()
                    var processedlist = [String]()
                 //(NetworkManager.shared.provinceDictionary,NetworkManager.shared.provinceList) = (self?.processAsProvinceList(Result: aDic))!
                    (processedDic,processedlist) = (self?.processAsProvinceList(Result: aDic))!
                    NetworkManager.shared.provinceDictionaryObs.accept(processedDic)
                    NetworkManager.shared.provinceListObs.accept(processedlist)
                }
                }, onDisposed: {
                    print("Parser Disposed")
                }
            ).disposed(by: netObjectsDispose)
    }
    func processAsProvinceList(Result aResult : NSDictionary) -> (Dictionary<String,String>,[String]) {
        var provinceDict = Dictionary<String,String>()
        var provinceList = [String]()
        var provName : String
        if let aDic = aResult["states"] as? NSDictionary {
            for aProv in aDic
            {
                //print(aProv.key," ",aProv.value)
                if let aName = aProv.key as? String {provName = aName} else { print("Error in State data from Backend");continue}
                if let idx = aProv.value as? String {provinceDict[provName] = idx} else { print("Error in State data from Backend");continue}
                provinceList.append(provName)
            }
        } else {
            
        }
        print("Fetched : ",provinceList.count," record")
        print("Parsing State List Successful")

        return (provinceDict,provinceList)
        
    }
    
}
