//
//  Slide.swift
//  Sepanta
//
//  Created by Iman on 12/20/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit

struct Slide: Codable {
    var id: Int?
    var user_id: Int?
    var shop_id: Int?
    var title: String?
    var link: String?
    var images: String?
    var aUIImage: UIImage?
    private enum CodingKeys: String, CodingKey { case id, user_id, shop_id, title, link, images }
}
