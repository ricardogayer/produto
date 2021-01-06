//
//  ProdutoManager.swift
//  Produto
//
//  Created by Ricardo Gayer on 04/01/21.
//

import Foundation
import Alamofire

class ProdutoManager {
    
    func getProds(completion: @escaping (Result<[Produto], Error>) -> Void) {
        AF.request("http://10.0.1.67:8080/produtos").responseDecodable(of: [Produto].self) { response in
            // print(response.result)
            switch response.result {
            case .success(let produto):
                completion(.success(produto))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getProdId (ProdutoId: Int, completion: @escaping (Result<Produto, Error>) -> Void) {
        let id:Int = ProdutoId // + 1
        AF.request("http://10.0.1.67:8080/produtos/\(id)")
            .validate(statusCode: 200...200)
            .responseDecodable(of: Produto.self) { response in
            // print(response.debugDescription)
            switch response.result {
            case .success(let produto):
                completion(.success(produto))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateProduto(_ produto: Produto, completion: @escaping (Result<Void, Error>) -> Void) {
        AF.request("http://10.0.1.67:8080/produtos", method: .put, parameters: produto, encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200...200)
            .response { response in
               switch response.result {
                  case .success:
                     completion(.success(()))
                  case .failure(let error):
                     completion(.failure(error))
               }
        }
    }
    
    func saveProduto(_ produto: Produto, completion: @escaping (Result<Void, Error>) -> Void) {
        AF.request("http://10.0.1.67:8080/produtos", method: .post, parameters: produto, encoder: JSONParameterEncoder.default)
          .validate(statusCode: 201...201)
          .response { response in
            switch response.result {
               case .failure(let error):
                  completion(.failure(error))
               case .success:
                  completion(.success(()))
            }
        }
    }
        
    func deleteProdutoById(_ id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let url = "http://10.0.1.67:8080/produtos/\(id)"
        
        AF.request(url, method: .delete)
           .validate()
           .response { response in
                // print(response.result)
              switch response.result {
                 case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
}
