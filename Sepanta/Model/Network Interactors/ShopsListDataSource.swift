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
    var delegate : ShopListOwners
    var page = 1
    var last_page : Int!
    let myDisposeBag = DisposeBag()
    var API : String!
    var METHOD : HTTPMethod!
    var PARAMETERS : Dictionary<String,String>!
    var isFetching = false
    
    func buildParameters(Catagory catagoryID:String,State state : String?,City city:String?)->Dictionary<String,String>{
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
        return aParameter
    }
    
    func fetchNextPage(){
        self.page = self.page + 1
        self.getShops(Api : API,Method : METHOD ,Parameters : PARAMETERS)
    }
    
    func getShops(Api apiName : String,Method amethod : HTTPMethod,Parameters param : Dictionary<String,String>?){
        let urlAddress = NetworkManager.shared.baseURLString + "/" + apiName
        self.API = apiName
        self.PARAMETERS = param
        self.METHOD = amethod
        var pagedParam = param ?? [:]
        pagedParam["page"] = "\(self.page)"
        print("URLAddress : ",urlAddress)
        print("*** Getting shops : ",pagedParam)
        RxAlamofire.requestJSON(amethod, urlAddress , parameters: pagedParam, encoding: URLEncoding.httpBody, headers: NetworkManager.shared.headers)
            //.observeOn(MainScheduler.instance)
            .timeout(3, scheduler: MainScheduler.instance)
            .retry(4)
            .subscribe(onNext: { [unowned self] (ahttpURLRes,jsonResult) in
                print(" \(apiName) Response Code : ",ahttpURLRes.statusCode)
                if let aresult = jsonResult as? NSDictionary {
                    let shops = self.processShopList(Result: aresult)
                    /*
                    var shops = [Shop]()
                    let ashop = self.processShopList(Result: aresult).first!
                    let idx = self.delegate.shopsObs.value.count
                    for i in (idx+1)..<(idx+20){
                        var newshop = ashop
                        newshop.shop_id = i
                        newshop.user_id = i
                        shops.append(newshop)
                    }
                    */
                    if self.page > 1 {
                        let unionShops = self.delegate.shopsObs.value.add(newShops: shops)
                        print("Union shops : ",unionShops.count)
                        self.delegate.shopsObs.accept(unionShops)
                    }else{
                        self.delegate.shopsObs.accept(shops)
                    }
                    if ahttpURLRes.statusCode >= 400 {
                        print("Result All Key : ",aresult.allKeys)
                        print("Error : ",aresult["error"] ?? "[Error happened but no Error Key in response!]")
                        if let amessage = aresult["message"] as? String {
                            print("Setting : ",amessage)
                        }
                    }
                }
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
            }, onCompleted: {
                //print("NetWorkManager Completed")
                Spinner.stop()
            }, onDisposed: {
                Spinner.stop()
                //print("NetworkManager Disposed")
            }).disposed(by: myDisposeBag)
    }
    
    func processShopList(Result aResult : NSDictionary) -> [Shop] {
        var shops = [Shop]()
        if aResult["error"] != nil {
            print("ERROR in Shop List Parsing : ",aResult["error"]!)
        }
        if aResult["message"] != nil {
            print("Message Parsed : ",aResult["message"]!)
        }
        
        //print("Shop Result keys : ",aResult.allKeys)
        //print("Result : ",aResult)
        
        if let aDic = aResult["shops"] as? NSDictionary ?? aResult["categoryShops"] as? NSDictionary ?? aResult["favorite"] as? NSDictionary{
            if let lastPage = aDic["last_page"] as? Int {
                print("Setting Last page : ",lastPage)
                self.last_page = lastPage
            }
            if let dataOfShops = aDic["data"] as? NSArray {
                for shopDic in dataOfShops
                {
                    //print("a Shop****")
                    if let shopElemAsNSDic = shopDic as? NSDictionary{
                        
                        if let shopElem = shopElemAsNSDic as? Dictionary<String, Any>{
                            //print("shopElem : ",shopElem)
                            if shopElem["user_id"] != nil && shopElem["shop_id"] != nil {
                                let aNewShop = Shop(shop_id: shopElem["shop_id"] as? Int ?? 0,
                                                    user_id: shopElem["user_id"] as? Int ?? 0,
                                                    shop_name: shopElem["shop_name"] as? String ?? "",
                                                    shop_off: shopElem["shop_off"] as? Int ?? 0,
                                                    lat: (shopElem["lat"] as? String)?.toDouble() ?? 0.0,
                                                    long: (shopElem["lon"] as? String)?.toDouble() ?? 0.0,
                                                    image: shopElem["image"] as? String ?? "",
                                                    rate: shopElem["rate"] as? String ?? "" ,
                                                    rate_count: shopElem["rate_count"] as? Int ?? 0 ,
                                                    follower_count: shopElem["follower_count"] as? Int ?? 0,
                                                    created_at: shopElem["created_at"] as? String ?? "")
                                shops.append(aNewShop)
                                print("SHOP : ",aNewShop)
                            }
                        }
                    }else{
                        print("shopElm not casted.")
                    }
                }
            } else{
                print("aresult[shops or categoryShops][data] is empty or can not be casted")
            }
        }else if let dataOfShops = aResult["shops"] as? NSArray ?? aResult["categoryShops"] as? NSArray ?? aResult["favorite"] as? NSArray{
            for shopDic in dataOfShops
            {
                if let shopElemAsNSDic = shopDic as? NSDictionary{
                    
                    if let shopElem = shopElemAsNSDic as? Dictionary<String, Any>{
                        //print("shopElem : ",shopElem)
                        if shopElem["user_id"] != nil && shopElem["shop_id"] != nil {
                            let aNewShop = Shop(shop_id: shopElem["shop_id"] as? Int ?? 0,
                                                user_id: shopElem["user_id"] as? Int ?? 0,
                                                shop_name: shopElem["shop_name"] as? String ?? "",
                                                shop_off: shopElem["shop_off"] as? Int ?? 0,
                                                lat: (shopElem["lat"] as? String)?.toDouble() ?? 0.0,
                                                long: (shopElem["lon"] as? String)?.toDouble() ?? 0.0,
                                                image: shopElem["image"] as? String ?? "",
                                                rate: shopElem["rate"] as? String ?? "" ,
                                                rate_count: shopElem["rate_count"] as? Int ?? 0 ,
                                                follower_count: shopElem["follower_count"] as? Int ?? 0,
                                                created_at: shopElem["created_at"] as? String ?? "")
                            shops.append(aNewShop)
                        }
                    }
                }else{
                    print("shopElm not casted.")
                }
            }
        }else {
            print("Couldnt cast Result[shops] or [categoryShops] ")
            print("Shop Result keys : ",aResult.allKeys)
            print("aResult[categoryShops] ",aResult["categoryShops"] ?? "EMPTY")
        }
        print("Shops Fetched : ",shops.count," record")
        //print("Parsing State List Successful")
        
        return shops
        
    }
    init (_ vc : ShopListOwners){
        self.delegate = vc
        //subscribeToShop()
    }
}
