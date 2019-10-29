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

class Endpoints<T: Codable> {
    let api: String
    let method: HTTPMethod
    let parameters: APIParameters
    private var response: Observable<T>

    init(API api: String,
         Method method: HTTPMethod = HTTPMethod.get,
         Parameters parameters: APIParameters? = [:],
         Retry retry: Int = 3,
         Timeout timeout: Double = 10) {
        self.api = api
        self.method = method
        self.parameters = parameters ?? [:]
        self.response = ApiClient().request(API: api, aMethod: method, Parameter: self.parameters, Retry: retry, Timeout: timeout)
    }

    func results()->Observable<T> {
        return response
    }
}

final class GetStates: Endpoints<States> {
    init() {
        super.init(API: "get-state-and-city", Method: HTTPMethod.get, Parameters: nil, Retry: 3, Timeout: 10)
    }
}

final class GetCities: Endpoints<Cities> {
    init(StateCode aStateCode : String) {
        super.init(API: "get-state-and-city", Method: HTTPMethod.post, Parameters: ["state code" : aStateCode], Retry: 3, Timeout: 10)
    }
}

final class GetProfileOfUser: Endpoints<ProfileOfUser> {
    init() {
        super.init(API: "profile", Method: HTTPMethod.post, Parameters: ["user id": LoginKey.shared.userID], Retry: 3, Timeout: 10)
    }
}

final class GetProfileOfShop: Endpoints<ProfileOfShop> {
    init() {
        super.init(API: "profile", Method: HTTPMethod.post, Parameters: ["user id": LoginKey.shared.userID], Retry: 3, Timeout: 10)
    }
}

final class CheckBank: Endpoints<Bank> {
    init(SixDigitPrefix prefix: String) {
        super.init(API: "check-bank", Method: HTTPMethod.post, Parameters: ["card_number": prefix], Retry: 3, Timeout: 10)
    }
}

final class checkMobile: Endpoints<Mobile> {
    init(MobileNumberPrefix prefix: String) {
        super.init(API: "mobile-operators", Method: HTTPMethod.post, Parameters: ["code": prefix], Retry: 3, Timeout: 10)
    }
}

final class getNotifications: Endpoints<Notifications> {
    init(Page page: Int) {
        super.init(API: "notifications", Method: HTTPMethod.post, Parameters: ["page": "\(page)"], Retry: 3, Timeout: 10)
    }
}

final class getHomeData: Endpoints<HomeData> {
    init() {
        super.init(API: "home", Method: HTTPMethod.get, Parameters: nil, Retry: 3, Timeout: 10)
    }
}

final class getAllCategories: Endpoints<CategoryFilter> {
    init() {
        super.init(API: "categories-filter", Method: HTTPMethod.get, Parameters: nil, Retry: 3, Timeout: 10)
    }
}

final class getStateCategories: Endpoints<CategoryFilter> {
    init(StateCode stateCode: String) {
        super.init(API: "categories-filter", Method: HTTPMethod.get, Parameters: ["state_code": stateCode], Retry: 3, Timeout: 10)
    }
}

final class getCityCategories: Endpoints<CategoryFilter> {
    init(CityCode cityCode: String) {
        super.init(API: "categories-filter", Method: HTTPMethod.get, Parameters: ["city_code": cityCode], Retry: 3, Timeout: 10)
    }
}

final class setRate: Endpoints<Rate> {
    init(Rate rate: Int, ShopID shopid: Int) {
        super.init(API: "rating", Method: HTTPMethod.post, Parameters: ["rate": rate, "shop_id": "\(shopid)"], Retry: 3, Timeout: 10)
    }
}

final class getProfileInfo: Endpoints<ProfileInfo> {
    init() {
        super.init(API: "profile-info", Method: HTTPMethod.get, Parameters: nil, Retry: 3, Timeout: 10)
    }
}

final class setProfileInfo: Endpoints<ProfileInfo> {
    init(ProfileInfo aprofileInfo: ProfileInfo) {
        super.init(API: "profile-info", Method: HTTPMethod.post, Parameters: aprofileInfo.encodeToDictionary(), Retry: 3, Timeout: 10)
    }
}

final class getFavoriteList: Endpoints<FavoriteList> {
    init() {
        super.init(API: "favorite", Method: HTTPMethod.get, Parameters: nil, Retry: 3, Timeout: 10)
    }
}

final class toggleFavorite: Endpoints<MakeFavorite> {
    init(ShopId: String) {
        super.init(API: "favorite", Method: HTTPMethod.post, Parameters: ["shop_id": ShopId], Retry: 3, Timeout: 10)
    }
}

final class toggleFollow: Endpoints<Follow> {
    init(ShopId: String) {
        super.init(API: "follow-unfollow-request", Method: HTTPMethod.post, Parameters: ["shop id": ShopId], Retry: 3, Timeout: 10)
    }
}

final class getShopsLocation: Endpoints<ShopsLocation> {
    init(lat: Double, long: Double) {
        super.init(API: "shops-location", Method: HTTPMethod.post, Parameters: ["lat": lat, "long": long], Retry: 3, Timeout: 10)
    }
}

final class sendContactUs: Endpoints<Contact> {
    init(title: String, body: String) {
        super.init(API: "contact", Method: HTTPMethod.post, Parameters: ["title": title, "body": body], Retry: 3, Timeout: 10)
    }
}

final class GetLastCard: Endpoints<LastCard> {
    init() {
        super.init(API: "last-card", Method: HTTPMethod.get, Parameters: nil, Retry: 3, Timeout: 10)
    }
}

final class GetPointsScore: Endpoints<UserPoints> {
    init() {
        super.init(API: "points-user", Method: HTTPMethod.get, Parameters: nil, Retry: 3, Timeout: 10)
    }
}

final class getPostDetails: Endpoints<Post> {
    init(PostID: Int) {
        super.init(API: "post-details", Method: HTTPMethod.post, Parameters: ["post_id": PostID], Retry: 3, Timeout: 10)
    }
}

final class reportComment: Endpoints<GenericNetworkResponse> {
    init(CommentID: Int, Description: String) {
        super.init(API: "report-comment", Method: HTTPMethod.post, Parameters: ["comment_id": CommentID, "description": Description], Retry: 1, Timeout: 10)
    }
}

final class reportPost: Endpoints<GenericNetworkResponse> {
    init(PostID: Int, Description: String) {
        super.init(API: "report-post", Method: HTTPMethod.post, Parameters: ["post_id": PostID, "description": Description], Retry: 1, Timeout: 10)
    }
}

final class GetPaymentGatewayList: Endpoints<PaymentGatewayList> {
    init() {
        super.init(API: "payment-port-list", Method: HTTPMethod.get, Parameters: nil, Retry: 3, Timeout: 10)
    }
}

final class GetBankLink: Endpoints<BankLink> {
    init(serverLink: String,discountCode: String, cardId : String) {
        let bankName = serverLink.split(separator: "/")
        if bankName.count > 0 {
            super.init(API: String(bankName.last!), Method: HTTPMethod.post, Parameters: ["discount_code": discountCode, "card_id": cardId], Retry: 1, Timeout: 10)
        } else {
            super.init(API: "parsian" , Method: HTTPMethod.post, Parameters: ["discount_code": discountCode, "card_id": cardId], Retry: 1, Timeout: 10)
        }
    }
}

final class CardRequest: Endpoints<CardRequestResponse> {
    init(Parameter aParam : [String : String]) {
        super.init(API: "card-request", Method: HTTPMethod.post, Parameters: aParam, Retry: 1, Timeout: 10)
    }
}

final class DeleteCard: Endpoints<GenericNetworkResponse> {
    init(CardID cardId : String) {
        super.init(API: "delete-card", Method: HTTPMethod.post, Parameters: ["card_id" : cardId], Retry: 1, Timeout: 10)
    }
}

final class AppVersionCheck: Endpoints<AppUpdateCheck> {
    init(Parameter aParam : [String : String]) {
        super.init(API: "check-version", Method: HTTPMethod.post, Parameters: aParam, Retry: 3, Timeout: 10)
    }
}

final class CheckOffCode: Endpoints<OffCode> {
    init(OffCode anOffCode : String,CardId cardId : String) {
        super.init(API: "is-valid-code", Method: HTTPMethod.post, Parameters: ["code":anOffCode,"card_id":cardId], Retry: 1, Timeout: 10)
    }
}

final class getCatagoryShops: Endpoints<ShopList> {

    init(CategoryID: Int) {
        // Slug = 3 for the whole country
        super.init(API: "category-shops-list", Method: HTTPMethod.post, Parameters: ["category_id": "\(CategoryID)", "slug": "3"], Retry: 3, Timeout: 10)
    }

    init(CategoryID: Int, Slug: Int, Code: Int) {
        // For both City and State this is the method
        // Slug = 2 for City and code should by city code
        // Slug = 1 for State and code should be state code
        super.init(API: "category-shops-list", Method: HTTPMethod.post, Parameters: ["category_id": "\(CategoryID)", "slug": "\(Slug)", "code": "\(Code)"], Retry: 3, Timeout: 10)
    }

}
