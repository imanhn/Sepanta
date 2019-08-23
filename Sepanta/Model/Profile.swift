//
//  Profile.swift
//  Sepanta
//
//  Created by Iman on 12/19/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation

struct Profile: Codable {
    var status: String?
    var message: String?
    var id: Int?
    var image: String?
    var banner: String?
    var bio: String?
    var address: String?
    var total_points: Int?
    var shop_id: Int?
    var shop_name: String?
    var category_title: String?
    var rate: String?
    var rate_count: Int?
    var shop_off: Int?
    var url: String?
    var cellphone: String?
    var phone: String?
    var username: String?
    var fullName: String?
    var role: String?
    var reagent_code: String?
    var lat: Double?
    var lon: Double?
    var is_favorite: Bool?
    var is_follow: Bool?
    var follow_count: Int?
    var follower_count: Int?
    var content: [Shop] = [Shop]()
    var cards: [CreditCard] = [CreditCard]()

    private enum CodingKeys: String, CodingKey {
        case status
        case message
        case id
        case image
        case banner
        case bio
        case address
        case total_points
        case shop_id
        case shop_name
        case category_title
        case rate
        case rate_count
        case shop_off
        case url
        case cellphone
        case phone
        case username
        case fullName
        case role
        case reagent_code
        case lat
        case lon
        case is_favorite
        case is_follow
        case follow_count
        case follower_count
        case content
        case cards
    }
}
