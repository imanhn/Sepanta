//
//  CatagoryFilter.swift
//  Sepanta
//
//  Created by Iman on 5/7/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
struct CategoryFilter: Codable {
    var status: String?
    var message: String?
    var categories: [Categories]
}

struct Categories: Codable {
    var id: Int
    var title: String
    var image: String
}
