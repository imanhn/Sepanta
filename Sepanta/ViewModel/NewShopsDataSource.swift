//
//  NewShopsDataSource.swift
//  Sepanta
//
//  Created by Iman on 12/19/1397 AP.
//  Copyright © 1397 AP Imzich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxAlamofire
import Alamofire
import AlamofireImage

class NewShopsDataSource {
    var delegate : NewShopsViewController
    let myDisposeBag = DisposeBag()
    var fetchedShops = [Shop]()
    var shopProfiles = BehaviorRelay<[Profile]>(value: [])
    
    func updateFetchedShops(_ aProfileDicAsNS : NSDictionary){
        for i in 0..<fetchedShops.count {
            if aProfileDicAsNS["id"] != nil {
                if fetchedShops[i].user_id == aProfileDicAsNS["id"] as! Int {
                    fetchedShops[i].image = (aProfileDicAsNS["image"] as? String) ?? ""
                    fetchedShops[i].followers = (aProfileDicAsNS["follower_count"] as? Int) ?? 0
                    fetchedShops[i].dicount = (aProfileDicAsNS["shop_off"] as? Int) ?? 0
                }
            }
        }
        self.delegate.shops.accept(self.fetchedShops)
    }
    
    func getNewShopsFromServer(){
        NetworkManager.shared.run(API: "new-shops", QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil)
        NetworkManager.shared.shopObs
            //.debug()
            .filter({$0.count > 0})
            .subscribe(onNext: { [unowned self] (innerShops) in
                print("innerShops : ",innerShops.count)
                print("Shops : ",innerShops)
                self.fetchedShops = innerShops as! [Shop]
                self.delegate.shops.accept(self.fetchedShops)
                for ashop in self.fetchedShops {
                    let urlAddress = "http://www.panel.ipsepanta.ir/api/v1/profile?user%20id=\(ashop.user_id)"
                    let aParameter = ["user id":"\(ashop.user_id)"]
                    let aHeader = ["Authorization":"Bearer \(LoginKey.shared.token)" , "Accept":"application/json"]
                    RxAlamofire.requestJSON(HTTPMethod.post, urlAddress , parameters: aParameter, encoding: JSONEncoding.default, headers: aHeader)
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
                                    print("aProfileAsNS Keys : ",aProfileAsNS.allKeys)
                                    print("message : ",aProfileAsNS["message"])
                                    
                                    self.updateFetchedShops(aProfileAsNS)
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
                
                }, onError: { _ in
                    print("NewShops Call Raised Error")
                    Spinner.stop()
            }, onCompleted: {
                print("NewShops Call Completed")
            }, onDisposed: {
                print("NewShops Disposed")
            }).disposed(by: myDisposeBag)

        self.shopProfiles.subscribe(onNext: { (innerProfiles) in
            
        }, onError: {_ in
            
        }, onCompleted: {
            
        }, onDisposed: {
            
        }).disposed(by: myDisposeBag)
    }
    
    func fetchData() {
        getNewShopsFromServer()
        /*
        var fetchedShops = [Shop]()
        fetchedShops.append(Shop(user_id: 1,name: "فست فود جو", image: "cat_img/icon_menu_02.png", stars: 1.4, followers: 16005, dicount: 15))
        fetchedShops.append(Shop(user_id:2,name: "تهران برگر", image: "profile_img/2074-2018-08-28_09-59-03.jpg", stars: 3.4, followers: 1501, dicount: 10))
         self.delegate.shops.accept(self.fetchedShops)
         */
    }
    
    init (_ vc : NewShopsViewController){
        self.delegate = vc
    }
}
