//
//  NetworkClient.swift
//  Produto
//
//  Created by Ricardo Gayer on 11/01/21.
//


import Foundation
import Alamofire

struct NetworkClient {
  static let shared = NetworkClient()
  let session: Session
  
  init() {
    self.session = Session()
  }
  
  static func request(_ convertible: URLRequestConvertible) -> DataRequest {
    shared.session.request(convertible)
        .validate()
        // .authenticate(username: ImaggaCredentials.username, password: ImaggaCredentials.password)
  }
  
  /*
  static func download(_ url: String) -> DownloadRequest {
    shared.session.download(url).validate()
  }
 */
  
  static func upload(multipartFormData: @escaping (MultipartFormData) -> Void, with convertible: URLRequestConvertible) -> UploadRequest {
    shared.session.upload(multipartFormData: multipartFormData, with: convertible).validate()
        // .authenticate(username: ImaggaCredentials.username, password: ImaggaCredentials.password)
  }
}

