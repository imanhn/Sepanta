//
//  Comment.swift
//  Sepanta
//
//  Created by Iman on 1/20/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation

struct Comment : Decodable, Equatable {
    var id : Int?
    var username : String?
    var body : String?
}

/*
import RxDataSources
struct Comment : Decodable, Equatable,IdentifiableType {
    typealias Identity = Int
    var id : Int?
    var identity : Int { return self.id ?? 0}
    var username : String?
    var body : String?
}


struct SectionOfComments {
    var header: String
    var items: [Item]
}

extension SectionOfComments: SectionModelType,AnimatableSectionModelType {
    var identity: Int {
        return 1
    }
    
    typealias Identity = Int
    
    typealias Item = Comment
    
    init(original: SectionOfComments, items: [Item]) {
        self = original
        self.items = items
    }
}
 */
