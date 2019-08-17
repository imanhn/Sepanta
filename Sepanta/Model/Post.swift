//
//  Post.swift
//  Sepanta
//
//  Created by Iman on 1/8/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

struct Post : ShopOrPost, Codable, Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return (lhs.id == rhs.id)
    }
    var status : String?
    var message : String?

    var id : Int?
    var shop_id: Int?
    var image: String?
    var title: String?
    var content : String?
    var is_like : Int?
    var count_like : String?
    var postDetail : PostDetail?
    var comments : [Comment]?
    init(){
    }
    enum CodingKeys: String, CodingKey {
        case id
        case shop_id
        case image
        case status
        case message
        case is_like
        case count_like
        case postDetail
        case comments
    }
    
    enum PostDetailKeys: CodingKey {
        case id
        case shop_id
        case title
        case content
        case image
        case likeCount
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let postDetailValues = try values.nestedContainer(keyedBy: PostDetailKeys.self, forKey: .postDetail)

        comments = try values.decode([Comment].self, forKey: .comments)
        postDetail = try values.decode(PostDetail.self, forKey: .postDetail)

        id = try postDetailValues.decode(Int.self, forKey: .id)
        shop_id = try postDetailValues.decode(Int.self, forKey: .shop_id)
        image = try postDetailValues.decode(String.self, forKey: .image)
        title = try postDetailValues.decode(String.self, forKey: .title)
        content = try postDetailValues.decode(String.self, forKey: .content)

        status = try values.decode(String.self, forKey: .status)
        message = try values.decode(String.self, forKey: .message)
        is_like = try values.decode(Int.self, forKey: .is_like)
        count_like = try values.decode(String.self, forKey: .count_like)
        
    }
}


struct PostDetail : Codable {
    var id : Int?
    var shop_id: Int?
    var title : String?
    var content : String?
    var image : String?
    var likeCount : String?
    
    enum PostDetailKeys: CodingKey {
        case id
        case shop_id
        case title
        case content
        case image
        case likeCount
    }
}
