//
//  ProdutoDetalheViewController.swift
//  Produto
//
//  Created by Ricardo Gayer on 04/01/21.
//

import UIKit

class ProdutoDetalheViewController: UIViewController {
    
    var produtoId: Int = 0
    
    let produtoManager:ProdutoManager = ProdutoManager()
    var produto:Produto?
    
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
    
}
