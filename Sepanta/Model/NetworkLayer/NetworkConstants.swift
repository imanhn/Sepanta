//
//  NetworkConstants.swift
//  Sepanta
//
//  Created by Iman on 3/29/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

struct NetworkConstants {
    
    //The API's base URL
    static let websiteRootAddress = "https://www.ipsepanta.ir"
    static let baseURLString = websiteRootAddress + "/api/v1"
    var aheaders = [
    "Accept": "application/json",
    "Content-Type":"application/x-www-form-urlencoded",
    "Authorization": "Bearer "+LoginKey.shared.token
    ]
    //The parameters (Queries) that we're gonna use
    struct Parameters {
        static let userId = "userId"
    }

    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    //The content type (JSON)
    enum ContentType: String {
        case json = "application/json"
    }
//    mutating func buildHeaders(){
//        headers["Authorization"] = "Bearer "+LoginKey.shared.token
//
//    }
}
