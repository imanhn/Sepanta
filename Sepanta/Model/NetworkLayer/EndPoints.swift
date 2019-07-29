//
//  UserEndPoint.swift
//  Sepanta
//
//  Created by Iman on 3/29/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class Endpoints<T:Codable> {
    let api : String
    let method: HTTPMethod
    let parameters: APIParameters
    private var response : Observable<T>

    init(API api : String,
         Method method: HTTPMethod = HTTPMethod.get,
         Parameters parameters: APIParameters? = [:],
         Retry retry : Int = 3,
         Timeout timeout : Double = 10) {
        self.api = api
        self.method = method
        self.parameters = parameters ?? [:]
        self.response = ApiClient().request(API: api, aMethod: method, Parameter: self.parameters, Retry : retry ,Timeout : timeout)
    }
    
    func results()->Observable<T>{
        return response
    }
}

final class getProfileInfo : Endpoints<Profile>{
    init(){
        super.init(API: "profile", Method: HTTPMethod.post, Parameters: ["user id":LoginKey.shared.userID], Retry: 3, Timeout: 10)
    }
}

final class checkBank : Endpoints<Bank>{
    init(SixDigitPrefix prefix:String){
        super.init(API: "check-bank", Method: HTTPMethod.post, Parameters: ["card_number":prefix], Retry: 3, Timeout: 10)
    }
}

final class checkMobile : Endpoints<Mobile>{
    init(MobileNumberPrefix prefix:String){
        super.init(API: "mobile-operators", Method: HTTPMethod.post, Parameters: ["code":prefix], Retry: 3, Timeout: 10)
    }
}

final class getNotifications : Endpoints<Notifications>{
    init(Page page:Int){
        super.init(API: "notifications", Method: HTTPMethod.post, Parameters: ["page":"\(page)"], Retry: 3, Timeout: 10)
    }
}

final class getHomeData : Endpoints<HomeData>{
    init(){
        super.init(API: "home", Method: HTTPMethod.get, Parameters: nil, Retry: 3, Timeout: 10)
    }
}

final class getAllCategories : Endpoints<CategoryFilter>{
    init(){
        super.init(API: "categories-filter", Method: HTTPMethod.get, Parameters: nil, Retry: 3, Timeout: 10)
    }
}

final class getStateCategories : Endpoints<CategoryFilter>{
    init(StateCode stateCode : String){
        super.init(API: "categories-filter", Method: HTTPMethod.get, Parameters: ["state_code":stateCode], Retry: 3, Timeout: 10)
    }
}

final class getCityCategories : Endpoints<CategoryFilter>{
    init(CityCode cityCode : String){
        super.init(API: "categories-filter", Method: HTTPMethod.get, Parameters: ["city_code":cityCode], Retry: 3, Timeout: 10)
    }
}

final class setRate : Endpoints<Rate>{
    init(Rate rate : Int,ShopID shopid : Int){
        super.init(API: "rating", Method: HTTPMethod.post, Parameters: ["rate":rate,"shop_id":"\(shopid)"], Retry: 3, Timeout: 10)
    }
}
