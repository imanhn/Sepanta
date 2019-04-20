//
//  Post.swift
//  Sepanta
//
//  Created by Iman on 1/8/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

protocol CollectionCell {
    var image : String? {get set}
}

protocol PostProtocol : CollectionCell {
    var id : Int? {get set}
    var shopId : Int? {get set}
    var viewCount : Int? {get set}
    var comments : [Comment]? {get set}
    var isLiked : Bool? {get set}
    var countLike : Int? {get set}
    var title : String? {get set}
    var content : String? {get set}
    var image : String? {get set}
}

struct Post : Decodable, Equatable,PostProtocol {
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
