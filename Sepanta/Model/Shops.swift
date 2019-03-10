//
//  Shops.swift
//  Sepanta
//
//  Created by Iman on 12/8/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation

struct Shop : Decodable {
    let user_id : Int
    var name : String
    var image : String
    var stars : Float
    var followers : Int
    var dicount : Int
}
