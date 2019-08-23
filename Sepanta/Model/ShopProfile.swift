//
//  ShopProfile.swift
//  Sepanta
//
//  Created by Iman on 3/29/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

struct ShopProfile: Codable {
    var status: String?
    var message: String?
    var id: Int?
    var image: String?
    var banner: String?
    var bio: String?
    var address: String?
    var shop_id: Int?
    var shop_name: String?
    var total_points: Int?
    var category_title: String?
    var rate: String?
    var rate_count: Int?
    var shop_off: String?
    var url: String?
    var cellphone: String?
    var phone: String?
    var username: String?
    var fullName: String?
    var role: String?
    var lat: Double?
    var lon: Double?
    var is_favorite: Bool?
    var is_follow: Bool?
    var follow_count: Int?
    var follower_count: Int?
    var content: [Post] = [Post]()
    var cards: [CreditCard] = [CreditCard]()
}
