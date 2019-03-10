//
//  SlidesAndPaths.swift
//  Sepanta
//
//  Created by Iman on 12/20/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import Alamofire

class SlidesAndPaths {
    var fetched : Bool = false
    var path_post_image : String = "/upload/post/"
    var path_profile_image : String = "/upload/profile/"
    var path_slider_image : String = "/upload/profile/"
    var path_category_image : String = "/upload/category/"
    var path_bank_logo_image : String = "/upload/logo_bank/"
    var slides = [Slide]()    
    static let shared = SlidesAndPaths()
    
    private init() {
        if !fetched {
            print("Fetching Home Data : ")
            NetworkManager.shared.run(API: "home", QueryString: "?user_id=\(LoginKey.shared.userID)", Method: HTTPMethod.get, Parameters: nil, Header: nil)
        }else{
            print("Home data has already been fetched")
        }
    }

}
