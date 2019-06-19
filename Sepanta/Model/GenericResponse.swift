//
//  GenericResponse.swift
//  Sepanta
//
//  Created by Iman on 3/29/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

struct GenericNetworkResponse : Codable{
    var message : String?
    var error : String?
    var status : String?
}
