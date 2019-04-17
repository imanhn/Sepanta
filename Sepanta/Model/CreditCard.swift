//
//  CreditCard.swift
//  Sepanta
//
//  Created by Iman on 1/25/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

struct CreditCard : Decodable {
    var id : Int?
    var first_name : String?
    var last_name : String?
    var card_number : String?
    var status : Int?
    var bank_name : String?
    var bank_logo : String?
}
