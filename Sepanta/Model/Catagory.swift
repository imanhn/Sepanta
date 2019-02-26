//
//  Catagory.swift
//  Sepanta
//
//  Created by Iman on 12/7/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage


class Catagory : NSObject {
    var content = String()
    var banner = String()
    var created_at = String()
    var updated_at = String()
    var image = String()
    var title = String()
    var id = Int()
    var shop_number = Int()
    var anUIImage : BehaviorRelay<UIImage> = BehaviorRelay(value: UIImage())
    var myDisposeBag = DisposeBag()
    
    override init () {
        super.init()
    }
    
    init(Content acontent : String, Id anId : Int, ShopNumber aShopNumber : Int, Title aTitle : String, Image anImage : String) {
        self.content = acontent
        self.id = anId
        self.shop_number = aShopNumber
        self.title = aTitle
        self.image = anImage
    }
    
    func downloadImage(imageSuffix : String) {
        let imageUrl = "http://www.favecard.ir/"+imageSuffix
        Alamofire.request(imageUrl).responseImage { [weak self] response in
            debugPrint(response)
            print(response.request)
            print(response.response)
            debugPrint(response.result)
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                self?.anUIImage.accept(image)
            }
        }
    }
}
