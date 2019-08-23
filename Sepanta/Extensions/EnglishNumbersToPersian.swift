//
//  EnglishNumbersToPersian.swift
//  Sepanta
//
//  Created by Iman on 12/9/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
extension String {

    func CRC() -> String {
        let serverK = "ک"
        let iosK = "ك"
        let serverY  = "ی"
        let iosY = "ي"
        return self.replacingOccurrences(of: iosK, with: serverK).replacingOccurrences(of: iosY, with: serverY)
    }

    func toDouble() -> Double {
        var result: String = "0"
        var filtered = ""
        for aChar in self {
            switch aChar {
            case "۱" : result += "1"
            case "۲" : result += "2"
            case "۳" : result += "3"
            case "۴" : result += "4"
            case "۵" : result += "5"
            case "۶" : result += "6"
            case "۷" : result += "7"
            case "۸" : result += "8"
            case "۹" : result += "9"
            case "۰" : result += "0"
            case "1" : result += "1"
            case "2" : result += "2"
            case "3" : result += "3"
            case "4" : result += "4"
            case "5" : result += "5"
            case "6" : result += "6"
            case "7" : result += "7"
            case "8" : result += "8"
            case "9" : result += "9"
            case "0" : result += "0"
            case "." : result += "."
            default:
                //print("Filtered >\(aChar)<")
                filtered += "\(aChar)"
            }
        }
        return Double(result)!
    }
    func toPersianNumbers() -> String {
        var result: String = ""
        var filtered = ""
        for aChar in self {
            switch aChar {
            case "1" : result += "۱"
            case "2" : result += "۲"
            case "3" : result += "۳"
            case "4" : result += "۴"
            case "5" : result += "۵"
            case "6" : result += "۶"
            case "7" : result += "۷"
            case "8" : result += "۸"
            case "9" : result += "۹"
            case "0" : result += "۰"
            default:
                //print("Filtered >\(aChar)<")
                filtered += "\(aChar)"
            }
        }
        return result
    }

    func toEnglishNumbers() -> String {
        var filtered = ""
        var result: String = ""
        for aChar in self {
            switch aChar {
            case "۱" : result += "1"
            case "۲" : result += "2"
            case "۳" : result += "3"
            case "۴" : result += "4"
            case "۵" : result += "5"
            case "۶" : result += "6"
            case "۷" : result += "7"
            case "۸" : result += "8"
            case "۹" : result += "9"
            case "۰" : result += "0"
            case "1" : result += "1"
            case "2" : result += "2"
            case "3" : result += "3"
            case "4" : result += "4"
            case "5" : result += "5"
            case "6" : result += "6"
            case "7" : result += "7"
            case "8" : result += "8"
            case "9" : result += "9"
            case "0" : result += "0"
            case "." : result += "."
            default:
                //print("Filtered >\(aChar)<")
                filtered += "\(aChar)"
            }
        }
        return result
    }
    func containPersianChar() -> Bool {
        let persianChars = "چجحخهعغفقثصضکگمنتالبیسشوپدذرزطظًٌٍَُِّْةآأإيئؤكٓژٰ‌ٔء"
        for aChar in self {
            if persianChars.contains(aChar) {return true }
        }
        return false
    }

    func containSymbol() -> Bool {
        let symbolChars = "§±!@#$%^&*()_+}{|:?>.,/;'\"\\ "
        for aChar in self {
            if symbolChars.contains(aChar) {return true }
        }
        return false
    }

}
