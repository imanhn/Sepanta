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

extension UIImageView {
    
    func setImageFromCache(PlaceHolderName defaultImageName : String, Scale aScale : CGFloat,ImageURL imageUrl : URL,ImageName imageName : String ){
        let defaultImage = UIImage(named: defaultImageName)
        self.contentMode = .scaleAspectFit
        let imageSize = CGSize(width: self.frame.size.width*aScale, height: self.frame.size.height*aScale)
        let filter = AspectScaledToFitSizeFilter(size: imageSize)
        
        let imageUrl = URL(string: NetworkManager.shared.websiteRootAddress+SlidesAndPaths.shared.path_profile_image+imageName)!
        var cachedData : NSData?
        if imageName.count > 0
        {
            cachedData = CacheManager.shared.readFile(Filename:imageName)
            if cachedData != nil {
                //print("Image is already cached ")
                let cachedImage = UIImage(data: cachedData! as Data)
                self.image = cachedImage
            }else{
                //print("Downloading....")
                self.af_setImage(withURL: imageUrl, placeholderImage: defaultImage, filter: filter,completion:
                    { (response) in
                        //print("Image Downloaded,Saving...")
                        let downloadedImage = self.image!// UIImage(data: response.data!)!
                        let imageData = UIImagePNGRepresentation(downloadedImage) as NSData?
                        if imageData != nil {
                            CacheManager.shared.saveFile(Data:imageData!, Filename:imageName)
                        }
                        
                })
            }
        }
    }
}

extension UIButton {
    
    func setImageFromCache(PlaceHolderName defaultImageName : String, Scale aScale : CGFloat,ImageURL imageUrl : URL,ImageName imageName : String ){
        let defaultImage = UIImage(named: defaultImageName)
        self.contentMode = .scaleAspectFit
        let imageSize = CGSize(width: self.frame.size.width*aScale, height: self.frame.size.height*aScale)
        let filter = AspectScaledToFitSizeFilter(size: imageSize)
        
        let imageUrl = URL(string: NetworkManager.shared.websiteRootAddress+SlidesAndPaths.shared.path_profile_image+imageName)!
        var cachedData : NSData?
        if imageName.count > 0
        {
            cachedData = CacheManager.shared.readFile(Filename:imageName)
            if cachedData != nil {
                //print("Image is already cached ")
                let cachedImage = UIImage(data: cachedData! as Data)
                //self.image = cachedImage
                self.setImage(cachedImage, for: .normal)
            }else{
                //print("Downloading....")
                self.af_setImage(for: .normal, url: imageUrl, placeholderImage: defaultImage, filter: filter, completion: {
                     (response) in
                        //print("Image Downloaded,Saving...")
                    let downloadedImage = self.image(for: .normal)// UIImage(data: response.data!)!
                    if downloadedImage != nil {
                        let imageData = UIImagePNGRepresentation(downloadedImage!) as NSData?
                        if imageData != nil {
                            CacheManager.shared.saveFile(Data:imageData!, Filename:imageName)
                        }
                    }

                })
            }
        }
    }
}

