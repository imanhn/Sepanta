//
//  AppUpdateCheck.swift
//  Sepanta
//
//  Created by Iman on 8/6/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

struct AppUpdateCheck : Codable {
    var force_update : Bool?
    var optional_update : Bool?
    var link_app : String?
    var message : String?
    var status : String?
}
