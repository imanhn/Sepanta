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
        let imageUrl = NetworkManager.shared.websiteRootAddress + SlidesAndPaths.shared.path_category_image + self.image
        let imageURLCasted = URL(string: imageUrl)
        if imageURLCasted == nil
        {
            print("Catagory.swift : Wrong path for Catagory image : ",imageUrl)
            self.anUIImage.accept(UIImage(named: "logo_shape")!)
            return
        }
        let anImage = UIImage().getImageFromCache(ImageName : self.image)
        if anImage != nil {
            //print("Catagory Image cache used.")
            self.anUIImage.accept(anImage!)
            return
        }
        print("Lets Download Catagory Image from : ",imageUrl)
        Alamofire.request(imageUrl).responseImage { [weak self] response in
            if let image = response.result.value {
                //print("image downloaded: \(self.image)")
                self?.anUIImage.accept(image)
                let imageData = UIImageJPEGRepresentation(image,0.5) as NSData?
                if imageData != nil {
                    //print("Saving catagory image for future use : ",self.image)
                    if let afilename = self?.image{
                        CacheManager.shared.saveFile(Data:imageData!, Filename:afilename)
                    }
                }
            }
        }
         
    }
}
