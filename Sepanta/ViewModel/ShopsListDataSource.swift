//
//  NewShopsDataSource.swift
//  Sepanta
//
//  Created by Iman on 12/19/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxAlamofire
import Alamofire
import AlamofireImage

class ShopsListDataSource {
    var delegate : UIViewController
    let myDisposeBag = DisposeBag()
    var fetchedShops = [Shop]()
    var shopProfiles = BehaviorRelay<[Profile]>(value: [])
    
    func updateFetchedShops(_ aProfileDicAsNS : NSDictionary){
        for i in 0..<fetchedShops.count {
            if aProfileDicAsNS["id"] != nil {
                if fetchedShops[i].user_id == aProfileDicAsNS["id"] as! Int {
                    fetchedShops[i].image = (aProfileDicAsNS["image"] as? String) ?? ""
                    fetchedShops[i].followers = (aProfileDicAsNS["follower_count"] as? Int) ?? 0
                    fetchedShops[i].dicount = (aProfileDicAsNS["shop_off"] as? Int) ?? 0
                }
            }
        }
        NetworkManager.shared.shopObs.accept(self.fetchedShops)
    }
    
    func getShopListForACatagory(Catagory catagoryID:String,State state : String?,City city:String?){
        var aParameter : Dictionary<String, String> = [:]
        if (state == nil || state == "") && (city == nil || city == "") {
           // "http://panel.ipsepanta.ir/api/v1/category-shops-list?slug=3&category_id=4"
            aParameter = ["slug":"3","category_id":"\(catagoryID)"]
        }
        if (state != nil && state != "" ) && (city == nil || city == "") {
            // "http://panel.ipsepanta.ir/api/v1/category-shops-list?slug=1&category_id=4&state_code=8"
            aParameter = ["slug":"1",
                          "category_id":"\(catagoryID)",
                          "state_code":"\(state!)"]
        }
        if (state != nil && state != "" ) && (city != nil && city != "") {
            // "http://panel.ipsepanta.ir/api/v1/category-shops-list?slug=2&category_id=4&city_code=1246"
            aParameter = ["slug":"1",
                          "category_id":"\(catagoryID)",
                "city_code":"\(city!)"]
        }

        print("Running network request category-shops-list... \(aParameter)  state : \(state!)  City : \(city!)")
        NetworkManager.shared.run(API: "category-shops-list", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil)
    }
    
    func getNewShopsFromServer(){
        NetworkManager.shared.run(API: "new-shops", QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil)
    }
    
    init (_ vc : UIViewController){
        self.delegate = vc
        //subscribeToShop()
    }
}
