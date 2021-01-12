//
//  ProdutoDetalheViewController.swift
//  Produto
//
//  Created by Ricardo Gayer on 04/01/21.
//

import UIKit
import Alamofire

class ProdutoDetalheViewController: UIViewController {
    
    var produtoId: Int = 0
    
    let produtoManager:ProdutoManager = ProdutoManager()
    var produto:Produto?
    
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ProdutoIdLabel: UILabel!
    @IBOutlet weak var CategoriaName: UITextField!
    @IBOutlet weak var ProdutoNameEdit: UITextField!
    
    @IBAction func save(_ sender: Any) {
        
        let p:Produto = Produto(produtoId, nome: ProdutoNameEdit.text!, categoria: CategoriaName.text!)
        
        produtoManager.updateProduto(p) { [weak self] result in
        switch result {
          case .failure:
            // print("Ocorreu um erro durante a atualização do produto")
            ErrorPresenter.showError(message: "Ocorreu um erro durante a atualização do produto", on: self)
          case .success:
            DispatchQueue.main.async { [weak self] in
              self?.navigationController?.popViewController(animated: true)
            }
          }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.progress = 0
        
        downloadImage(progressCompletion: { [unowned self] percent in
            self.progressView.setProgress(percent, animated: true)
          }) {response in
            print(response.debugDescription)
        }
        
        ProdutoIdLabel.text = "\(produtoId)"
        
        produtoManager.getProdId(ProdutoId: produtoId) { [weak self] produtosResult in
            switch produtosResult {
            case .failure:
                // print("Error da chamada da API")
                ErrorPresenter.showError(message: "Ocorreu um erro durante a recuperação do produto", on: self)
            case .success(let produto):
              DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.produto = produto
                self.ProdutoNameEdit.text = produto.nome
                self.CategoriaName.text = produto.categoria
              }
            }
          }
    }
    
    func downloadImage(progressCompletion: @escaping (_ percent: Float) -> Void, completion: @escaping (Void?) -> Void) {
        
        var id = random(5)
        
        if id < 1 {
            id = 1
        }
        
        print("Número \(id)")
        
        /*
          
        let url = "http://10.0.1.67:8080/image/download/\(id)"
        
        AF.download(url)
            .downloadProgress {progress in
                progressCompletion(Float(progress.fractionCompleted))
              }
            .responseData { response in
            switch response.result {
            case .success(let image):
                print("Download realizado")
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
        
        
        
        NetworkClient.request(ProdutoRouter.download(id))
            .downloadProgress {progress in
                progressCompletion(Float(progress.fractionCompleted))
              }
            .responseData { response in
            switch response.result {
            case .success(let image):
                print("Download realizado")
                guard let imagem = UIImage(data: image) else {
                    print("Erro na conversão da imagens")
                    return
                }
                self.imageView.image = imagem
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func random(_ n:Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }
    
}
