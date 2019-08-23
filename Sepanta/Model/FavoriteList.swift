//
//  FavoriteList.swift
//  Sepanta
//
//  Created by Iman on 5/7/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

struct FavoriteList: Codable {
    var message: String?
    var status: String?
    var favorite: [Shop]?
}

struct MakeFavorite: Codable {
    var message: String?
    var status: String?
    var isFave: String?
}
