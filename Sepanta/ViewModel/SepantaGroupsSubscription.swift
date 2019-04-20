//
//  SepantaGroupsObserverSubscription.swift
//  Sepanta
//
//  Created by Iman on 1/17/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Alamofire
import RxAlamofire


extension SepantaGroupsViewController {
    
    func subscribeToUpdateCategories(){
        self.currentStateCodeObs
            .filter({$0 != ""})
            .subscribe(onNext: { (innerCurrentState) in
                let aParameter : Dictionary<String,String> = [
                    "state code" : innerCurrentState
                ]
                self.fetchCatagories(aParameter)
            }).disposed(by: myDisposeBag)
        
        self.currentCityCodeObs
            .filter({$0 != ""})
            .subscribe(onNext: {  (innerCurrentCity) in
                let aParameter : Dictionary<String, String> = [
                    "city_code": innerCurrentCity
                ]
                self.fetchCatagories(aParameter)
            }).disposed(by: myDisposeBag)
        
        NetworkManager.shared.catagoriesObs
            //.filter({$0.count > 0})
            .subscribe(onNext: { [unowned self] (innerCatagories) in
                if innerCatagories.count > 0 {
                    self.groupButtons = SepantaGroupButtons(self)
                    let catagories = innerCatagories[0] as! NSArray
                    self.catagories = [Catagory]()
                    for i in 0..<catagories.count {
                        let catDic = catagories[i] as! NSDictionary
                        if
                            let anId = catDic.value(forKey: "id") as? Int,
                            let aTitle = catDic.value(forKey: "title") as? String,
                            let anImage = catDic.value(forKey: "image") as? String
                        {
                            let newCatagory = Catagory(Id: anId, Title: aTitle, Image: anImage)
                            self.catagories.append(newCatagory)
                        }
                    }
                    if (self.catagories.count) > 0 {Spinner.start()}
                    self.groupButtons?.counter = 0
                    self.groupButtons?.buttons = [UIButton]()
                    for aSubView in (self.sepantaScrollView.subviews){
                        aSubView.removeFromSuperview()
                    }
                    //print("Total Catagory Loaded : ",self?.catagories.count)
                    self.groupButtons?.createGroups(Catagories: self.catagories)
                    Spinner.stop()
                }
            }).disposed(by: myDisposeBag)

    }
    
    func subscribeToStateChange() {
        NetworkManager.shared.provinceDictionaryObs
            //.debug()
            .filter({$0.count > 0})
            .subscribe(onNext: { [weak self] (innerProvinceDicObs) in
                print("innerProvinceDicObs : ",innerProvinceDicObs.count)
                let controller = ArrayChoiceTableViewController(innerProvinceDicObs.keys.sorted(){$0 < $1}) {
                    (selectedProvinceStr) in
                    self?.selectProvince.text = selectedProvinceStr
                    self?.selectCity.text = ""
                    self?.currentStateCodeObs.accept(innerProvinceDicObs[selectedProvinceStr]!)
                }
                controller.preferredContentSize = CGSize(width: 250, height: innerProvinceDicObs.count*60)
                Spinner.stop()
                self?.showPopup(controller, sourceView: (self?.selectProvince!)!)
                }).disposed(by: myDisposeBag)

    }
    
    func fetchCatagories(_ parameters : Dictionary<String,String>?){
        var aMethod = HTTPMethod.get
        if parameters != nil { aMethod = HTTPMethod.post}
        NetworkManager.shared.run(API: "categories-filter",QueryString: "", Method: aMethod, Parameters: parameters, Header: nil,WithRetry: true)
    }
    

}
