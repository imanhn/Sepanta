//
//  Post.swift
//  Sepanta
//
//  Created by Iman on 1/8/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

struct Post : Decodable {
    var id : Int
    var title : String
    var content : String
    var image : String
}
