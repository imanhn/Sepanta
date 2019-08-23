//
//  Notifications.swift
//  Sepanta
//
//  Created by Iman on 2/1/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
struct Notifications: Codable {
    var status: String?
    var message: String?
    var notifications_user: NotificationUser?
    var notifications_manager: [GeneralNotification]?
    init() {
    }
}
// Added to cover pagination system
struct NotificationUser: Codable {
    var current_page: Int?
    var data: [NotificationForUser]
    var from: Int?
    var last_page: Int?
    var last_page_url: String?
    var next_page_url: String?
    var path: String?
    var per_page: Int?
    var prev_page_url: String?
    var to: Int?
    var total: Int?

}
// Changed to cover new notification system
struct NotificationForUser: Codable {
    var item_id: Int?
    var post_id: Int?
    var user_id: Int?
    var shop_id: Int?
    var status: Int?
    var shop_name: String?
    var shop_image: String?
    var post_image: String?
    var created_at: String?
}
// FIXME : not tested yet-need a shop account
struct NotificationForShop: Codable {
    var item_id: Int?
    var post_id: Int?
    var user_id: Int?
    var shop_id: Int?
    var created_at: String?
    var first_name: String?
    var last_name: String?
    var image: String?
    var username: String?
    var comment: String?
}

//
struct GeneralNotification: Codable {
    var title: String?
    var body: String?
    var image: String?
}
