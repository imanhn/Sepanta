//
//  ShopsLocation.swift
//  Sepanta
//
//  Created by Iman on 5/7/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
struct ShopsLocation: Codable {
    var status: String?
    var message: String?
    var shops: [Shop]?
}
