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
import RxAlamofire

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
    
    init(Id anId : Int, Title aTitle : String, Image anImage : String) {
        super.init()
        self.id = anId
        self.title = aTitle
        self.image = anImage
        downloadImage()
    }
    
    func downloadImage() {
        var imageUrl = "http://www.panel.ipsepanta.ir/"+self.image
        
        //print("Default Image as placeholder so the subscribers work and GUI starts!")
        self.anUIImage.accept(UIImage(named: "icon_sepantaei")!)
        
        Alamofire.request(imageUrl).responseImage { [weak self] response in
            if let image = response.result.value {
                //print("image downloaded: \(image)")
                self?.anUIImage.accept(image)
            }
        }
         
    }
}
