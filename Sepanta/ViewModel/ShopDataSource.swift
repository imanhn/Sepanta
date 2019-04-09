//
//  ShopDataSource.swift
//  Sepanta
//
//  Created by Iman on 12/21/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import RxAlamofire
import Alamofire
import UIKit
import RxCocoa
import RxSwift

class ShopDataSource {
    var myDisposeBag = DisposeBag()
    var userId : Int!
    var delegate : ShopViewController!
    

    init(_ vc : ShopViewController){
        self.delegate = vc
        if vc.shop.user_id != nil && vc.shop.user_id != 0  {
            self.userId = vc.shop.user_id
            getShopFromServer()
        }else{
            print("ERROR : ShopDataSource can not work with empty userID ",vc.shop)
        }
    }
    
    
    func createAndSetProfile(_ aProfileDicAsNS : NSDictionary){
        var profile = Profile()
        //print("aProfileDicAsNS: ",aProfileDicAsNS)
        //print("aProfileDicAsNS Keys : ",aProfileDicAsNS.allKeys)
        if aProfileDicAsNS["id"] == nil || (aProfileDicAsNS["id"] as? Int) == 0 {
            self.delegate.alert(Message: "اطلاعات این فروشگاه کامل نیست")
            return
        }
        profile.id = (aProfileDicAsNS["id"] as? Int) ?? 0
        profile.image = (aProfileDicAsNS["image"] as? String) ?? ""
        profile.address = (aProfileDicAsNS["address"] as? String) ?? ""
        profile.shop_id = (aProfileDicAsNS["shop_id"] as? Int) ?? 0
        profile.shop_name = (aProfileDicAsNS["shop_name"] as? String) ?? ""
        profile.shop_off = (aProfileDicAsNS["shop_off"] as? Int) ?? 0
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
        print("Profile : ",profile)
        if let contents = aProfileDicAsNS["content"] as? NSArray {
            for aContent in contents {
                let aPost = (aContent as! NSDictionary)
                var newPost = Post(id: 0, shopId: 0, viewCount: 0, comments: [], isLiked: false, countLike: 0, title: "", content: "", image: "")
                newPost.id = (aPost["id"] as? Int) ?? 0
                newPost.title = (aPost["title"] as? String) ?? ""
                newPost.content = (aPost["content"] as? String) ?? ""
                newPost.image = (aPost["image"] as? String) ?? ""
                print("     Profile Post : ",newPost)
                profile.content.append(newPost)
            }
        }
        
        if let cards = aProfileDicAsNS["cards"] as? NSArray {
            for aContent in cards {
                let aCard = (aContent as! NSDictionary)
                var newCard = CreditCard(id:0)
                newCard.id = (aCard["id"] as? Int) ?? 0
                print("     Profile Card : ",newCard)
                profile.cards.append(newCard)
            }
        }
        self.delegate.profileRelay.accept(profile)
    }

    func getShopFromServer() {
        let urlAddress = "http://www.panel.ipsepanta.ir/api/v1/profile?user%20id=\(self.userId!)"
        let aParameter = ["user id": self.userId! ]
        print(urlAddress)
        let aHeader = ["Authorization":"Bearer \(LoginKey.shared.token)" , "Accept":"application/json"]
        return RxAlamofire.requestJSON(HTTPMethod.post, urlAddress , parameters: aParameter, encoding: JSONEncoding.default, headers: aHeader)
            .observeOn(MainScheduler.instance)
            .timeout(2, scheduler: MainScheduler.instance)
            .retry(4)
            //.debug()
            .subscribe(onNext: { [unowned self] (ahttpURLRes,jsonResult) in
                if let aProfileAsNS = jsonResult as? NSDictionary {
                    if aProfileAsNS["error"] != nil {
                        print("Error : ",aProfileAsNS["error"])
                        print("Header : ",aHeader)
                    }else {
                        if aProfileAsNS["user_id"] != nil {
                            self.delegate.alert(Message: "خطایی اتفاق افتاده است \n" + (aProfileAsNS["user_id"] as? String)!)
                        }
                        self.createAndSetProfile(aProfileAsNS)
                    }
                } else {
                    print("NewShopsDataSource : Error Casting Profile as NSDictionary")
                }
                }, onError: { (err) in
                    if err.localizedDescription == "The Internet connection appears to be offline." {
                        print("No Internet")
                    }
                    if err.localizedDescription == "Could not connect to the server." {
                        print("No Server Connection")
                    }
                    print("NewShopsDataSource RXAlamofire Raised an Error : >",err.localizedDescription,"<")
            }, onCompleted: {
                //print("Completed")
            }, onDisposed: {
                //print("NetworkManager Disposed")
            }).disposed(by: self.myDisposeBag)
    }
}
