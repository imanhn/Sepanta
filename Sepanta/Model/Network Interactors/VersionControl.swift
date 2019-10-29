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

    func manageVersion() {
        getLatestVersion()
    }

    func getLatestVersion() {
        let aParameter = ["market":"anardoni",
                          "app_version": "\(LoginKey.shared.version)",
                          "os_mobile": "IOS"]

        let verDisp = AppVersionCheck(Parameter : aParameter).results()
            .subscribe(onNext: { [unowned self] aVersionCheck in
                if (aVersionCheck.force_update ?? false) {
                    // NEED Update
                    self.showAlertWithOK(Message: "برنامه نیاز به بروزرسانی دارد، ادامه عملیات ممکن نیست", OKLabel: "متوجه شدم", Completion: {fatalError()})
                } else if (aVersionCheck.optional_update ?? false) {
                    self.showAlertWithOK(Message: "برنامه نیاز به بروزرسانی دارد، لطفاْ در اسرع وقت بروزرسانی کنید", OKLabel: "متوجه شدم")
                } else {
                    print("VERSION Latest : \(LoginKey.shared.version)")
                }
            })
        verDisp.disposed(by: myDisposeBag)
        disposeList.append(verDisp)
    }

}
