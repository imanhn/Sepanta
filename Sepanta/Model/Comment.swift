//
//  Comment.swift
//  Sepanta
//
//  Created by Iman on 1/20/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

struct Comment : Decodable, Equatable {
    var id : Int?
    var userID : Int?
    var comment : String?
}
