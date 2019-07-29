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
    var id : Int? //Virtual field just make Decoder work for Network response that return id instead of shop_id (shop in [Content] of Profile
    var shop_id : Int?
    var user_id : Int?
    var shop_name : String?
    var shop_off : String?
    var lat : Double?
    var lon : Double?
    var image : String?
    var rate : String?
    var rate_count : Int?
    var follower_count : Int?
    var created_at : String?
    var shop_logo_map : String?
    var identity: Int {
        return shop_id ?? user_id ?? 0
    }
    
    mutating func updateFromProfile(Profile aprofile : ShopProfile){
        user_id = aprofile.id
        shop_id = aprofile.shop_id
        shop_off = aprofile.shop_off
        image = aprofile.image
        lat = aprofile.lat
        lon = aprofile.lon
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
    
    init(shop_id: Int? = 0, user_id: Int? = 0, shop_name: String? = "", shop_off: String? = "0" , lat: Double? = 0.0, lon: Double? = 0.0, image: String? = "", rate: String? = "", rate_count: Int? = 0, follower_count: Int? = 0, created_at: String? = ""){
        self.shop_id = shop_id
        self.user_id = user_id
        self.shop_name = shop_name
        self.shop_off = shop_off
        self.lat = lat
        self.lon = lon
        self.image = image
        self.rate = rate
        self.rate_count = rate_count
        self.follower_count = follower_count
        self.created_at = created_at
    }
    
    init(from decoder : Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            shop_id = try values.decode(Int.self, forKey: .id)
            id = shop_id
        }catch{
            if (shop_id == nil) {
                do {
                    shop_id = try values.decode(Int.self, forKey: .shop_id)
                    id = shop_id
                }catch{
                    print("id or shop_id not found while decoding!")
                    fatalError()
                }
                
            }
        }
        if values.contains(.user_id) {
            do{
                user_id = try values.decode(Int.self, forKey: .user_id)
            }catch{
                print("Decoder Error : user_id can not be casted")
                fatalError()
            }
        }
        if values.contains(.shop_name) {
            do{
                shop_name = try values.decode(String.self, forKey: .shop_name)
            }catch{
                print("Decoder Error : shop_name can not be casted")
                fatalError()
            }
        }
        if values.contains(.shop_off) {
            do{
                shop_off = try values.decode(String.self, forKey: .shop_off)
            }catch{
                do {
                    shop_off = try "\(values.decode(Float.self, forKey: .shop_off))"
                }catch{
                    print("Decoder Error 2nd Try Float->String: shop_off can not be casted")
                    fatalError()
                }
            }
        }
        if values.contains(.rate) {
            do{
                rate = try values.decode(String.self, forKey: .rate)
            }catch{
                print("Decoder Error 1st String->String: rate can not be casted")
                do {
                    rate = try "\(values.decode(Float.self, forKey: .rate))"
                }catch{
                    print("Decoder Error 2st Float->String: rate can not be casted")
                    fatalError()
                }
                
            }
        }
        if values.contains(.rate_count) {
            do{
                rate_count = try values.decode(Int.self, forKey: .rate_count)
            }catch{
                print("Decoder Error 1st Int->String: rate_count can not be casted")
                fatalError()
            }
        }
        if values.contains(.follower_count) {
            do{
                follower_count = try values.decode(Int.self, forKey: .follower_count)
            }catch{
                print("Decoder Error 1st Int->String: follower_count can not be casted")
                fatalError()
            }
        }
        if values.contains(.created_at) {
            do{
                created_at = try values.decode(String.self, forKey: .created_at)
            }catch{
                print("Decoder Error 1st String->String: created_at can not be casted")
                fatalError()
            }
        }
        if values.contains(.shop_logo_map) {
            do{
                shop_logo_map  = try values.decode(String.self, forKey: .shop_logo_map)
            }catch{
                print("Decoder Error 1st String->String: shop_logo_map can not be casted")
                fatalError()
            }
        }
        if values.contains(.image) {
            do{
                image  = try values.decode(String.self, forKey: .image)
            }catch{
                print("Decoder Error 1st String->String: image can not be casted")
                fatalError()
            }
        }

        if values.contains(.lat) {
            do {
                lat = try values.decode(String.self, forKey: .lat).toDouble()
            }catch{
                //print("Decoder Error 1st Try String->Double : Lat can not be casted")
            }
            if (lat == nil) {
                do {
                    lat = try values.decode(Double.self, forKey: .lat)
                }catch{
                    print("Decoder Error 2nd Try Double->Double : Lat can not be casted")
                    fatalError()
                }
            }
        }
        if values.contains(.lon) {
            do {
                lon = try values.decode(String.self, forKey: .lon).toDouble()
            }catch{
                //print("Decoder Error 1st Try String->Double : Lat can not be casted")
            }
            if (lon == nil) {
                do {
                    lon = try values.decode(Double.self, forKey: .lon)
                }catch{
                    print("Decoder Error 2nd Try Double->Double : Lat can not be casted")
                    fatalError()
                }
            }
        }
    }
    
    private enum CodingKeys : String, CodingKey {
        case id
        case shop_id
        case user_id
        case shop_name
        case shop_off
        case lat
        case lon
        case image
        case rate
        case rate_count
        case follower_count
        case created_at
        case shop_logo_map
        
    }
}

extension Array where Element:ShopOrPost{
    func add(newShops : [Shop])->[Shop]{
        var ashop = self as! [Shop]
        newShops.forEach({
            if !self.map({$0.shop_id}).contains($0.shop_id) {ashop.append($0)}
        })
        return ashop
    }
}
