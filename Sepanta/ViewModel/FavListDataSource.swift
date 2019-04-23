//
//  FavListDataSource.swift
//  Sepanta
//
//  Created by Iman on 2/1/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxAlamofire
import Alamofire
import AlamofireImage

class FavListDataSource {
    var delegate : UIViewController
    let myDisposeBag = DisposeBag()
    var fetchedShops = [Shop]()
    var shopProfiles = BehaviorRelay<[Profile]>(value: [])    
    
    func getFavShopsFromServer(){
        NetworkManager.shared.run(API: "favorite", QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil,WithRetry: true)
    }
    
    init (_ vc : UIViewController){
        self.delegate = vc
        //subscribeToShop()
    }
}
