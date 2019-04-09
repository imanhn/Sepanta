//
//  JSONParser.swift
//  Sepanta
//
//  Created by Iman on 11/25/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift
import RxCocoa

class JSONParser {
    
    // MARK: - Properties
    
    var netObjectsDispose = DisposeBag()
    var resultSubject = BehaviorRelay<NSDictionary>(value : NSDictionary())
//    var result : JSON
    init(API apiName : String, Method aMethod : HTTPMethod) {
       // aMethod is not being used here for network operation.
       // It has only added to distinguish services with same API name and different Method
       // So they need their own Observable type
        resultSubject.asObservable()
            //.debug()
            .filter{ $0.count > 0 }
            .subscribe(onNext: { [weak self] (aDic) in
                //print("Dictionary Received : ",aDic.count,"  ",aDic)
                if (apiName == "get-state-and-city") && (aMethod == HTTPMethod.get){
                    var processedDic = Dictionary<String,String>()
                    (processedDic) = (self?.processAsProvinceList(Result: aDic))!
                    NetworkManager.shared.provinceDictionaryObs.accept(processedDic)//onNext(processedDic)//
                } else if (apiName == "get-state-and-city") && (aMethod == HTTPMethod.post) {
                    var processedDic = Dictionary<String,String>()
                    processedDic = (self?.processAsCityList(Result: aDic))!
                    NetworkManager.shared.cityDictionaryObs.accept(processedDic)
                } else if (apiName == "login") && (aMethod == HTTPMethod.post) {
                    if let aUserID = aDic["userId"] {
                        LoginKey.shared.userID = String(describing: aUserID)
                        LoginKey.shared.userIDObs.accept(LoginKey.shared.userID)
                    }
                } else if (apiName == "categories-filter") && (aMethod == HTTPMethod.get) {
                    //Returns All Catagories (while SepantaGroupsVC pushed/No state/City has selected yet //?? aDic["categoryShops"]  is redundant but who knows!
                    if let cat = aDic["categories"] ?? aDic["categoryShops"]  {
                        //print("Setting All Catagories  : ",[cat])
                        NetworkManager.shared.catagoriesObs.accept([cat])
                    }
                } else if (apiName == "categories-filter") && (aMethod == HTTPMethod.post) {
                    //Returns catagories after selection of a city or a state
                    if let cat = aDic["categories"] ?? aDic["categoryShops"] {
                        //print("Setting Catagories for a state/city : ",[cat])
                        NetworkManager.shared.catagoriesObs.accept([cat])
                    }
                    if aDic["list_city"] != nil {
                        var processedDic = Dictionary<String,String>()
                        processedDic = (self?.processAsCityList(Result: aDic))!
                        NetworkManager.shared.cityDictionaryObs.accept(processedDic)
                    }

                } else if (apiName == "check-sms-code") && (aMethod == HTTPMethod.post) {
                    if let aToken = aDic["token"] {
                        LoginKey.shared.token = String(describing: aToken)
                        LoginKey.shared.username = String(describing: aDic["username"] )
                        LoginKey.shared.role = String(describing: aDic["role"] )
                        LoginKey.shared.tokenObs.accept(LoginKey.shared.token)
                        _ = LoginKey.shared.registerTokenAndUserID()
                    }
                } else if (apiName == "category-state-list") && (aMethod == HTTPMethod.get) {
                    //Returns the List of supported States (which probably have catagory
                    var processedDic = Dictionary<String,String>()
                    (processedDic) = (self?.processAsProvinceList(Result: aDic))!
                    NetworkManager.shared.provinceDictionaryObs.accept(processedDic)
                    if let cat = aDic["categories"] {
                        NetworkManager.shared.catagoriesObs.accept([cat])
                    }
                } else if (apiName == "post-details") && (aMethod == HTTPMethod.post) {
                    //Returns the List of supported States (which probably have catagory
                    var processedDic = Dictionary<String,String>()
                    let aPost = (self?.processAsPostDetails(Result: aDic))!
                    NetworkManager.shared.postDetailObs.accept(aPost)
                } else if (apiName == "category-shops-list") && (aMethod == HTTPMethod.post) {
                    //Returns All shops in a Specific Catagory (Slug=3) OR Shops in a specific catagory in a state (Slug=1) OR Shops in a specific catagory in a city (Slug=2)
                    print("Starting category-shops-list Parser...")
                    let parsedShops = self?.processShopList(Result: aDic)
                    NetworkManager.shared.shopObs.accept(parsedShops!)
                } else if (apiName == "new-shops") && (aMethod == HTTPMethod.get) {
                    print("Starting NewShops Parser...")
                    let parsedShops = self?.processShopList(Result: aDic)
                    NetworkManager.shared.shopObs.accept(parsedShops!)
                } else if (apiName == "home") && (aMethod == HTTPMethod.get) {
                print("Starting Home Parser...")
                self?.processAndSetHomeData(Result: aDic)
        }

                }, onDisposed: {
                    //print("Parser Disposed")
                }
            ).disposed(by: netObjectsDispose)
    }
    
    func processAsPostDetails(Result aResult : NSDictionary) -> Post {
        var aPost = NetworkManager.shared.postDetailObs.value
        if let postDet = aResult["postDetail"] as? NSDictionary {
            if postDet != nil {
                if let aContent = postDet["content"] as? String {aPost.content = aContent}
                if let aShopId = postDet["shop_id"] as? Int {aPost.shopId = aShopId}
                if let aShopId = postDet["shop_id"] as? Int {aPost.shopId = aShopId}
                if let aTitle = postDet["title"] as? String {aPost.title = aTitle}
                if let aContent = postDet["content"] as? String {aPost.content = aContent}
                if let anImage = postDet["image"] as? String {aPost.image = anImage}
                if let aViewCount = postDet["viewCount"] as? Int {aPost.viewCount = aViewCount}
                if let aLike = postDet["is_like"] as? Bool {aPost.isLiked = aLike}
                if let aCountLike = postDet["count_like"] as? Int {aPost.countLike = aCountLike}
                if let someComments = postDet["comments"] as? NSArray {
                    aPost.comments = [Comment]()
                    for aComment in someComments {
                        let newComment = Comment(id: 0, userID: 0, comment: "")
                        aPost.comments!.append(newComment)
                    }
                }
            }
        }
        return aPost
    }
    
    func processAndSetHomeData(Result aResult : NSDictionary) {
        if let post_image = aResult["path_post_image"] as? String{
            SlidesAndPaths.shared.fetched = true
            SlidesAndPaths.shared.path_post_image = post_image
            SlidesAndPaths.shared.path_profile_image = (aResult["path_profile_image"] as? String) ?? SlidesAndPaths.shared.path_profile_image
            SlidesAndPaths.shared.path_slider_image = (aResult["path_slider_image"] as? String) ?? SlidesAndPaths.shared.path_slider_image
            SlidesAndPaths.shared.path_category_image = (aResult["path_category_image"] as? String) ?? SlidesAndPaths.shared.path_category_image
            SlidesAndPaths.shared.path_bank_logo_image = (aResult["path_bank_logo_image"] as? String) ?? SlidesAndPaths.shared.path_bank_logo_image
            if let slides = aResult["sliders"] as? NSArray{
                for aSlide in slides {
                    if let aSlideAsNsDic = aSlide as? NSDictionary{
                        let anId = aSlideAsNsDic["id"] as? Int ?? 0
                        let aTitle = aSlideAsNsDic["title"] as? String ?? "بدون نام"
                        let aLink = aSlideAsNsDic["link"] as? String ?? ""
                        let aUserId = aSlideAsNsDic["user_id"] as? Int ?? 0
                        let imageName = aSlideAsNsDic["images"] as? String ?? ""
                        let img = UIImage().getImageFromCache(ImageName: imageName)
                        if img == nil{
                            //print("Downloading slide : \(anId) with name : \(imageName)")
                            let imageUrlStr = NetworkManager.shared.websiteRootAddress+SlidesAndPaths.shared.path_slider_image+imageName
                            if let imageUrl = URL(string: imageUrlStr)
                            {
                                //print("Alamofire : ",imageUrlStr)
                                Alamofire.request(imageUrl).responseImage { [unowned self] response in
                                    if let image = response.result.value {
                                        //print("image downloaded: \(self.image)")
                                        //self.anUIImage.accept(image)
                                        SlidesAndPaths.shared.slides.append(Slide(id: anId, title: aTitle, link: aLink, user_id: aUserId, images: imageName,aUIImage: image))
                                        SlidesAndPaths.shared.slidesObs.accept(SlidesAndPaths.shared.slides)
                                        let imageData = UIImagePNGRepresentation(image) as NSData?
                                        if imageData != nil {
                                            //print("Saving slider : ",imageName)
                                            CacheManager.shared.saveFile(Data:imageData!, Filename:imageName)
                                        }
                                    }else{
                                        print("No response from alamofire requesting image")
                                    }
                                }
                            }else{
                                print("URL for Slide is invalid : ",imageUrlStr)
                            }
                        }else{
                            //print("Slide : ",anId," exists in cache : ",img)
                            SlidesAndPaths.shared.slides.append(Slide(id: anId, title: aTitle, link: aLink, user_id: aUserId, images: imageName,aUIImage: img!))
                            SlidesAndPaths.shared.slidesObs.accept(SlidesAndPaths.shared.slides)
                        }
                    }else{
                        print("Error : Slide element is not a NSDictionary")
                    }
                }
            }
            print("Home data updated....")
        }
    }
    
    func processShopList(Result aResult : NSDictionary) -> [Shop] {
        var shops = [Shop]()
        if aResult["error"] != nil {
            print("ERROR in Shop List Parsing : ",aResult["error"]!)
        }
        if aResult["message"] != nil {
            print("Message Parsed : ",aResult["message"]!)
        }
        
        //print("Shop Result keys : ",aResult.allKeys)
        //print("Result : ",aResult)
        if let aDic = aResult["shops"] as? NSDictionary ?? aResult["categoryShops"] as? NSDictionary{
            if let dataOfShops = aDic["data"] as? NSArray {
                for shopDic in dataOfShops
                {
                    if let shopElemAsNSDic = shopDic as? NSDictionary{
                        
                        if let shopElem = shopElemAsNSDic as? Dictionary<String, Any>{
                            //print("shopElem : ",shopElem)
                            let aNewShop = Shop(user_id: shopElem["user_id"] as? Int ?? 0, name: shopElem["shop_name"] as? String ?? "", image: shopElem["image"] as? String ?? ""  , stars: shopElem["rate"] as? Float ?? 0.0 , followers: shopElem["follower_count"] as? Int ?? 0, dicount: shopElem["shop_off"] as? Int ?? 0)
                            shops.append(aNewShop)
                        }
                    }else{
                        print("shopElm not casted.")
                    }
                }
            } else{
                print("aresult[shops or categoryShops][data] is empty or can not be casted")
            }
        } else {
            print("Couldnt cast Result[shops] or [categoryShops] ")
            print("Shop Result keys : ",aResult.allKeys)
            print("aResult[categoryShops] ",aResult["categoryShops"])
        }
        print("Shops Fetched : ",shops.count," record")
        //print("Parsing State List Successful")
        
        return shops

    }
    
    func processAsProvinceList(Result aResult : NSDictionary) -> (Dictionary<String,String>) {
        var provinceDict = Dictionary<String,String>()
        var provName : String
        if aResult["error"] != nil {
            print("ERROR in Province List Parsing : ",aResult["error"]!)
        }
        if aResult["message"] != nil {
            print("Message Parsed : ",aResult["message"]!)
        }

        //print("aResult states : ",aResult["states"])
        if let aDic = aResult["states"] as? NSDictionary {
            for aProv in aDic
            {
                //print(aProv.key," ",aProv.value)
                provName = "\(aProv.key)"
                provinceDict[provName] = "\(aProv.value)"
                //if let aName = aProv.key as? String {provName = aName} else { print("Error in Key of State data from Backend");continue}
                //if let idx = aProv.value as? String {provinceDict[provName] = idx} else { print("Error in Value of State data from Backend");continue}
                
            }
        } else {
            
        }
        print("Province Fetched : ",provinceDict.count," record")
        //print("Parsing State List Successful")

        return provinceDict
        
    }
    
    func processAsCityList(Result aResult : NSDictionary) -> (Dictionary<String,String>) {
        var cityDict = Dictionary<String,String>()
        var cityName : String
        print("Result AllKeys : ",aResult.allKeys)
        if aResult["error"] != nil {
            print("ERROR in Cities List Parsing : ",aResult["error"]!)
        }
        if aResult["message"] != nil {
            print("Message Parsed : ",aResult["message"]!)
        }
        
        //print("aResult cities : ",aResult["state"])

        if let aDic = aResult["state"] as? NSDictionary ?? aResult["list_city"] as? NSDictionary{
            for aCity in aDic
            {
                //print(aCity.key," ",aCity.value)
                cityName = "\(aCity.key)"
                cityDict[cityName] = "\(aCity.value)"
                /*
                if let aName = aCity.key as? String {cityName = aName} else { print("Parser : Error in City data from Backend");continue}
                if let idx = aCity.value as? String {cityDict[cityName] = idx} else { print("Parser : Error in City data from Backend");continue}
 */
                //print("Adding : ",cityName)
            }
        } else {
            print("Parser : Result for cities is empty!")
        }
        print("City Fetched : ",cityDict.count," record")
        //print("Parsing City List Successful")
        return cityDict
        
    }

}
