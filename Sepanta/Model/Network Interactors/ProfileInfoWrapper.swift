//
//  ProfileInfo.swift
//  Sepanta
//
//  Created by Iman on 2/1/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class ProfileInfoWrapper {
    static let shared = ProfileInfoWrapper()
    var profileInfoObs = BehaviorRelay<ProfileInfo>(value: ProfileInfo())
    var myDisposeBag = DisposeBag()

    private init() {
        getProfileInfo()
    }

    func getProfileInfo() {
        //Subscrition in NetworkManager- Data will be accept to profileInfoObs in this Singleton
        NetworkManager.shared.run(API: "profile-info", QueryString: "", Method: HTTPMethod.get, Parameters: nil, Header: nil, WithRetry: true)
    }
}
