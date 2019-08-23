//
//  HomeData.swift
//  Sepanta
//
//  Created by Iman on 5/7/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
struct HomeData: Codable {
    var status: String?
    var message: String?
    var path_post_image: String?
    var path_profile_image: String?
    var path_slider_image: String?
    var path_category_image: String?
    var path_category_logo_map: String?
    var path_bank_logo_image: String?
    var path_banner_image: String?
    var path_operator_image: String?
    var notifications_count: Int?
    var count_new_shop: Int?
    var sliders: [Slide]?
}
