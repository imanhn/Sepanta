//
//  ShopList.swift
//  Sepanta
//
//  Created by Iman on 5/8/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

struct ShopList : Codable{
    var status : String?
    var message : String?
    var shopList : [Shop]?
    var currentPage : Int?
    var lastPage : Int?
    var shops : [PaginatedShops]?
    var categoryShops : [PaginatedShops]?
    var favorite : [PaginatedShops]?
    
    enum CodingKeys : String,CodingKey{
        case status
        case message
        case shops
        case categoryShops
        case favorite
    }

    enum ShopsKeys : CodingKey{
        case current_page
        case data
        case last_page
    }

    init(from decoder : Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let categoryShopsValues = try values.nestedContainer(keyedBy: ShopsKeys.self, forKey: .categoryShops)
        //let favoriteValues = try values.nestedContainer(keyedBy: ShopsKeys.self, forKey: .favorite)
        //let shopsValues = try values.nestedContainer(keyedBy: ShopsKeys.self, forKey: .shops)
        do { status = try values.decodeIfPresent(String.self, forKey: .status)} catch { }
        do { message = try values.decodeIfPresent(String.self, forKey: .message)} catch { }
        do { shopList = try categoryShopsValues.decode([Shop].self, forKey: .data) } catch {}
/*
        do { lastPage = try categoryShopsValues.decode(Int.self, forKey: .last_page) } catch {
            do { lastPage = try favoriteValues.decode(Int.self, forKey: .last_page) }catch{
                do { lastPage = try shopsValues.decode(Int.self, forKey: .last_page) }catch{}
            }
        }
        
        do { currentPage = try categoryShopsValues.decode(Int.self, forKey: .current_page) } catch {
            do { currentPage = try favoriteValues.decode(Int.self, forKey: .current_page) }catch{
                do { currentPage = try shopsValues.decode(Int.self, forKey: .current_page) }catch{}
            }
        }*/
    }

}

struct PaginatedShops : Codable{
    var current_page : Int?
    var data : [Shop]?
    var first_page_url : String?
    var from : Int?
    var last_page : Int?
    var last_page_url : String?
    var next_page_url : String?
    var path : String?
    var per_page : String?
    var prev_page_url : String?
    var to : Int?
    var total : Int?
    
    enum ShopsKeys : CodingKey{
        case current_page
        case data
        case last_page
    }

}
