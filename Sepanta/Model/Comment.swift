//
//  Comment.swift
//  Sepanta
//
//  Created by Iman on 1/20/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

struct Comment : Decodable, Equatable {
    var comment_id : Int?
    var body : String?
    var username : String?
    var user_id : Int?
    var first_name : String?
    var last_name : String?
    var image : String?
}


