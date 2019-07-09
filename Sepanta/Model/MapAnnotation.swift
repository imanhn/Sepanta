//
//  ArtworkMap.swift
//  Sepanta
//
//  Created by Iman on 2/3/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import MapKit
import Alamofire

class MapAnnotation : NSObject,MKAnnotation{
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 35.765985, longitude: 51.546742)
    var identifier = "MapAnnotation"
    var title: String?
    var subtitle: String?
    var userId: Int?
    var shop : Shop?
    var logo_map : String?
    var logo_map_image : UIImage?
    init(WithShop aShop : Shop){
        super.init()
        self.title = aShop.shop_name ?? "بدون نام"
        self.subtitle = aShop.shop_name ?? "بدون نام"
        self.userId = aShop.user_id ?? 0
        self.shop = aShop
        self.logo_map = aShop.shop_logo_map
        self.coordinate = CLLocationCoordinate2D(latitude: aShop.lat ?? 35.765985, longitude: aShop.long ?? 51.546742)
        load_image()
        //print("NEW : ",self.coordinate,"  ",self.title)
    }
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D, identifier : String?) {
        super.init()
        self.userId = 0
        self.title = title
        self.subtitle = locationName
        self.coordinate = coordinate
        self.identifier = identifier ?? "MapAnnotation"
    }
    
    func load_image(){
        guard self.logo_map != nil else {return}
        let imageUrl = NetworkManager.shared.websiteRootAddress + SlidesAndPaths.shared.path_category_logo_map + self.logo_map!
        Alamofire.request(imageUrl).responseImage { [weak self] response in
            if let image = response.result.value {
                //print("image downloaded: \(self.image)")
                self?.logo_map_image = image
                let imageData = UIImageJPEGRepresentation(image,0.5) as NSData?
                if imageData != nil {
                    //print("Saving catagory image for future use : ",self.image)
                    CacheManager.shared.saveFile(Data:imageData!, Filename:(self?.logo_map!)!)
                }
            }
        }
    }
}
