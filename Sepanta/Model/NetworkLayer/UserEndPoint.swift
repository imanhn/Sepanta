//
//  UserEndPoint.swift
//  Sepanta
//
//  Created by Iman on 3/29/1398 AP.
//  Copyright © 1398 AP Imzich. All rights reserved.
//

import Foundation
import Alamofire

enum UserEndpoint: APIConfiguration {
    
    case contact(title:String, body:String)
    case profile(id: Int)
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .contact:
            return .post
        case .profile:
            return .get
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .contact:
            return "/contact"
        case .profile(let id):
            return "/profile/\(id)"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .contact(let email, let password):
            return [K.APIParameterKey.email: email, K.APIParameterKey.password: password]
        case .profile:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
