//
//  NovoProdutoViewController.swift
//  Produto
//
//  Created by Ricardo Gayer on 04/01/21.
//

import UIKit

class NovoProdutoViewController: UIViewController {
    
    let produtoManager:ProdutoManager = ProdutoManager()

    @IBOutlet weak var ProdutoNome: UITextField!
    
    @IBOutlet weak var ProdutoCategoria: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
