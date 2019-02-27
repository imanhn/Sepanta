//
//  Shops.swift
//  Sepanta
//
//  Created by Iman on 12/8/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation

struct Shop : Decodable {
    let name : String
    let image : String
    let stars : Float
    let followers : Int
    let dicount : Int
}
