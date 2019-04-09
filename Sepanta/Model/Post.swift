//
//  Post.swift
//  Sepanta
//
//  Created by Iman on 1/8/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

struct Post : Decodable, Equatable {
    var id : Int?
    var shopId : Int?
    var viewCount : Int?
    var comments : [Comment]?
    var isLiked : Bool?
    var countLike : Int?
    var title : String?
    var content : String?
    var image : String?

}
