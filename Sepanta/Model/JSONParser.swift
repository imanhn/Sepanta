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
    init(API apiName : String, Method aMethod : HTTPMethod,TargetObs targetObs : String) {
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
                        NetworkManager.shared.SMSConfirmed.accept(true)
                    }else{
                        if let amessage =  aDic["message"] as? String {
                            NetworkManager.shared.messageObs.accept(amessage)
                            
                        }else if let amessage =  aDic["status"] as? String {
                            NetworkManager.shared.messageObs.accept(amessage)
                        }else{
                            NetworkManager.shared.messageObs.accept("عملیات با خطا مواجه شده است")
                        }
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
                    if let aToken = aDic["token"] as? String ,
                        let aUsername = aDic["username"] as? String ,
                        let aRole = aDic["role"] as? String {
                        LoginKey.shared.token = aToken
                        LoginKey.shared.username = aUsername
                        LoginKey.shared.role = aRole                        
                        LoginKey.shared.tokenObs.accept(LoginKey.shared.token)
                        NetworkManager.shared.loginSucceed.accept(true)
                        LoginKey.shared.userIDObs.accept(LoginKey.shared.userID)
                        _ = LoginKey.shared.registerTokenAndUserID()
                    }else{
                        if let amessage =  aDic["message"] as? String {
                            NetworkManager.shared.messageObs.accept(amessage)
                            
                        }else if let amessage =  aDic["status"] as? String {
                            NetworkManager.shared.messageObs.accept(amessage)
                        }else{
                            NetworkManager.shared.messageObs.accept("عملیات با خطا مواجه شده است")
                        }
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
                    NetworkManager.shared.postDetailObs.accept(aPost)
                } else if (apiName == "post-delete") && (aMethod == HTTPMethod.post) {
                    //Returns the Post Detail
                    if let amessage = aDic["message"] as? String {
                        NetworkManager.shared.serverMessageObs.accept(amessage)
                    }
                } else if (apiName == "register") && (aMethod == HTTPMethod.post) {
                    //set a message for register when things go wrong or right!
                    if aDic["cellphone"] != nil {
                        NetworkManager.shared.messageObs.accept("این شماره همراه قبلاْ ثبت نام نموده است")
                    }else if aDic["username"] != nil {
                        NetworkManager.shared.messageObs.accept("این شناسه کاربری قبلاْ ثبت نام نموده است")
                    }else if let amessage = aDic["message"] as? String ,
                            let auserID = aDic["userId"] as? Int {
                            LoginKey.shared.userID = "\(auserID)"
                        LoginKey.shared.userIDObs.accept("\(auserID)")
                        NetworkManager.shared.messageObs.accept(amessage)
                    }
                    
                } else if (apiName == "profile")  {
                    //Returns Profile Data for a user Id
                    let aProfile = (self?.processAsProfile(Result: aDic))!
                    if targetObs == "SHOP" {
                        //NetworkManager.shared.shopProfileObs = BehaviorRelay<Profile>(value: aProfile)
                        NetworkManager.shared.shopProfileObs.accept(aProfile)
                        NetworkManager.shared.postsObs.accept(aProfile.content as! [Post])
                    }else{
                        //NetworkManager.shared.profileObs = BehaviorRelay<Profile>(value: aProfile)
                        NetworkManager.shared.profileObs.accept(aProfile)
                        //NetworkManager.shared.shopObs.accept(aProfile.content as! [Shop])
                    }
                    
                }else if (apiName == "report-comment") || (apiName == "report-post") || (apiName == "report-comment"){
                    //Returns Profile Data for a user Id
                    if let amessage = aDic["message"] as? String {
                        NetworkManager.shared.serverMessageObs.accept(amessage)
                    }
                } else if (apiName == "send-comment") && (aMethod == HTTPMethod.post) {
                    // Sets True for commentSendingSuccessful to be observable by PostUI
                    NetworkManager.shared.commentSendingSuccessful.accept(true)
                } else if (apiName == "poll") && (aMethod == HTTPMethod.get) {
                    //Returns Profile Data for a user Id
                    let aPollNo = (self?.processAsPollGet(Result: aDic))!
                    NetworkManager.shared.pollObs.accept(aPollNo)
                } else if (apiName == "rating") && (aMethod == HTTPMethod.post) {
                    //Returns Rating...
                    let arate = (self?.processRating(Result: aDic))!
                    NetworkManager.shared.shopRateObs.accept(arate)
                } else if (apiName == "contact") && (aMethod == HTTPMethod.post) {
                    // Sets True for commentSendingSuccessful to be observable by PostUI
                    NetworkManager.shared.message = (aDic["message"] as? String) ?? "نظر شما ثبت گردید"
                    if let aStatus =  aDic["status"] as? String{
                        if aStatus == "successful" {
                            NetworkManager.shared.contactSendingSuccessful.accept(ToggleStatus.YES)
                        }else{
                            NetworkManager.shared.contactSendingSuccessful.accept(ToggleStatus.NO)
                        }
                    }else{
                        // if server response does not contain "status" key then its a no!
                        NetworkManager.shared.contactSendingSuccessful.accept(ToggleStatus.NO)
                    }
                } else if (apiName == "like-dislike") && (aMethod == HTTPMethod.post) {
                    // Sets True for commentSendingSuccessful to be observable by PostUI
                    let likeStatus = self?.processLike(Result: aDic)
                    if likeStatus == 2 {
                        NetworkManager.shared.toggleLiked.accept(ToggleStatus.UNKNOWN)
                    }else if likeStatus == 1 {
                        NetworkManager.shared.toggleLiked.accept(ToggleStatus.YES)
                    }else if likeStatus == 0 {
                        NetworkManager.shared.toggleLiked.accept(ToggleStatus.NO)
                    }
                } else if (apiName == "profile-info") && (aMethod == HTTPMethod.post) {
                    // Sets True for profile-info to be observable by PostUI
                    NetworkManager.shared.updateProfileInfoSuccessful.accept(true)
                } else if (apiName == "new-shops") || (apiName == "my-following") || (apiName == "category-shops-list") {
                    print("Starting Shops List Parser for : \(apiName)")
                    let parsedShops = self?.processShopList(Result: aDic)
                    NetworkManager.shared.shopObs.accept(parsedShops!)
                } else if (apiName == "favorite") && (aMethod == HTTPMethod.get)  {
                    print("Starting Fav Shops List Parser for : \(apiName)")
                    let parsedShops = self?.processShopList(Result: aDic)
                    NetworkManager.shared.favShopObs.accept(parsedShops!)
                } else if (apiName == "favorite") && (aMethod == HTTPMethod.post) {
                    print("Starting Toggle Favorite on a shop Parser...")
                    let aToggle = self?.processFavAShopToggle(Result: aDic)
                    NetworkManager.shared.shopFav.accept(aToggle!)
                } else if (apiName == "profile-info") && (aMethod == HTTPMethod.get) {
                    print("Starting to get profile-info from server and parse it...")
                    let parsedProfileInfo = self?.processProfileInfo(Result: aDic)
                    ProfileInfoWrapper.shared.profileInfoObs.accept(parsedProfileInfo!)
                } else if (apiName == "search-shops") && (aMethod == HTTPMethod.post) {
                    print("Starting search-shops Parser...")
                    let parsedShopSearchResults = self?.processShopSearchResultList(Result: aDic)
                    NetworkManager.shared.shopSearchResultObs.accept(parsedShopSearchResults!)
                } else if (apiName == "shops-location") && (aMethod == HTTPMethod.post) {
                    print("Starting shops-location Parser...")
                    let parsedShopLocations = self?.processShopLocationsList(Result: aDic)
                    NetworkManager.shared.shopObs.accept(parsedShopLocations!)
                } else if (apiName == "check-bank") && (aMethod == HTTPMethod.post) {
                    print("Starting Check-Bank Parser...")
                    let parsedBankNumber = self?.processBankNumber(Result: aDic)
                    NetworkManager.shared.bankObs.accept(parsedBankNumber!)
                } else if (apiName == "card-request") && (aMethod == HTTPMethod.post) {
                    print("Starting card-request Parser...")
                    self?.processCardRequest(Result: aDic)
                } else if (apiName == "points-user") && (aMethod == HTTPMethod.get) {
                    print("Starting points-user Parser...")
                    let aUserPoint = self?.processPoints(Result: aDic)
                    NetworkManager.shared.userPointsObs.accept(aUserPoint!)
                    NetworkManager.shared.pointsElementsObs.accept(aUserPoint!.points!)
                } else if (apiName == "selling-request") && (aMethod == HTTPMethod.post) {
                    print("Starting selling-request Parser...")
                    self?.processSellRequest(Result: aDic)
                } else if (apiName == "app-version") && (aMethod == HTTPMethod.get) {
                    print("Starting version Parser getting latest version...")
                    if let stringVersion = aDic["version_ios"] as? String {
                        //print("Version fetched : ",stringVersion)
                        NetworkManager.shared.versionObs.accept(Float(stringVersion)!)
                    }
                } else if (apiName == "app-version") && (aMethod == HTTPMethod.post) {
                    print("Starting version Parser - sending in use...")
                    if let amessage = aDic["message"] as? String {
                        print("Server : ",amessage)
                    }
                } else if (apiName == "notifications") && (aMethod == HTTPMethod.get) {
                    print("Starting Notification Parser...")
                    let (generalNotif,notifAsAny) = (self?.processNotifications(Result: aDic))!
                    if let notifForShop = notifAsAny as? [NotificationForShop] {
                        NetworkManager.shared.notificationForShopObs.accept(notifForShop)
                    }else if let notifForUser = notifAsAny as? [NotificationForUser] {
                        NetworkManager.shared.notificationForUserObs.accept(notifForUser)
                    }else{
                        fatalError()
                    }
                    NetworkManager.shared.generalNotifObs.accept(generalNotif)
                } else if (apiName == "home") && (aMethod == HTTPMethod.get) {
                print("Starting Home Parser...")
                self?.processAndSetHomeData(Result: aDic)
        }

                }, onDisposed: {
                    //print("Parser Disposed")
                }
            ).disposed(by: netObjectsDispose)
    }
    func processRating(Result aResult : NSDictionary) -> Rate {
        var aRate = Rate()
        if aResult["error"] != nil {
            print("ERROR in Card Request Parsing : ",aResult["error"]!)
        }
        if let amessage = aResult["message"] as? String{
            aRate.message = amessage
        }
        if let astatus = aResult["status"] as? String{
            aRate.status = astatus
        }
        if let arate_count = aResult["rate_count"] as? Int{
            aRate.rate_count = arate_count
        }
        if let arate_avg = aResult["rate_avg"] as? Int{
            aRate.rate_avg = arate_avg
        }
        return aRate
    }

    func processPoints(Result aResult : NSDictionary) -> UserPoints {
        var aUserPoints = UserPoints()
        aUserPoints.points = [PointElement]()
        if aResult["error"] != nil {
            print("ERROR in Card Request Parsing : ",aResult["error"]!)
        }
        if let amessage = aResult["message"] as? String{
            aUserPoints.message = amessage
        }
        if let astatus = aResult["status"] as? String{
            aUserPoints.status = astatus
        }

        if let points_total = aResult["points_total"] as? Int ?? aResult["points_total "] as? Int{
            aUserPoints.points_total = points_total
        }else{
            print("*** ERORR : key : points_total not found")
        }
        if let pointsElements = aResult["points"] as? NSArray{
            for anElement in pointsElements{
                if let castedElement = anElement as? NSDictionary {
                    let aPointElem = PointElement(key: (castedElement["key"] as? String) ?? "", total: (castedElement["total"] as? Int) ?? 0)
                    aUserPoints.points?.append(aPointElem)
                }else{
                    print("*** Error : points element is not a Dictionary!")
                }
            }
        }else{
            print("*** Error : userpoints should have a key with name points!")
            print("Keys : ",aResult.allKeys)
        }
        
        return aUserPoints
        
    }
    
    func processAsPollGet(Result aResult : NSDictionary) -> Int {
        if aResult["error"] != nil {
            print("ERROR in Card Request Parsing : ",aResult["error"]!)
        }
        if let aPoll = aResult["poll"] as? Int{
            return aPoll
        }
        return 0
    }
    
    func processSellRequest(Result aResult : NSDictionary)  {
        if aResult["error"] != nil {
            print("ERROR in Card Request Parsing : ",aResult["error"]!)
        }
        if let aMessage = aResult["message"] {
            if let castedMessage = aMessage as? String{
                NetworkManager.shared.messageObs.accept(castedMessage)
            }else{
                NetworkManager.shared.messageObs.accept("نتیجه عملیات نامشخص بود،لطفاْ مجدداْ تلاش فرمایید")
            }
        }
    }
    
    func processCardRequest(Result aResult : NSDictionary)  {
        if aResult["error"] != nil {
            print("ERROR in Card Request Parsing : ",aResult["error"]!)
        }
        if let aMessage = aResult["message"] {
            if let castedMessage = aMessage as? String{
                NetworkManager.shared.messageObs.accept(castedMessage)
            }else{
                NetworkManager.shared.messageObs.accept("نتیجه عملیات نامشخص بود،لطفاْ مجدداْ تلاش فرمایید")
            }
        }
        //if  == "خطا : این کارت قبلا ثبت شده است" {
    }
    
    func processBankNumber(Result aResult : NSDictionary) -> (Bank) {
        var aBank = Bank()
        if aResult["error"] != nil {
            print("ERROR in Bank Parsing : ",aResult["error"]!)
        }
        aBank.code_bank = aResult["code_bank"] as? Int
        aBank.bank = aResult["bank"] as? String
        aBank.logo = aResult["logo"] as? String
        print("Bank",aBank)
        return aBank
    }
    
    func processNotifications(Result aResult : NSDictionary) -> ([GeneralNotification],[Any]) {
        var generalNotif = [GeneralNotification]()
        var notifForUser = [NotificationForUser]()
        var notifForShop = [NotificationForShop]()
        
        if aResult["notifications_manager"] != nil {
            if let notifs = aResult["notifications_manager"] as? NSArray {
                for anotif in notifs {
                    if let aNSDic = anotif as? NSDictionary{
                        var newGeneralNotif = GeneralNotification()
                        if let avalue = aNSDic["title"] { newGeneralNotif.title = avalue as? String ?? ""}
                        if let avalue = aNSDic["body"] { newGeneralNotif.body = avalue as? String ?? "پست جدید ما را ببینید"}
                        if let avalue = aNSDic["image"] { newGeneralNotif.image = avalue as? String ?? ""}
                        generalNotif.append(newGeneralNotif)
                    }
                }
            } else {
                print("notifications_user can not be casted as array")
            }
        }

        if aResult["notifications_user"] != nil {
            if let notifs = aResult["notifications_user"] as? NSArray {
                for anotif in notifs {
                    if let aNSDic = anotif as? NSDictionary{
                        var newNotif = NotificationForUser()
                        if let avalue = aNSDic["post_id"] { newNotif.post_id = avalue as? Int ?? 0}
                        if let avalue = aNSDic["user_id"] { newNotif.user_id = avalue as? Int ?? 0}
                        if let avalue = aNSDic["created_at"] { newNotif.created_at = avalue as? String ?? ""}
                        if let avalue = aNSDic["shop_name"] { newNotif.shop_name = avalue as? String ?? ""}
                        if let avalue = aNSDic["shop_image"] { newNotif.shop_image = avalue as? String ?? ""}
                        if let avalue = aNSDic["post_image"] { newNotif.post_image = avalue as? String ?? ""}
                        if let avalue = aNSDic["body"] { newNotif.body = avalue as? String ?? "پست جدید ما را ببینید"}
                        notifForUser.append(newNotif)
                    }
                }
                return (generalNotif,notifForUser)
            } else {
                print("notifications_user can not be casted as array")
            }
        }

        if aResult["notifications_shop"] != nil {
            if let notifs = aResult["notifications_shop"] as? NSArray {
                for anotif in notifs {
                    if let aNSDic = anotif as? NSDictionary{
                        var newNotif = NotificationForShop()
                        if let avalue = aNSDic["post_id"] { newNotif.post_id = avalue as? Int ?? 0}
                        if let avalue = aNSDic["user_id"] { newNotif.user_id = avalue as? Int ?? 0}
                        if let avalue = aNSDic["created_at"] { newNotif.created_at = avalue as? String ?? ""}
                        if let avalue = aNSDic["first_name"] { newNotif.first_name = avalue as? String ?? ""}
                        if let avalue = aNSDic["last_name"] { newNotif.last_name = avalue as? String ?? ""}
                        if let avalue = aNSDic["image"] { newNotif.image = avalue as? String ?? ""}
                        if let avalue = aNSDic["username"] { newNotif.username = avalue as? String ?? ""}
                        if let avalue = aNSDic["comment"] { newNotif.comment = avalue as? String ?? "کامنت خالی گذاشت"}
                        notifForShop.append(newNotif)
                    }
                }
                return (generalNotif,notifForShop)
            } else {
                print("notifications_shop can not be casted as array")
            }
        }
        print("@@@ ERROR : Result does not contain >notification_user or shop<")
        fatalError()
        
        //return (generalNotif,[])
    }

    func processLike(Result aResult : NSDictionary) -> Int {
        if aResult["error"] != nil {
            print("ERROR in Like Parsing : ",aResult["error"]!)
        }
        if aResult["message"] != nil {
            print("Like : Message Parsed : ",aResult["message"]!)
        }
        //print("Processlike : ",aResult["is_like"])
        //print("casting Processlike : ",aResult["is_like"] as? String)
        
        if let likeStr = aResult["is_like"] as? String {
            if likeStr == "1" {return 1}else{return 0}
        }else{
            return 2
        }
    }
    
    func processShopLocationsList(Result aResult : NSDictionary) -> [Shop] {
        var shops = [Shop]()
        if aResult["error"] != nil {
            print("ERROR in Shop List Parsing : ",aResult["error"]!)
        }
        if aResult["message"] != nil {
            print("Message Parsed : ",aResult["message"]!)
        }
        
        //print("Shop Result keys : ",aResult.allKeys)
        //print("Result : ",aResult)
        if let dataOfShops = aResult["shops"] as? NSArray{
                for shopDic in dataOfShops
                {
                    if let shopElemAsNSDic = shopDic as? NSDictionary{                        
                        if let shopElem = shopElemAsNSDic as? Dictionary<String, Any>{
                            //print("shopElem : ",shopElem)
                            if let uid = shopElem["user_id"] as? Int,
                                let shopid = shopElem["shop_id"] as? Int
                                {
                                    let aNewShop = Shop(shop_id: shopid,
                                                        user_id: uid,
                                                        shop_name: shopElem["shop_name"] as? String ?? "",
                                                        shop_off: shopElem["shop_off"] as? Int ?? 0,
                                                        lat: ((shopElem["lat"] as? String)?.toDouble()) ?? 0.0,
                                                        long: (shopElem["lon"] as? String)?.toDouble() ?? 0.0,
                                                        image: shopElem["image"] as? String ?? "",
                                                        rate: shopElem["rate"] as? String ?? "" ,
                                                        rate_count: shopElem["rate_count"] as? Int ?? 0 ,
                                                        follower_count: shopElem["follower_count"] as? Int ?? 0,
                                                        created_at: shopElem["created_at"] as? String ?? "")
                                    //print("UserID : \(uid) ShopID : \(shopid) Lat : \(aNewShop.lat) Long : \(aNewShop.long)")
                                    shops.append(aNewShop)
                            }
                        }
                    }else{
                        print("shopElm not casted.")
                    }
                }
        } else {
            print("Parser for ShopLocation : Couldnt cast Result[shops]  ")
            print("Shop Result keys : ",aResult.allKeys)
            print("aResult[categoryShops] ",aResult["categoryShops"] ?? "EMPTY")
        }
        print("Shops Fetched : ",shops.count," record")
        //print("Parsing State List Successful")
        
        return shops
        
    }

    func processFavAShopToggle(Result aProfileDicAsNS : NSDictionary) -> ToggleStatus {
        if aProfileDicAsNS["isFave"] == nil { return ToggleStatus.UNKNOWN}
        
        if let isFave = aProfileDicAsNS["isFave"] as? String {
            if isFave == "1" {
                return ToggleStatus.YES
            }else if isFave == "0" {
                return ToggleStatus.NO
            }else{
                return ToggleStatus.UNKNOWN
            }
        }
        return ToggleStatus.UNKNOWN
    }
    
    
    func processProfileInfo(Result aProfileDicAsNS : NSDictionary) -> ProfileInfo {
        var maritalStatusStr = ""
        var genderStr = ""
        var profileInfo = ProfileInfo()
        profileInfo.status = (aProfileDicAsNS["status"] as? String) ?? ""
        profileInfo.message = (aProfileDicAsNS["message"] as? String) ?? ""
        profileInfo.first_name = (aProfileDicAsNS["first_name"] as? String) ?? ""
        profileInfo.last_name = (aProfileDicAsNS["last_name"] as? String) ?? ""
        profileInfo.bio = (aProfileDicAsNS["bio"] as? String) ?? ""
        profileInfo.address = (aProfileDicAsNS["address"] as? String) ?? ""
        profileInfo.image = (aProfileDicAsNS["image"] as? String) ?? ""
        profileInfo.banner = (aProfileDicAsNS["banner"] as? String) ?? ""
        profileInfo.national_code = (aProfileDicAsNS["national_code"] as? String) ?? ""
        profileInfo.state = (aProfileDicAsNS["state"] as? String) ?? ""
        profileInfo.city = (aProfileDicAsNS["city"] as? String) ?? ""
        profileInfo.email = (aProfileDicAsNS["email"] as? String) ?? ""
        profileInfo.phone = (aProfileDicAsNS["phone"] as? String) ?? ""
        profileInfo.birthdate = (aProfileDicAsNS["birthdate"] as? String) ?? ""
        if let genderCode = aProfileDicAsNS["gender"] as? Int
        {
            if genderCode == 1 {genderStr = "مرد"} else if genderCode == 0 {genderStr = "زن"}
            //print("genderStr : \(genderStr) from \(genderCode)")
            profileInfo.gender = genderStr
        }
        
        profileInfo.birthdate = (aProfileDicAsNS["birthdate"] as? String) ?? ""
        profileInfo.email = (aProfileDicAsNS["email"] as? String) ?? ""
        if let maritalCode = aProfileDicAsNS["marital_status"] as? Int
        {
            if maritalCode == 1 {maritalStatusStr = "مجرد"} else if maritalCode == 2 {maritalStatusStr = "متاهل"}
            //print("maritalStatusStr : \(maritalStatusStr) from \(maritalCode) ")
            profileInfo.marital_status = maritalStatusStr
        }
        //print("FULL ProfileInfo : ",profileInfo)
        return profileInfo
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
        //print("*** FETCHED IMAGE PROFILE : ",aProfileDicAsNS["image"] ?? "Image Profile")
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
        profile.banner = (aProfileDicAsNS["banner"] as? String) ?? ""
        profile.bio = (aProfileDicAsNS["bio"] as? String) ?? ""
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
        profile.lat = (aProfileDicAsNS["lat"] as? String)?.toDouble()
        profile.long = (aProfileDicAsNS["lon"] as? String)?.toDouble()
        profile.is_favorite = (aProfileDicAsNS["is_favorite"] as? Bool) ?? false
        profile.is_follow = (aProfileDicAsNS["is_follow"] as? Bool) ?? false
        profile.follow_count = (aProfileDicAsNS["follow_count"] as? Int) ?? 0
        profile.follower_count = (aProfileDicAsNS["follower_count"] as? Int) ?? 0
        if let contents = aProfileDicAsNS["content"] as? NSArray {
            for aContent in contents {
                let aPostOrShop = (aContent as! NSDictionary)
                //print("aPostOrShop : ",aPostOrShop)
                //print("shop_Name : ",aPostOrShop["shop_name"])
                if profile.role?.uppercased() == "User".uppercased() {//aPostOrShop["shop_name"] != nil || aPostOrShop["shop_off"] != nil {
                    //print("This is a shop")
                    var newShop = Shop()
                    newShop.shop_id = (aPostOrShop["shop_id"] as? Int) ?? 0
                    newShop.user_id = (aPostOrShop["user_id"] as? Int) ?? 0
                    newShop.shop_name = (aPostOrShop["shop_name"] as? String) ?? ""
                    newShop.shop_off = (aPostOrShop["shop_off"] as? Int) ?? 0
                    newShop.lat = (aPostOrShop["lat"] as? String)?.toDouble()
                    newShop.long = (aPostOrShop["lon"] as? String)?.toDouble()
                    if let oneImage = aPostOrShop["image"] as? String {
                        newShop.image = oneImage
                    }else if let dicImage = aPostOrShop["image"] as? NSDictionary {
                        newShop.image = (dicImage["image"] as? String) ?? "EmptyImage"
                    }else{
                        print("Can not cast followed-shop IMAGE : \(String(describing: aPostOrShop["image"]))")
                    }
                    newShop.rate = (aPostOrShop["rate"] as? String) ?? ""
                    newShop.follower_count = (aPostOrShop["follower_count"] as? Int) ?? 0
                    newShop.created_at = (aPostOrShop["created_at"] as? String) ?? ""
                    profile.content.append(newShop)
                }else if profile.role?.uppercased() == "Shop".uppercased() {//else if aPostOrShop["title"] != nil {
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
                    if contents.count > 0
                    {
                        print("Error : Content has no Shop or Post role : ",profile.role ?? "NIL"," Content size : ",contents.count)
                        fatalError()
                    }
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
                //print("     Profile Card : ",newCard)
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
            //print("JSON Parser : Parsed Post : ",aPost)
        }else{
            print("*** Error : Post Detail is NULL - Parser Failed!")
            NetworkManager.shared.messageObs.accept("این پست حذف شده است")
        }
        if let someComments = aResult["comments"] as? NSArray {
            aPost.comments = [Comment]()
            for aComment in someComments {
                if let castedComment = aComment as? NSDictionary{
                    let newComment = Comment(comment_id: castedComment["comment_id"] as? Int,
                                             body: castedComment["body"] as? String,
                                             username: castedComment["username"] as? String,
                                             user_id: castedComment["user_id"] as? Int,
                                             first_name: castedComment["first_name"] as? String,
                                             last_name: castedComment["last_name"] as? String,
                                             image: castedComment["image"] as? String
                                             )
                    //print("Casted : ",newComment)
                    aPost.comments!.append(newComment)
                }else{
                    print("Error : Comment is incorrect and can not be casted : ",aComment)
                }
            }
        }else {
            print("comments before case as Array : ",aResult["comments"] ?? "EMPTY Comment")
        }

        if let aLike = aResult["is_like"] as? Bool {
            print("Reading isLike : ",aLike)
            aPost.isLiked = aLike
            
        }
        if let aCountLike = aResult["count_like"] as? Int {
            print("Reading Count Like : ",aCountLike)
            aPost.countLike = aCountLike
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
            if let notificationsCount = aResult["notifications_count"] as? Int {
                //SlidesAndPaths.shared.notifications_count.accept(120)
                SlidesAndPaths.shared.notifications_count.accept(notificationsCount)
            }else{
                print("Parser : Error : INVALID Notification count in HOME api")
            }
            if let newShopCount = aResult["count_new_shop"] as? Int {
                //SlidesAndPaths.shared.count_new_shop.accept(5)
                SlidesAndPaths.shared.count_new_shop.accept(newShopCount)
            }else{
                print("Parser : Error : INVALID new shop count in HOME api")
            }

            if let slides = aResult["sliders"] as? NSArray{
                for aSlide in slides {
                    if let aSlideAsNsDic = aSlide as? NSDictionary{
                        let anId = aSlideAsNsDic["id"] as? Int ?? 0
                        let aTitle = aSlideAsNsDic["title"] as? String ?? "بدون نام"
                        let aLink = aSlideAsNsDic["link"] as? String ?? ""
                        let aUserId = aSlideAsNsDic["user_id"] as? Int ?? 0
                        let aShopId = aSlideAsNsDic["shop_id"] as? Int ?? 0
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
                                        SlidesAndPaths.shared.slides.append(Slide(id: anId, title: aTitle, link: aLink, user_id: aUserId, shop_id: aShopId, images: imageName,aUIImage: image))
                                        SlidesAndPaths.shared.slidesObs.accept(SlidesAndPaths.shared.slides)
                                        let imageData = UIImageJPEGRepresentation(image,0.5) as NSData?
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
                            SlidesAndPaths.shared.slides.append(Slide(id: anId, title: aTitle, link: aLink, user_id: aUserId, shop_id: aShopId, images: imageName,aUIImage: img!))
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
        
        if let aDic = aResult["shops"] as? NSDictionary ?? aResult["categoryShops"] as? NSDictionary ?? aResult["favorite"] as? NSDictionary{
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
                                                    lat: (shopElem["lat"] as? String)?.toDouble() ?? 0.0,
                                                    long: (shopElem["lon"] as? String)?.toDouble() ?? 0.0,
                                                    image: shopElem["image"] as? String ?? "",
                                                    rate: shopElem["rate"] as? String ?? "" ,
                                                    rate_count: shopElem["rate_count"] as? Int ?? 0 ,
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
        }else if let dataOfShops = aResult["shops"] as? NSArray ?? aResult["categoryShops"] as? NSArray ?? aResult["favorite"] as? NSArray{
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
                                                lat: (shopElem["lat"] as? String)?.toDouble() ?? 0.0,
                                                long: (shopElem["lon"] as? String)?.toDouble() ?? 0.0,
                                                image: shopElem["image"] as? String ?? "",
                                                rate: shopElem["rate"] as? String ?? "" ,
                                                rate_count: shopElem["rate_count"] as? Int ?? 0 ,
                                                follower_count: shopElem["follower_count"] as? Int ?? 0,
                                                created_at: shopElem["created_at"] as? String ?? "")
                            shops.append(aNewShop)
                        }
                    }
                }else{
                    print("shopElm not casted.")
                }
            }
        }else {
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
