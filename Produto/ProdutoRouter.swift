//
//  ProdutoRouter.swift
//  Produto
//
//  Created by Ricardo Gayer on 11/01/21.
//

import Foundation
import Alamofire

enum ProdutoRouter: URLRequestConvertible {
    
    enum Constants {
      static let baseURLPath = "http://10.0.1.67:8081"
    }
    
    case request
    case detalhe(String)
    case save(Produto)
    case update(Produto)
    case delete(String)
    case upload(Int)
    case download(Int)
    
    var method: HTTPMethod {
      switch self {
      case .request, .download, .detalhe: 
        return .get
      case .save, .upload:
        return .post
      case .update:
        return .put
      case .delete:
        return .delete
      }
    }
    
    var path: String {
        switch self {
        case .download(let id):
          let a = "\(id)"
          return "/image/download/\(a)"
        case .request, .save, .update:
          return "/produtos"
        case .delete(let id):
          return "/produtos/\(id)"
        case .upload(let imageId):
          return "image/\(imageId)"
        case .detalhe(let id):
          return "/produtos/\(id)"
        }
    }
    
    var parameters: [String: Any?] {
      switch self {
      case .save(let produto):
        return ["produto": produto]
      case .update(let produto):
        return ["produto": produto]
      default:
        return [:]
      }
    }

    func asURLRequest() throws -> URLRequest {
      let url = try Constants.baseURLPath.asURL()
      var request = URLRequest(url: url.appendingPathComponent(path))
      request.httpMethod = method.rawValue
      request.timeoutInterval = TimeInterval(10*1000)
        
        let parameters:[String:String] = [:]

        switch self {
        case .request:
              request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        case .detalhe:
              request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        case .save(let parameters):
              request = try JSONParameterEncoder().encode(parameters, into: request)
        case .update(let parameters):
              request = try JSONParameterEncoder().encode(parameters, into: request)
        case .delete:
              request = try JSONParameterEncoder().encode(parameters, into: request)
        case .upload:
              request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        case .download:
              request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        }
        
        return request
    }

}

