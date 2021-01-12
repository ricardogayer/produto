//
//  Auth.swift
//  Produto
//
//  Created by Ricardo Gayer on 06/01/21.
//

import Foundation
import Alamofire

class Auth {
    
    static let defaultsKey = "ACCESS_TOKEN"
    let defaults = UserDefaults.standard
    
    var token: String? {
        get {
            return defaults.string(forKey: Auth.defaultsKey)
        }
        set {
            defaults.set(newValue, forKey: Auth.defaultsKey)
        }
    }
    
    func autenticar(username: String, password: String, completion: @escaping (Result<Token, Error>) -> Void) {
        
        NetworkClient.request(LoginRouter.login(username, password)).responseDecodable(of: Token.self) { response in
            print(response.debugDescription)
            switch response.result {
            case .success(let token):
                completion(.success(token))
            case .failure(let error):
                // print("Erro -> \(error)")
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response -> \(json!)")
                }
                completion(.failure(error))
            }
        }
    }
}

/*
 
 let header = HTTPHeader.contentType("application/x-www-form-urlencoded")
 var parameters = [String:String]()
 
 parameters["grant_type"] = "password"
 parameters["username"] = username
 parameters["password"] = password
 parameters["scope"] = "fitnessapp"
 parameters["client_id"] = "fitnessapp"
 
 AF.request("http://localhost:8080/auth/realms/fitness/protocol/openid-connect/token", method: .post, parameters: parameters, encoder:
 URLEncodedFormParameterEncoder.default, headers: [header])
 .validate(statusCode: 200...200)
 .responseDecodable(of: Token.self) { response in
 print(response.debugDescription)
 switch response.result {
 case .success(let token):
 completion(.success(token))
 case .failure(let error):
 // print("Erro -> \(error)")
 if let data = response.data {
 let json = String(data: data, encoding: String.Encoding.utf8)
 print("Failure Response -> \(json!)")
 }
 completion(.failure(error))
 }
 }
 }
 */



