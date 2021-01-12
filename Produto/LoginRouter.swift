//
//  LoginRouter.swift
//  Produto
//
//  Created by Ricardo Gayer on 12/01/21.
//

//
//  ProdutoRouter.swift
//  Produto
//
//  Created by Ricardo Gayer on 11/01/21.
//

import Foundation
import Alamofire

enum LoginRouter: URLRequestConvertible {
    
    enum Constants {
      static let baseURLPath = "http://10.0.1.67:8080"
    }
    
    case login(String, String)
    case logoff
    
    var method: HTTPMethod {
      switch self {
      case .login:
        return .post
      case .logoff:
        return .post
      }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/auth/realms/fitness/protocol/openid-connect/token"
        case .logoff:
            return ""
        }
    }
    
    var parameters: [String: String] {
      switch self {
      case .login(let username, let password):
        return ["grant_type": "password",
                 "username": username,
                 "password": password,
                 "scope": "fitnessapp",
                 "client_id": "fitnessapp"]
      case .logoff:
        return [:]
      }
    }
    
    func asURLRequest() throws -> URLRequest {
        
      let header = HTTPHeader.contentType("application/x-www-form-urlencoded")
      let url = try Constants.baseURLPath.asURL()
      var request = URLRequest(url: url.appendingPathComponent(path))
      request.httpMethod = method.rawValue
      request.timeoutInterval = TimeInterval(10*1000)
      request.headers = [header]
      return try URLEncoding.default.encode(request, with: parameters)
    }

}


