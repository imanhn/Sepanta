//
//  VersionControl.swift
//  Sepanta
//
//  Created by Iman on 2/21/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift

extension HomeViewController {

    func manageVersion(){
        getLatestVersion()
        sendInUseVersion()
    }
    
    func sendInUseVersion(){
        let aParameter = ["version_ios":"\(LoginKey.shared.version)"]
        NetworkManager.shared.run(API: "app-version", QueryString: "", Method: HTTPMethod.post, Parameters: aParameter, Header: nil, WithRetry: true)
    }
    
    func getLatestVersion(){
        NetworkManager.shared.run(API: "app-version", QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil, WithRetry: true)
        NetworkManager.shared.versionObs
            .filter({$0 != 0.0})
            .subscribe(onNext: { aversion in
                if (aversion - LoginKey.shared.version >= 1.0) {
                    // NEED Update
                    self.showAlertWithOK(Message: "برنامه نیاز به بروزرسانی دارد، ادامه عملیات ممکن نیست", OKLabel: "متوجه شدم",Tag: 3)
                }else if (aversion - LoginKey.shared.version >= 0.1) {
                    self.showAlertWithOK(Message: "برنامه نیاز به بروزرسانی دارد، لطفاْ در اسرع وقت بروزرسانی کنید", OKLabel: "متوجه شدم")
                }else{
                    //print("Latest : \(aversion) current : \(LoginKey.shared.version)")
                }
                NetworkManager.shared.versionObs = BehaviorRelay<Float>(value: 0.0)
            }).disposed(by: myDisposeBag)
    }
    
    override func doneAlert(_ sender: Any) {
        super.doneAlert(sender)
        if (sender as! UIButton).tag == 3 {
            fatalError()
        }
    }
}
