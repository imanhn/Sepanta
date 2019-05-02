//
//  Notifications.swift
//  Sepanta
//
//  Created by Iman on 2/1/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

struct NotificationForUser {
    var post_id : Int?
    var user_id : Int?
    var created_at : String?
    var shop_name : String?
    var shop_image : String?
    var post_image : String?
    var body : String?
}

struct NotificationForShop {
    var post_id : Int?
    var user_id : Int?
    var created_at : String?
    var first_name : String?
    var last_name : String?
    var image : String?
    var username : String?
    var comment : String?
}


struct GeneralNotification {
    var title : String?
    var body : String?
    var image : String?
}
