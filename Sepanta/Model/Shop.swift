//
//  Shops.swift
//  Sepanta
//
//  Created by Iman on 12/8/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

protocol ShopProtocol : CollectionCell{
    var shop_id : Int? {get set}
    var user_id : Int? {get set}
    var shop_name : String? {get set}
    var shop_off : Int? {get set}
    var lat : Double? {get set}
    var long : Double? {get set}
//    var image : String? {get set}
    var rate : String? {get set}
    var follower_count : Int? {get set}
    var created_at : String? {get set}
}

struct Shop : ShopProtocol {
    var shop_id : Int?
    var user_id : Int?
    var shop_name : String?
    var shop_off : Int?
    var lat : Double?
    var long : Double?
    var image : String?
    var rate : String?
    var follower_count : Int?
    var created_at : String?
    
    mutating func updateFromProfile(Profile aprofile : Profile){
        user_id = aprofile.id
        shop_id = aprofile.shop_id
        shop_off = aprofile.shop_off
        image = aprofile.image
        lat = aprofile.lat
        long = aprofile.long
        rate = aprofile.rate
        shop_name = aprofile.shop_name
        follower_count = aprofile.follower_count
    }
}
