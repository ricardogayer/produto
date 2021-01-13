//
//  WikiRouter.swift
//  Produto
//
//  Created by Ricardo Gayer on 12/01/21.
//

import Foundation
import Alamofire

enum WikiRouter: URLRequestConvertible {
    
    enum Constants {
      static let baseURLPath = "https://www.wikipedia.org"
    }
    
    case download
    case upload
    
    var method: HTTPMethod {
      switch self {
      case .download:
        return .get
      case .upload:
        return .post
      }
    }
    
    var path: String {
        switch self {
        case .download:
          return "/portal/wikipedia.org/assets/img/Wikipedia-logo-v2@2x.png"
        case .upload:
          return "/upload"
        }
    }
    
    var parameters: [String: String] {
      switch self {
      case .download:
        return ["username": "rrgayer",
                "password": "pacuja"]
      case .upload:
        return [:]
      }
    }
    
    func asURLRequest() throws -> URLRequest {
    
      let url = try Constants.baseURLPath.asURL()
      var request = URLRequest(url: url.appendingPathComponent(path))
      request.httpMethod = method.rawValue
      request.timeoutInterval = TimeInterval(10*1000)
      return try URLEncoding.default.encode(request, with: parameters)
    }
    
    
}
