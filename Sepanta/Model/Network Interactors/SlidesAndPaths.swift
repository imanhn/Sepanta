//
//  SlidesAndPaths.swift
//  Sepanta
//
//  Created by Iman on 12/20/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift

class SlidesAndPaths {
    var fetched : Bool = false
    var path_post_image : String = "/upload/post/"
    var path_profile_image : String = "/upload/profile/"
    var path_slider_image : String = "/upload/profile/"
    var path_category_image : String = "/upload/category/"
    var path_category_logo_map : String = "/upload/location/"
    var path_bank_logo_image : String = "/upload/logo_bank/"
    var path_banner_image : String = "/upload/banner/"
    var path_operator_image : String = "/upload/operator"
    var count_new_shop = BehaviorRelay<Int>(value: 0)
    var notifications_count = BehaviorRelay<Int>(value: 0)
    var slides = [Slide]()
    var slidesObs = BehaviorRelay<[Slide]>(value: [])
    
    static let shared = SlidesAndPaths()
    
    func getHomeData(){
        NetworkManager.shared.run(API: "home", QueryString: "?user_id=\(LoginKey.shared.userID)", Method: HTTPMethod.get, Parameters: nil, Header: nil,WithRetry: true)
    }

    func getNotifications(){
        NetworkManager.shared.run(API: "notifications", QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil,WithRetry: true)
    }

    private init() {
        self.getHomeData()
        self.getNotifications()
    }

}
