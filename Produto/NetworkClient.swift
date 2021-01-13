//
//  NetworkClient.swift
//  Produto
//
//  Created by Ricardo Gayer on 11/01/21.
//


import Foundation
import Alamofire

struct NetworkClient {
    
    struct NetworkClientRetrier: RequestInterceptor {
      
      func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 403 {
            print("Retry............")
          completion(.retryWithDelay(1))
        } else {
            print("NO RETRY............")
          completion(.doNotRetryWithError(error))
        }
      }
      
    }
    
    
  struct Certificates {
    
    /*
     
     Comando para exportar os certificados dos sites:
     
     openssl s_client -connect api.imagga.com:443 < /dev/null | openssl x509 -outform DER -out imagga.com.der
     openssl s_client -connect www.wikipedia.org:443 < /dev/null | openssl x509 -outform DER -out wikipedia.org.der
     
     */
    
    static let imagga = Certificates.certificate(filename: "imagga.com")
    static let wikipedia = Certificates.certificate(filename: "wikipedia.org")
    
    private static func certificate(filename: String) -> SecCertificate {
        let filePath = Bundle.main.path(forResource: filename, ofType: "der")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        return SecCertificateCreateWithData(nil, data as CFData)!
    }
    
  }
    
  static let shared = NetworkClient()
  let session: Session
    
    let evaluators = [
      "api.imagga.com": PinnedCertificatesTrustEvaluator(certificates: [Certificates.imagga]),
      "www.wikipedia.org": PinnedCertificatesTrustEvaluator(certificates: [Certificates.wikipedia])
    ]
    
    let retrier: RequestInterceptor
    
  init() {
    self.retrier = NetworkClientRetrier()
    // self.session = Session()
    self.session = Session(interceptor: retrier, serverTrustManager: ServerTrustManager(evaluators: evaluators))
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

