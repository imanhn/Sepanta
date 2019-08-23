//
//  NSDictionaryToDictionary.swift
//  Sepanta
//
//  Created by Iman on 12/7/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
extension NSDictionary {
    func toDictionary()->Dictionary<String, String> {
        var swiftDictionary = Dictionary<String, String>()

        for key: Any in self.allKeys {
            let stringKey = key as! String
            if let keyValue = self.value(forKey: stringKey) {
                swiftDictionary[stringKey] = "\(keyValue)"
            }
        }

        return swiftDictionary
    }

    var toStringDictionary: Dictionary<String, String> {
        var swiftDictionary = Dictionary<String, String>()

        for key: Any in self.allKeys {
            let stringKey = key as! String
            if let keyValue = self.value(forKey: stringKey) {
                swiftDictionary[stringKey] = "\(keyValue)"
            }
        }

        return swiftDictionary
    }
}
/*
protocol StringProtocol {}
extension String: StringProtocol {}

extension Dictionary where Key : StringProtocol, Value : StringProtocol{
    func getSortedKeys() {
    }
    
}*/
