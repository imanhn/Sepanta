//
//  EnglishNumbersToPersian.swift
//  Sepanta
//
//  Created by Iman on 12/9/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
extension String {
    func toPersianNumbers()->String{
        var result : String = ""
        for aChar in self {
            switch aChar {
            case "1" : result = result + "۱";break
            case "2" : result = result + "۲";break
            case "3" : result = result + "۳";break
            case "4" : result = result + "۴";break
            case "5" : result = result + "۵";break
            case "6" : result = result + "۶";break
            case "7" : result = result + "۷";break
            case "8" : result = result + "۸";break
            case "9" : result = result + "۹";break
            case "0" : result = result + "۰";break
            default:
                result = result + "\(aChar)"
            }
        }
        return result
    }
}
