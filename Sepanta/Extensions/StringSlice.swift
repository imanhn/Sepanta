//
//  StringSlice.swift
//  Sepanta
//
//  Created by Iman on 2/10/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

extension String {
    func slice(From from : Int , To to : Int)->String{
        var result : String = ""
        var i = 0
        for aChar in self {
            if i >= from && i <= to {
                result = result + "\(aChar)"
            }
            i = i + 1
        }
        return result
    }
}
