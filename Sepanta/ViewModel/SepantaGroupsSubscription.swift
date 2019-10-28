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

    func subscribeToUpdateCategories() {

        let stateDisp = self.currentStateCodeObs
            .filter({$0 != ""})
            .subscribe(onNext: { (innerCurrentState) in
                let aParameter: [String:String] = [
                    "state_code": innerCurrentState,
                    "city_code": ""
                ]
                self.fetchCatagories(aParameter)
            })
        stateDisp.disposed(by: myDisposeBag)
        disposableArray.append(stateDisp)

        let cityDisp = self.currentCityCodeObs
            .filter({$0 != ""})
            .subscribe(onNext: {  (innerCurrentCity) in
                let aParameter: [String:String] = [
                    "city_code": innerCurrentCity,
                    "state_code": "",
                ]
                self.fetchCatagories(aParameter)
            })
        cityDisp.disposed(by: myDisposeBag)
        disposableArray.append(cityDisp)

        let catDisp = NetworkManager.shared.catagoriesObs
            //.filter({$0.count > 0})
            .subscribe(onNext: { [unowned self] (innerCatagories) in
                if !innerCatagories.isEmpty {
                    self.groupButtons = SepantaGroupButtons(self)
                    let catagories = innerCatagories[0] as! NSArray
                    self.catagories = [Catagory]()
                    for i in 0..<catagories.count {
                        let catDic = catagories[i] as! NSDictionary
                        if
                            let anId = catDic.value(forKey: "id") as? Int,
                            let aTitle = catDic.value(forKey: "title") as? String,
                            let anImage = catDic.value(forKey: "image") as? String,
                            let numOfShops = catDic.value(forKey: "shops_count") as? Int
                        {
                            let newCatagory = Catagory(Id: anId, Title: aTitle,ShopCount: numOfShops, Image: anImage)
                            self.catagories.append(newCatagory)
                        }
                    }
                    if (self.catagories.count) > 0 {Spinner.start()}
                    self.groupButtons?.counter = 0
                    self.groupButtons?.buttons = [UIButton]()
                    for aSubView in (self.sepantaScrollView.subviews) {
                        aSubView.removeFromSuperview()
                    }
                    //print("Total Catagory Loaded : ",self?.catagories.count)
                    self.groupButtons?.createGroups(Catagories: self.catagories)
                    Spinner.stop()
                }
            })
        catDisp.disposed(by: myDisposeBag)
        disposableArray.append(catDisp)

    }

    func subscribeToStateChange() {
        let provDisp = NetworkManager.shared.catagoriesProvinceListObs
            //.debug()
            .filter({!$0.isEmpty})
            .subscribe(onNext: { [unowned self] (innerCatProvinceListObs) in
                print("innerCatProvinceListObs : ", innerCatProvinceListObs.count)
                let filteredList = innerCatProvinceListObs.filter({$0.count > 1})
                let controller = ArrayChoiceTableViewController(filteredList) { (selectedOption) in
                    self.selectProvince.text = selectedOption
                    self.selectedStateStr = selectedOption
                    self.selectedCityStr = nil
                    self.selectCity.text = ""
                    self.currentStateCodeObs.accept("\(innerCatProvinceListObs.index(of: selectedOption) ?? 0)")
                }
                controller.preferredContentSize = CGSize(width: 250, height: filteredList.count*60)
                Spinner.stop()
                self.showPopup(controller, sourceView: self.selectProvince!)
                })
        provDisp.disposed(by: myDisposeBag)
        disposableArray.append(provDisp)

    }

    func fetchCatagories(_ parameters: [String:String]?) {
        var aMethod = HTTPMethod.get
        if parameters != nil { aMethod = HTTPMethod.post}
        NetworkManager.shared.run(API: "categories-filter", QueryString: "", Method: aMethod, Parameters: parameters, Header: nil, WithRetry: true)
    }

}
