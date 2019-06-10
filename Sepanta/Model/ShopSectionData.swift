//
//  ShopSectionData.swift
//  Sepanta
//
//  Created by Iman on 2/20/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionOfShopData : AnimatableSectionModelType{
    var identity: String {
        return header
    }
    
    typealias Identity = String
    
    var header: String
    var items: [Shop]
}

extension SectionOfShopData: SectionModelType {
    typealias Item = Shop
    typealias FilterFunction = (Shop) -> Bool
    typealias SortFunction = (Shop,Shop) -> Bool
    
    init(original: SectionOfShopData, items: [Shop]) {
        self = original
        self.items = items
    }
    /*
    init(original: SectionOfShopData, items: [Shop], filter : FilterFunction) {
        self = original
        self.items = items.filter({filter($0)})
    }
    
    init(original: SectionOfShopData, items: [Shop], sort : SortFunction) {
        self = original
        self.items = items.sorted(by: sort)
    }
     */
    init(original: SectionOfShopData, items: [Shop], sort : SortFunction, search : FilterFunction) {
        self = original
        self.items = items.filter({search($0)}).sorted(by: sort)
    }

}
