//
//  Shops.swift
//  Sepanta
//
//  Created by Iman on 12/8/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxDataSources

protocol ShopOrPost : Codable{
    var shop_id : Int? {get set}
    var image : String? {get set}
}

struct Shop : ShopOrPost,IdentifiableType,Equatable,Codable {
    static func == (lhs: Shop, rhs: Shop) -> Bool {
        if lhs.identity == rhs.identity { return true }else{return false}
    }
    
    var shop_id : Int?
    var user_id : Int?
    var shop_name : String?
    var shop_off : Int?
    var lat : Double?
    var long : Double?
    var image : String?
    var rate : String?
    var rate_count : Int?
    var follower_count : Int?
    var created_at : String?
    var identity: Int {
        return shop_id ?? 0
    }
    
    mutating func updateFromProfile(Profile aprofile : ShopProfile){
        user_id = aprofile.id
        shop_id = aprofile.shop_id
        shop_off = aprofile.shop_off
        image = aprofile.image
        lat = aprofile.lat
        long = aprofile.long
        rate = aprofile.rate
        rate_count = aprofile.rate_count
        shop_name = aprofile.shop_name
        follower_count = aprofile.follower_count
    }
    init(){
        
    }
    
    init(WithUserID auserId : Int?){
        self.init()
        self.user_id = auserId
    }
    
    init(WithShopID ashopid : Int?){
        self.init()
        self.shop_id = ashopid
    }
    
    init(shop_id: Int? = 0, user_id: Int? = 0, shop_name: String? = "", shop_off: Int? = 0 , lat: Double? = 0.0, long: Double? = 0.0, image: String? = "", rate: String? = "", rate_count: Int? = 0, follower_count: Int? = 0, created_at: String? = ""){
        self.shop_id = shop_id
        self.user_id = user_id
        self.shop_name = shop_name
        self.shop_off = shop_off
        self.lat = lat
        self.long = long
        self.image = image
        self.rate = rate
        self.rate_count = rate_count
        self.follower_count = follower_count
        self.created_at = created_at
    }
}
