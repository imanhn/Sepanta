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
                    //Returns the Post Detail
                    let aPost = (self?.processAsPostDetails(Result: aDic))!
                    NetworkManager.shared.postCommentsObs.accept(aPost.comments ?? [Comment]())
                    NetworkManager.shared.postDetailObs.accept(aPost)
                } else if (apiName == "profile") && (aMethod == HTTPMethod.post) {
                    //Returns Profile Data for a user Id
                    let aProfile = (self?.processAsProfile(Result: aDic))!
                    NetworkManager.shared.profileObs.accept(aProfile)
                } else if (apiName == "send-comment") && (aMethod == HTTPMethod.post) {
                    // Sets True for commentSendingSuccessful to be observable by PostUI
                    NetworkManager.shared.commentSendingSuccessful.accept(true)
                } else if (apiName == "category-shops-list") && (aMethod == HTTPMethod.post) {
                    //Returns All shops in a Specific Catagory (Slug=3) OR Shops in a specific catagory in a state (Slug=1) OR Shops in a specific catagory in a city (Slug=2)
                    print("Starting category-shops-list Parser...")
                    let parsedShops = self?.processShopList(Result: aDic)
                    NetworkManager.shared.shopObs.accept(parsedShops!)
                } else if (apiName == "new-shops") && (aMethod == HTTPMethod.get) {
                    print("Starting NewShops Parser...")
                    let parsedShops = self?.processShopList(Result: aDic)
                    NetworkManager.shared.shopObs.accept(parsedShops!)
                } else if (apiName == "search-shops") && (aMethod == HTTPMethod.post) {
                    print("Starting search-shops Parser...")
                    let parsedShopSearchResults = self?.processShopSearchResultList(Result: aDic)
                    NetworkManager.shared.shopSearchResultObs.accept(parsedShopSearchResults!)
                } else if (apiName == "home") && (aMethod == HTTPMethod.get) {
                print("Starting Home Parser...")
                self?.processAndSetHomeData(Result: aDic)
        }

                }, onDisposed: {
                    //print("Parser Disposed")
                }
            ).disposed(by: netObjectsDispose)
    }
    
    func processShopSearchResultList (Result aResult : NSDictionary) -> [ShopSearchResult] {
        var shopResults = [ShopSearchResult]()
        if aResult["error"] != nil {
            print("ERROR in Shop List Parsing : ",aResult["error"]!)
        }
        if aResult["message"] != nil {
            print("Message Parsed : ",aResult["message"]!)
        }
        
        //print("Shop Result keys : ",aResult.allKeys)
        //print("Result : ",aResult)
        if let shopsInResult = aResult["shops"] as? NSArray {
            for shopResultDic in shopsInResult
            {
                if let shopElemAsNSDic = shopResultDic as? NSDictionary{
                    if let shopElem = shopElemAsNSDic as? Dictionary<String, Any> {
                        //print("shopElem : ",shopElem)
                        if shopElem["user_id"] != nil && shopElem["shop_id"] != nil {
                            let aShopResult = ShopSearchResult(shop_id: shopElem["shop_id"] as? Int ?? 0,
                                                user_id: shopElem["user_id"] as? Int ?? 0,
                                                shop_name: shopElem["shop_name"] as? String ?? "")
                            shopResults.append(aShopResult)
                        }else{
                            print("Warning : Shop Result is not Complete!")
                        }
                    }
                }else{
                    print("shopElm not casted.")
                }
            }
        } else {
            print("Couldnt cast Result[shops] as Array ")
            print("Shop Result keys : ",aResult.allKeys)
            print("aResult[categoryShops] ",aResult["categoryShops"] ?? "EMPTY")
        }
        print("Shop Results Fetched : ",shopResults.count," record")
        //print("Parsing State List Successful")
        return shopResults
    }
    
    func processAsProfile(Result aProfileDicAsNS : NSDictionary) -> Profile {
        var profile = Profile()
        //print("aProfileDicAsNS: ",aProfileDicAsNS)
        //print("aProfileDicAsNS Keys : ",aProfileDicAsNS.allKeys)
        if aProfileDicAsNS["id"] == nil || (aProfileDicAsNS["id"] as? Int) == 0 {
            NetworkManager.shared.status.accept(.IncompleteData)
            return Profile()
        }
        profile.status = (aProfileDicAsNS["status"] as? String) ?? ""
        profile.message = (aProfileDicAsNS["message"] as? String) ?? ""
        profile.id = (aProfileDicAsNS["id"] as? Int) ?? 0
        profile.image = (aProfileDicAsNS["image"] as? String) ?? ""
        profile.address = (aProfileDicAsNS["address"] as? String) ?? ""
        profile.shop_id = (aProfileDicAsNS["shop_id"] as? Int) ?? 0
        profile.shop_name = (aProfileDicAsNS["shop_name"] as? String) ?? ""
        profile.category_title = (aProfileDicAsNS["category_title"] as? String) ?? ""
        profile.rate = (aProfileDicAsNS["rate"] as? String) ?? ""
        profile.rate_count = (aProfileDicAsNS["rate_count"] as? Int) ?? 0
        profile.shop_off = (aProfileDicAsNS["shop_off"] as? Int) ?? 0
        profile.url = (aProfileDicAsNS["url"] as? String) ?? ""
        profile.cellphone = (aProfileDicAsNS["cellphone"] as? String) ?? ""
        profile.phone = (aProfileDicAsNS["phone"] as? String) ?? ""
        profile.username = (aProfileDicAsNS["username"] as? String) ?? ""
        profile.fullName = (aProfileDicAsNS["fullName"] as? String) ?? ""
        profile.role = (aProfileDicAsNS["role"] as? String) ?? ""
        profile.lat = (aProfileDicAsNS["lat"] as? Double) ?? 0
        profile.long = (aProfileDicAsNS["long"] as? Double) ?? 0
        profile.is_favorite = (aProfileDicAsNS["is_favorite"] as? Bool) ?? false
        profile.is_follow = (aProfileDicAsNS["is_follow"] as? Bool) ?? false
        profile.follow_count = (aProfileDicAsNS["follow_count"] as? Int) ?? 0
        profile.follower_count = (aProfileDicAsNS["follower_count"] as? Int) ?? 0
        
        if let contents = aProfileDicAsNS["content"] as? NSArray {
            for aContent in contents {
                let aPostOrShop = (aContent as! NSDictionary)
                //print("aPostOrShop : ",aPostOrShop)
                //print("shop_Name : ",aPostOrShop["shop_name"])
                if aPostOrShop["shop_name"] != nil || aPostOrShop["shop_off"] != nil {
                    //print("This is a shop")
                    var newShop = Shop()
                    newShop.shop_id = (aPostOrShop["shop_id"] as? Int) ?? 0
                    newShop.user_id = (aPostOrShop["user_id"] as? Int) ?? 0
                    newShop.shop_name = (aPostOrShop["shop_name"] as? String) ?? ""
                    newShop.shop_off = (aPostOrShop["shop_off"] as? Int) ?? 0
                    newShop.lat = (aPostOrShop["lat"] as? Double) ?? 0
                    newShop.long = (aPostOrShop["long"] as? Double) ?? 0
                    if let oneImage = aPostOrShop["image"] as? String {
                        newShop.image = oneImage
                    }else if let dicImage = aPostOrShop["image"] as? NSDictionary {
                        newShop.image = (dicImage["image"] as? String) ?? "EmptyImage"
                    }else{
                        print("Can not cast Shop IMAGE : \(String(describing: aPostOrShop["image"]))")
                    }
                    newShop.rate = (aPostOrShop["rate"] as? String) ?? ""
                    newShop.follower_count = (aPostOrShop["follower_count"] as? Int) ?? 0
                    newShop.created_at = (aPostOrShop["created_at"] as? String) ?? ""
                    profile.content.append(newShop)
                }else if aPostOrShop["title"] != nil {
                    //print("This is a Post")
                    var newPost = Post(id: 0, shopId: 0, viewCount: 0, comments: [], isLiked: false, countLike: 0, title: "", content: "", image: "")
                    newPost.id = (aPostOrShop["id"] as? Int) ?? 0
                    newPost.title = (aPostOrShop["title"] as? String) ?? ""
                    newPost.content = (aPostOrShop["content"] as? String) ?? ""
                    //print("Adding Content... with image : ",aPost)
                    if let oneImage = aPostOrShop["image"] as? String {
                        newPost.image = oneImage
                    }else if let dicImage = aPostOrShop["image"] as? NSDictionary {
                        newPost.image = (dicImage["image"] as? String) ?? "EmptyImage"
                    }else{
                        print("Can not cast POST IMAGE : \(String(describing: aPostOrShop["image"]))")
                    }
                    //print("     Profile Post : ",newPost)
                    profile.content.append(newPost)
                }else{
                    print("Error : ButtonCell[ShopUI or ProfileUI] returned Data is incomplete")
                }
            }
        }else{
            print("Content in Profile can not be casted as NSArray")
        }
        
        if let cards = aProfileDicAsNS["cards"] as? NSArray {
            for aContent in cards {
                let aCard = (aContent as! NSDictionary)
                var newCard = CreditCard()
                newCard.id = (aCard["id"] as? Int) ?? 0
                newCard.first_name = (aCard["first_name"] as? String) ?? ""
                newCard.last_name = (aCard["last_name"] as? String) ?? ""
                newCard.card_number = (aCard["card_number"] as? String) ?? ""
                newCard.status = (aCard["status"] as? Int) ?? 0
                newCard.bank_name = (aCard["bank_name"] as? String) ?? ""
                newCard.bank_logo = (aCard["bank_logo"] as? String) ?? ""
                print("     Profile Card : ",newCard)
                profile.cards.append(newCard)
            }
        }
        //print("FULL Profile : ",profile)
        return profile
    }
    
    func processAsPostDetails(Result aResult : NSDictionary) -> Post {
        var aPost = NetworkManager.shared.postDetailObs.value
        if let postDet = aResult["postDetail"] as? NSDictionary {
            if let aContent = postDet["content"] as? String {aPost.content = aContent}
            if let anId = postDet["id"] as? Int {aPost.id = anId}
            if let aShopId = postDet["shop_id"] as? Int {aPost.shopId = aShopId}
            if let aTitle = postDet["title"] as? String {aPost.title = aTitle}
            if let aContent = postDet["content"] as? String {aPost.content = aContent}
            if let anImage = postDet["image"] as? String {aPost.image = anImage}
            if let aViewCount = postDet["viewCount"] as? Int {aPost.viewCount = aViewCount}
            if let aLike = postDet["is_like"] as? Bool {aPost.isLiked = aLike}
            if let aCountLike = postDet["count_like"] as? Int {aPost.countLike = aCountLike}

            if let someComments = aResult["comments"] as? NSArray {
                aPost.comments = [Comment]()
                for aComment in someComments {
                    if let castedComment = aComment as? NSDictionary{
                        let newComment = Comment(id: castedComment["id"] as? Int, username: castedComment["username"] as? String, body: castedComment["body"] as? String)
                        print("Casted : ",newComment)
                        aPost.comments!.append(newComment)
                    }else{
                        print("Error : Comment is incorrect and can not be casted : ",aComment)
                    }
                }
            }else {
                print("comments before case as Array : ",postDet["comments"] ?? "EMPTY Comment")
            }
            print("JSON Parser : Parsed Post : ",aPost)
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
                                Alamofire.request(imageUrl).responseImage {  response in
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
                                        NetworkManager.shared.status.accept(CallStatus.error)
                                        print("No response from alamofire requesting image")
                                    }
                                }
                            }else{
                                NetworkManager.shared.status.accept(CallStatus.InternalServerError)
                                print("URL for Slide is invalid : ",imageUrlStr)
                            }
                        }else{
                            //print("Slide : ",anId," exists in cache : ",img)
                            SlidesAndPaths.shared.slides.append(Slide(id: anId, title: aTitle, link: aLink, user_id: aUserId, images: imageName,aUIImage: img!))
                            SlidesAndPaths.shared.slidesObs.accept(SlidesAndPaths.shared.slides)
                        }
                    }else{
                        NetworkManager.shared.status.accept(CallStatus.InternalServerError)
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
                            if shopElem["user_id"] != nil && shopElem["shop_id"] != nil {
                                let aNewShop = Shop(shop_id: shopElem["shop_id"] as? Int ?? 0,
                                                    user_id: shopElem["user_id"] as? Int ?? 0,
                                                    shop_name: shopElem["shop_name"] as? String ?? "",
                                                    shop_off: shopElem["shop_off"] as? Int ?? 0,
                                                    lat: shopElem["lat"] as? Double ?? 0.0,
                                                    long: shopElem["long"] as? Double ?? 0.0,
                                                    image: shopElem["image"] as? String ?? "",
                                                    rate: shopElem["rate"] as? String ?? "" ,
                                                    follower_count: shopElem["follower_count"] as? Int ?? 0,
                                                    created_at: shopElem["created_at"] as? String ?? "")
                                shops.append(aNewShop)
                            }
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
            print("aResult[categoryShops] ",aResult["categoryShops"] ?? "EMPTY")
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
