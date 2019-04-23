//
//  ArtworkMap.swift
//  Sepanta
//
//  Created by Iman on 2/3/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import MapKit

class MapAnnotation : NSObject,MKAnnotation{
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 35.765985, longitude: 51.546742)
    var title: String?
    var subtitle: String?
    var userId: Int?
    init(WithShop aShop : Shop){
        super.init()
        self.title = aShop.shop_name ?? "بدون نام"
        self.subtitle = aShop.shop_name ?? "بدون نام"
        self.userId = aShop.user_id ?? 0
        self.coordinate = CLLocationCoordinate2D(latitude: aShop.lat ?? 35.765985, longitude: aShop.long ?? 51.546742)
        //print("NEW : ",self.coordinate,"  ",self.title)
    }
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        super.init()
        self.userId = 0
        self.title = title
        self.subtitle = locationName
        self.coordinate = coordinate
    }
}
