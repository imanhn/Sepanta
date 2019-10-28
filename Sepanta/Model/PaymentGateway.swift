//
//  PaymentGateway.swift
//  Sepanta
//
//  Created by Iman on 8/5/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

struct PaymentGatewayList : Codable {
    var status : String?
    var message : String?
    var sepanta_card : Int?
    var other_cards : Int?
    var link : [PaymentGateway]?
}

struct PaymentGateway : Codable {
    var logo : String?
    var name : String?
    var link : String?
    var status : Int?
}

struct BankLink : Codable {
    var status : String?
    var message : String?
    var link_bank : String?
}
