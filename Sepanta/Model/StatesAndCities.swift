//
//  StatesAndCities.swift
//  Sepanta
//
//  Created by Iman on 8/6/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

struct States : Codable {
    var status : String?
    var message : String?
    var states : [String:Int]?
    
    func getState(FromCode aCode : Int) -> String {
        guard (states != nil) else {return ""}
        for aState in self.states! where (aState.value == aCode) {
            return aState.key
        }
        return ""
    }
    
    func getState(FromName aName : String) -> Int {
        guard (states != nil) else {return 0}
        for aState in self.states! where (aState.key == aName){
            return aState.value
        }
        return 0
    }

}


struct Cities : Codable {
    var status : String?
    var message : String?
    var state : [String:Int]?
    
    func getCity(FromCode aCode : Int) -> String {
        guard (state != nil) else {return ""}
        for aState in self.state! where (aState.value == aCode) {
            return aState.key
        }
        return ""
    }
    
    func getCity(FromName aName : String) -> Int {
        guard (state != nil) else {return 0}
        for aState in self.state! where (aState.key == aName){
            return aState.value
        }
        return 0
    }
    
}


