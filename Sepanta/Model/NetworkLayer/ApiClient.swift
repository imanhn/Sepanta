//
//  ApiClient.swift
//  Sepanta
//
//  Created by Iman on 3/29/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Alamofire
import RxSwift
typealias APIParameters = [String: Any]

final class ApiClient {
    var headers: Dictionary<String, String>
    init() {
        self.headers = [
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer "+LoginKey.shared.token
        ]
    }

    func request<T: Codable>(API anApiName: String, aMethod: HTTPMethod, Parameter aParam: APIParameters?, Retry retry: Int = 3, Timeout timeout: Double = 10) -> Observable<T> {
        return Observable.create { observer -> Disposable in
            print("*** Route : ", NetworkConstants.baseURLString + "/" + anApiName)
            print("*** Method : ", aMethod)
            print("*** Parameters : ", aParam as? String ?? "UNKNOWN/NIL")
            print("*** Encoding : ", URLEncoding.httpBody)
            print("*** Headers : ", self.headers)
            Alamofire.request(NetworkConstants.baseURLString + "/" + anApiName, method: aMethod, parameters: aParam, encoding: URLEncoding.httpBody, headers: self.headers)
                .validate(statusCode: 200..<600)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error!)
                            return
                        }
                        do {
                            let strData = String(data: data, encoding: .utf8)
                            print("Data : ", strData ?? "")
                            let decodedData = try JSONDecoder().decode(T.self, from: data)
                            print("DecodedData : ", decodedData)
                            observer.onNext(decodedData)
                        } catch {
                            print("ERROR in Decoding ", T.self, " from ", data.description)
                            observer.onError(error)
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
            .retry(retry)
            .timeout(timeout, scheduler: MainScheduler.instance)
    }
}
