//
//  Slide.swift
//  Sepanta
//
//  Created by Iman on 12/20/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation

struct Slide : Decodable {
    var id : Int
    var title : String
    var link : String
    var user_id : Int
    var images : String
}
