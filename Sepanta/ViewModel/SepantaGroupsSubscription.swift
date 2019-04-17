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
    func registerProvinceChangeListener() {
        NetworkManager.shared.provinceDictionaryObs
            //.debug()
            .filter({$0.count > 0})
            .subscribe(onNext: { [weak self] (innerProvinceDicObs) in
                print("innerProvinceDicObs : ",innerProvinceDicObs.count)
                let controller = ArrayChoiceTableViewController(innerProvinceDicObs.keys.sorted(){$0 < $1}) {
                    (type) in self?.provinceModel.type = type
                    self?.selectCity.text = ""
                    //print("Catagory State Code : ",innerProvinceDicObs[type]!)
                    self?.currentStateCodeObs.accept(innerProvinceDicObs[type]!)
                }
                controller.preferredContentSize = CGSize(width: 250, height: innerProvinceDicObs.count*60)
                Spinner.stop()
                //print("Setting controller")
                self?.showPopup(controller, sourceView: (self?.selectProvince!)!)
                //NetworkManager.shared.provinceDictionaryObs = BehaviorRelay<Dictionary<String,String>>(value: Dictionary<String,String>())
                }, onError: { _ in
                    print("Province Call Raised Error")
                    Spinner.stop()
            }, onCompleted: {
                print("Province Call Completed")
            }, onDisposed: {
                print("Province Disposed")
            }).disposed(by: myDisposeBag)
        
        Observable.combineLatest(self.cityPressed, NetworkManager.shared.cityDictionaryObs, resultSelector: { [unowned self] (innercityPressed,innerCityDicObs) in
            //print("COMBINE : ",innercityPressed,innerCityDicObs)
            if innercityPressed == true {
                let controller = ArrayChoiceTableViewController(innerCityDicObs.keys.sorted(){$0 < $1}) {
                    (type) in self.cityModel.type = type
                    //print("City Code : ",innerCityDicObs[type]!)
                    self.currentCityCodeObs.accept(innerCityDicObs[type]!)
                }
                controller.preferredContentSize = CGSize(width: 250, height: 300)
                Spinner.stop()
                self.showPopup(controller, sourceView: (self.selectCity)!)
                //self.cityPressed.accept(false)
            }
        }).observeOn(MainScheduler.instance)
            .subscribe()
            .disposed(by: myDisposeBag)
        
        self.currentStateCodeObs
            .filter({$0 != ""})
            .subscribe(onNext: { (innerCurrentState) in
                //NetworkManager.shared.cityDictionaryObs = BehaviorRelay<Dictionary<String,String>>(value: Dictionary<String,String>())
                let aParameter : Dictionary<String,String> = [
                    "state code" : innerCurrentState
                ]
                let queryString = "?state code=\(innerCurrentState)"
                //NetworkManager.shared.run(API: "get-state-and-city",QueryString: queryString, Method: HTTPMethod.post, Parameters: aParameter, Header: nil)
                NetworkManager.shared.run(API: "categories-filter",QueryString: queryString, Method: HTTPMethod.post, Parameters: aParameter, Header: nil,WithRetry: true)
                //print("Registered and listended : ",innerCurrentState)
            }, onError: { _ in
                print("Error in listening to province in Sepanta groups")
                
            }, onCompleted: {
                
            }, onDisposed: {
                
            }).disposed(by: myDisposeBag)
        
        self.currentCityCodeObs
            .filter({$0 != ""})
            .subscribe(onNext: {  (innerCurrentCity) in
                //NetworkManager.shared.cityDictionaryObs = BehaviorRelay<Dictionary<String,String>>(value: Dictionary<String,String>())
                let aParameter : Dictionary<String, String> = [
                    "city_code": innerCurrentCity
                ]
                let queryString = "?city_code=\(innerCurrentCity)"
                NetworkManager.shared.run(API: "categories-filter",QueryString: queryString, Method: HTTPMethod.post, Parameters: aParameter, Header: nil,WithRetry: true)
                //print("Registered and listended : ",innerCurrentCity)
            }, onError: { _ in
                print("Error in listening to province in Sepanta groups")
                
            }, onCompleted: {
                
            }, onDisposed: {
                
            }).disposed(by: myDisposeBag)
        
        NetworkManager.shared.catagoriesObs
            //.filter({$0.count > 0})
            .subscribe(onNext: { [unowned self] (innerCatagories) in
                if innerCatagories.count > 0 {
                    self.groupButtons = SepantaGroupButtons(self)
                    //print("innerCatagories : ",innerCatagories,"  ",innerCatagories.count)
                    //var relayCollection = [BehaviorRelay<UIImageView>]()
                    let catagories = innerCatagories[0] as! NSArray
                    self.catagories = [Catagory]()
                    for i in 0..<catagories.count {
                        let catDic = catagories[i] as! NSDictionary
                        //print(catDic)
                        if
                            //                        let aContent = catDic.value(forKey: "content") as? String,
                            let anId = catDic.value(forKey: "id") as? Int,
                            //                        let aShopsNumber = catDic.value(forKey: "shops_number") as? Int,
                            let aTitle = catDic.value(forKey: "title") as? String,
                            let anImage = catDic.value(forKey: "image") as? String
                        {
                            let newCatagory = Catagory(Id: anId, Title: aTitle, Image: anImage)
                            //relayCollection.append(newCatagory.anUIImage)
                            //print("ADDING CAT ",newCatagory)
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
                    /*
                     Observable.combineLatest(relayCollection)
                     .subscribe({ innerRelayCol in
                     print("Hello : ",innerRelayCol)
                     })
                     */
                    
                }
                
                }, onError: { _ in
                    
            }, onCompleted: {
                
            }, onDisposed: {
                
            }).disposed(by: myDisposeBag)
    }
    
    func fetchAllCatagories(){
        NetworkManager.shared.run(API: "categories-filter",QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil,WithRetry: true)
    }
}