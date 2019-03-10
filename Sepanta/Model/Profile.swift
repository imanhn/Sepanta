//
//  Profile.swift
//  Sepanta
//
//  Created by Iman on 12/19/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation

struct Post : Decodable {
    var title : String
    var content : String
    var image : String
}
struct CreditCard : Decodable {
    
}

struct Profile : Decodable {
    var status : String
    var message : String
    var id : Int
    var image : String
    var address : String
    var shop_id : Int
    var shop_name : String
    var shop_off: String
    var cellphone : String
    var phone : String
    var username : String
    var fullName : String
    var role : String
    var lat : Double
    var long : Double
    var is_favorite : String
    var is_follow : String
    var follow_count : Int
    var follower_count : Int
    var content : [Post]
    var cards : [CreditCard]
}
