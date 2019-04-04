//
//  Post.swift
//  Sepanta
//
//  Created by Iman on 1/8/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import RxDataSources

struct Post : Decodable,IdentifiableType, Equatable {
    var id : Int
    var title : String
    var content : String
    var image : String
    var identity: Int {
        return id
    }
}
