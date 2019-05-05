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
    

    func getShopListForACatagory(Catagory catagoryID:String,State state : String?,City city:String?){
        var aParameter : Dictionary<String, String> = [:]
        if (state == nil || state == "") && (city == nil || city == "") {
           // "http://www.ipsepanta.ir/api/v1/category-shops-list?slug=3&category_id=4"
            aParameter = ["slug":"3","category_id":"\(catagoryID)"]
        }
        if (state != nil && state != "" ) && (city == nil || city == "") {
            // "http://www.ipsepanta.ir/api/v1/category-shops-list?slug=1&category_id=4&state_code=8"
            aParameter = ["slug":"1",
                          "category_id":"\(catagoryID)",
                          "code":"\(state!)"]
        }
        if (state != nil && state != "" ) && (city != nil && city != "") {
            // "http://www.ipsepanta.ir/api/v1/category-shops-list?slug=2&category_id=4&city_code=1246"
            aParameter = ["slug":"2",
                          "category_id":"\(catagoryID)",
                "code":"\(city!)"]
        }

        print("Running network request category-shops-list... \(aParameter)  state : \(state!)  City : \(city!)")
        NetworkManager.shared.run(API: "category-shops-list", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil,WithRetry: true)
    }
    
    func getFavShopsFromServer(){
        NetworkManager.shared.run(API: "favorite", QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil,WithRetry: true)
    }
    
    func getNewShopsFromServer(){
        NetworkManager.shared.run(API: "new-shops", QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil,WithRetry: true)
    }
    
    func getMyFollowingFromServer(){
        NetworkManager.shared.run(API: "my-following", QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil,WithRetry: true)
    }
    
    init (_ vc : UIViewController){
        self.delegate = vc
        //subscribeToShop()
    }
}
