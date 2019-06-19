//
//  UserPoints.swift
//  Sepanta
//
//  Created by Iman on 2/11/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

struct PointElement : Codable{
    var key : String?
    var total : Int?
}

struct UserPoints : Codable{
    var status : String?
    var message : String?
    var points_total : Int?
    var points : [PointElement]?
    init() {
    }
    
}
