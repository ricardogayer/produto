//
//  NovoProdutoViewController.swift
//  Produto
//
//  Created by Ricardo Gayer on 04/01/21.
//

import UIKit
import Alamofire

class NovoProdutoViewController: UIViewController {
    
    let produtoManager:ProdutoManager = ProdutoManager()

    @IBOutlet weak var ProdutoNome: UITextField!
    
    @IBOutlet weak var ProdutoCategoria: UITextField!
    
    
    @IBOutlet weak var progressView: UIProgressView!
    
    
    @IBOutlet weak var imageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadImage() { response in
            print(response.debugDescription)
        }

        progressView.progress = 0
        
        // Do any additional setup after loading the view.
    }

    @IBAction func saveProduto(_ sender: Any) {
        
        let produto:Produto = Produto(nil, nome: ProdutoNome.text!, categoria: ProdutoCategoria.text!)
        
        produtoManager.saveProduto(produto) { [weak self] result in
        switch result {
          case .failure:
            // print("Erro durante o save do produto")
            ErrorPresenter.showError(message: "Ocorreu um erro ao salvar o produto", on: self)
          case .success:
            DispatchQueue.main.async { [weak self] in
              self?.navigationController?.popViewController(animated: true)
            }
          }
        }
            
    }
    
    func downloadImage(completion: @escaping (Void?) -> Void) {
        
        NetworkClient.request(WikiRouter.download)
            .responseData { response in
            switch response.result {
            case .success(let image):
                print("Download log wikipedia realizado")
                guard let imagem = UIImage(data: image) else {
                    print("Erro na conversão da imagens")
                    return
                }
                self.imageView.image = imagem
            case .failure(let error):
                print(error)
            }
        }
        
        /*
        let url = "https://www.wikipedia.org/portal/wikipedia.org/assets/img/Wikipedia-logo-v2@2x.png"
        
        AF.download(url)
            .responseData { response in
            switch response.result {
            case .success(let image):
                print("Download log wikipedia realizado")
                guard let imagem = UIImage(data: image) else {
                    print("Erro na conversão da imagens")
                    return
                }
                self.imageView.image = imagem
            case .failure(let error):
                print(error)
            }
        }
        */
        
    }
    
    func uploadImage(progressCompletion: @escaping (_ percent: Float) -> Void) {

        let image = UIImage(named: "bike")
        
        guard let imageData = image!.jpegData(compressionQuality: 0.5) else {
          print("Could not get JPEG representation of UIImage")
          return
        }
        
        
        // TO-DO Completion p/ zerar o upload (hide)
        
        NetworkClient.upload(multipartFormData: {multipartFormData in
            multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        }, with: ProdutoRouter.upload(747))
          .uploadProgress { progress in
             progressCompletion(Float(progress.fractionCompleted))
          }
         .response{ response in
            switch response.result {
            case .failure(let error):
              print("Error uploading file: \(error)")
            case .success(let response):
              print(response.debugDescription)
            }
        }
        
        /*
         AF.upload(multipartFormData: { multipartFormData in
           multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
           }, to: "http://10.0.1.67:8080/image/747")
           .uploadProgress { progress in
              progressCompletion(Float(progress.fractionCompleted))
           }
          .response{ response in
             switch response.result {
             case .failure(let error):
               print("Error uploading file: \(error)")
             case .success(let response):
               print(response.debugDescription)
             }
         }
         
         
         */
        
        
        
    }
    
    @IBAction func upload(_ sender: Any) {
        
        uploadImage(progressCompletion: { [unowned self] percent in
                self.progressView.setProgress(percent, animated: true)
          })
    }
    
    /*
    
    upload(image: image,
           progressCompletion: { [unowned self] percent in
            self.progressView.setProgress(percent, animated: true)
      },
           completion: { [unowned self] tags, colors in
            self.takePictureButton.isHidden = false
            self.downloadSampleImageButton.isHidden = false
            self.progressView.isHidden = true
            self.activityIndicatorView.stopAnimating()
            
            self.tags = tags
            self.colors = colors
            
            self.performSegue(withIdentifier: "ShowResults", sender: self)
    })
    
    func upload(image: UIImage,
                progressCompletion: @escaping (_ percent: Float) -> Void,
                completion: @escaping (_ tags: [String]?, _ colors: [PhotoColor]?) -> Void) {
      guard let imageData = image.jpegData(compressionQuality: 0.5) else {
        print("Could not get JPEG representation of UIImage")
        return
      }
      
      
      AF.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        }, to: "http://10.0.1.67:8080/image/747")
        .authenticate(username: ImaggaCredentials.username, password: ImaggaCredentials.password)
        // .validate()
        .uploadProgress { progress in
          progressCompletion(Float(progress.fractionCompleted))
        }.responseDecodable(of: UploadImageResponse.self) { response in
          switch response.result {
          case .failure(let error):
            print("Error uploading file: \(error)")
            completion(nil, nil)
          case .success(let uploadResponse):
            let resultID = uploadResponse.result.uploadID
            print("Content uploaded with ID: \(resultID)")
            print(response.debugDescription)
          }
      }
      

       
      AF.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        }, to: "https://api.imagga.com/v2/uploads")
        .authenticate(username: ImaggaCredentials.username, password: ImaggaCredentials.password)
        .validate()
        .uploadProgress { progress in
          progressCompletion(Float(progress.fractionCompleted))
        }.responseDecodable(of: UploadImageResponse.self) { response in
          switch response.result {
          case .failure(let error):
            print("Error uploading file: \(error)")
            completion(nil, nil)
          case .success(let uploadResponse):
            let resultID = uploadResponse.result.uploadID
            print("Content uploaded with ID: \(resultID)")
            print(response.debugDescription)
            self.downloadTags(contentID: resultID) { tags in
              self.downloadColors(contentID: resultID) { colors in
                completion(tags, colors)
              }
            }
          }
      }

      
    }
    
    */

}
