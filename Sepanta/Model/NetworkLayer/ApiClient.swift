//
//  ApiClient.swift
//  Sepanta
//
//  Created by Iman on 3/29/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Alamofire
import RxSwift

class ApiClient : NSObject,Codable {
    func request<T:Codable>(API anApiName : String,aMethod : HTTPMethod,Parameter aParam : Dictionary<String,String>?) -> Observable<T> {
        return Observable.create { observer -> Disposable in
            Alamofire.request(NetworkConstants.baseURLString + "/" + anApiName, method: aMethod, parameters: aParam, encoding: URLEncoding.httpBody, headers: NetworkManager.shared.headers)
                .validate(statusCode: 200..<600)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error!)
                            return
                        }
                        do {
                            let decodedData = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(decodedData)
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }
}
