//
//  CacheImageForViews.swift
//  Sepanta
//
//  Created by Iman on 12/21/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

extension UIImage {
    func getImageFromCache(ImageName imageName : String )->UIImage? {
        var cachedData : NSData?
        if imageName.count > 0
        {
            cachedData = CacheManager.shared.readFile(Filename:imageName)
            if cachedData != nil {
                //print("Image is already cached ")
                let cachedImage = UIImage(data: cachedData! as Data)
                return cachedImage
            }
        }
        return nil
    }
}

extension UIImageView {
    
    func setImageFromCache(PlaceHolderName defaultImageName : String, Scale aScale : CGFloat,ImageURL imageUrl : URL,ImageName imageName : String,ContentMode acontentMode : UIViewContentMode = UIViewContentMode.scaleAspectFit ){
        let defaultImage = UIImage(named: defaultImageName)
        self.contentMode = acontentMode
        
        let imageSize = CGSize(width: self.frame.size.width*aScale, height: self.frame.size.height*aScale)
        let filter = AspectScaledToFillSizeFilter(size: imageSize)//AspectScaledToFitSizeFilter(size: imageSize)
        self.image = defaultImage
        
        var cachedData : NSData?
        if imageName.count > 0
        {
            cachedData = CacheManager.shared.readFile(Filename:imageName)
            if cachedData != nil {
               // print("Image is already cached ")
                let cachedImage = UIImage(data: cachedData! as Data)
                self.image = cachedImage
                
            }else{
                //print("Downloading....")
                self.af_setImage(withURL: imageUrl, placeholderImage: defaultImage, filter: filter,completion:
                    { (response) in
                        //print("Image Downloaded,Saving...")
                        // UIImage(data: response.data!)!
                        if let downloadedImage = self.image {
                            let imageData = UIImageJPEGRepresentation(downloadedImage, 0.5) as NSData?
                            if imageData != nil {
                                //print("   Saving \(imageName)")
                                CacheManager.shared.saveFile(Data:imageData!, Filename:imageName)
                            }
                        }else{
                            //print("AFImage finished downloading but no image yielded!")
                        }

                })
            }
        }
    }
}

extension UIButton {
    
    func setImageFromCache(PlaceHolderName defaultImageName : String, Scale aScale : CGFloat,ImageURL imageUrl : URL,ImageName imageName : String,ContentMode acontentMode : UIViewContentMode = UIViewContentMode.scaleAspectFit  ){
        let defaultImage = UIImage(named: defaultImageName)
        
        self.contentMode = acontentMode
        let imageSize = CGSize(width: self.frame.size.width*aScale, height: self.frame.size.height*aScale)
        let filter = AspectScaledToFitSizeFilter(size: imageSize)
        self.setImage(defaultImage, for: .normal)
        
        //let imageUrl = URL(string: NetworkManager.shared.websiteRootAddress+SlidesAndPaths.shared.path_profile_image+imageName)!
        //print("SetFrom Cache : ",imageUrl)
        var cachedData : NSData?
        if imageName.count > 0
        {
            cachedData = CacheManager.shared.readFile(Filename:imageName)
            if cachedData != nil {
                //print("Image is already cached ")
                let cachedImage = UIImage(data: cachedData! as Data)
               // print("    Cached Image from Data is : ",cachedImage)
                self.setImage(cachedImage, for: .normal)
            }else{
               // print("Downloading....")
                self.af_setImage(for: .normal, url: imageUrl, placeholderImage: defaultImage, filter: filter, completion: { (response) in
                    //print("Image Downloaded : ",self.image(for: .normal))
                    let downloadedImage = self.image(for: .normal)// UIImage(data: response.data!)!
                    if downloadedImage != nil {
                        let imageData = UIImageJPEGRepresentation(downloadedImage!, 0.8) as NSData?
                        if imageData != nil {
                           // print("   Saving \(imageName)")
                            CacheManager.shared.saveFile(Data:imageData!, Filename:imageName)
                        }
                    }
                })
            }
        }else{
            //print("imageName is empty")
        }
    }
}

