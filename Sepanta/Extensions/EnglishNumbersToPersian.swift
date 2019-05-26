//
//  EnglishNumbersToPersian.swift
//  Sepanta
//
//  Created by Iman on 12/9/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
extension String {
    
    func CRC()->String{
        let serverK = "ک"
        let iosK = "ك"
        let serverY  = "ی"
        let iosY = "ي"
        return self.replacingOccurrences(of: iosK, with: serverK).replacingOccurrences(of: iosY, with: serverY)
    }
    
    func toDouble()->Double{
        var result : String = "0"
        var filtered = ""
        for aChar in self {
            switch aChar {
            case "۱" : result = result + "1";break
            case "۲" : result = result + "2";break
            case "۳" : result = result + "3";break
            case "۴" : result = result + "4";break
            case "۵" : result = result + "5";break
            case "۶" : result = result + "6";break
            case "۷" : result = result + "7";break
            case "۸" : result = result + "8";break
            case "۹" : result = result + "9";break
            case "۰" : result = result + "0";break
            case "1" : result = result + "1";break
            case "2" : result = result + "2";break
            case "3" : result = result + "3";break
            case "4" : result = result + "4";break
            case "5" : result = result + "5";break
            case "6" : result = result + "6";break
            case "7" : result = result + "7";break
            case "8" : result = result + "8";break
            case "9" : result = result + "9";break
            case "0" : result = result + "0";break
            case "." : result = result + ".";break
            default:
                //print("Filtered >\(aChar)<")
                filtered = filtered + "\(aChar)"
            }
        }
        return Double(result)!
    }
    func toPersianNumbers()->String{
        var result : String = ""
        var filtered = ""
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
                //print("Filtered >\(aChar)<")
                filtered = filtered + "\(aChar)"
            }
        }
        return result
    }
    
    func toEnglishNumbers()->String{
        var filtered = ""
        var result : String = ""
        for aChar in self {
            switch aChar {
            case "۱" : result = result + "1";break
            case "۲" : result = result + "2";break
            case "۳" : result = result + "3";break
            case "۴" : result = result + "4";break
            case "۵" : result = result + "5";break
            case "۶" : result = result + "6";break
            case "۷" : result = result + "7";break
            case "۸" : result = result + "8";break
            case "۹" : result = result + "9";break
            case "۰" : result = result + "0";break
            case "1" : result = result + "1";break
            case "2" : result = result + "2";break
            case "3" : result = result + "3";break
            case "4" : result = result + "4";break
            case "5" : result = result + "5";break
            case "6" : result = result + "6";break
            case "7" : result = result + "7";break
            case "8" : result = result + "8";break
            case "9" : result = result + "9";break
            case "0" : result = result + "0";break
            case "." : result = result + ".";break
            default:
                //print("Filtered >\(aChar)<")
                filtered = filtered + "\(aChar)"
            }
        }
        return result
    }
    func containPersianChar()->Bool{
        let persianChars = "چجحخهعغفقثصضکگمنتالبیسشوپدذرزطظًٌٍَُِّْةآأإيئؤكٓژٰ‌ٔء"
        for aChar in self {
            if persianChars.contains(aChar) {return true }
        }
        return false
    }
    
    func containSymbol()->Bool{
        let symbolChars = "§±!@#$%^&*()_+}{|:?>.,/;'\"\\ "
        for aChar in self {
            if symbolChars.contains(aChar) {return true }
        }
        return false
    }

}
