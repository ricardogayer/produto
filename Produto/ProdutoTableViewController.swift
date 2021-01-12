//
//  ProdutoTableViewController.swift
//  Produto
//
//  Created by Ricardo Gayer on 04/01/21.
//

import UIKit
import Alamofire

class ProdutoTableViewController: UITableViewController {
    
    let produtoManager:ProdutoManager = ProdutoManager()
    var produtos:[Produto] = []
    
    override func viewDidAppear(_ animated: Bool) {

        /*
        guard let access_token = Auth().token else {
           return
        }
        */
        
        // print("Access token salvo no dispositivo: \(access_token)")
        
        produtoManager.getProds { [weak self] produtosResult in
            switch produtosResult {
            case .failure:
                // print("Error da chamada da API")
                ErrorPresenter.showError(message: "Ocorreu um erro durante a recuperação dos produtos", on: self)
            case .success(let produto):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    print("Chamada da API de produtos...")
                    self.produtos = produto
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    
    @objc func refresh(sender:AnyObject)
    {
        // Updating your data here...
        
        produtoManager.getProds { [weak self] produtosResult in
            switch produtosResult {
            case .failure:
                // print("Error da chamada da API")
                ErrorPresenter.showError(message: "Ocorreu um erro durante a recuperação dos produtos", on: self)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.refreshControl?.endRefreshing()
                }
            case .success(let produto):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    print("Chamada da API de produtos...")
                    self.produtos = produto
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return produtos.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "produto", for: indexPath)
        
        cell.textLabel?.text = produtos[indexPath.row].nome;
        cell.detailTextLabel?.text = produtos[indexPath.row].categoria;
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            
            let produto:Produto = produtos[indexPath.row]
            
            produtoManager.deleteProdutoById(produto.id!) { result in
                switch result {
                case .failure:
                    // print("Ocorreu um erro durante a exclusão do produto")
                    ErrorPresenter.showError(message: "Ocorreu um erro durante a exclusão do produto", on: self)
                case .success():
                    print("Chamada da API exclusão de produto...\(produto.nome)")
                    self.produtos.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "produto" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! ProdutoDetalheViewController
                destinationController.produtoId = self.produtos[indexPath.row].id!
            }
        }
    }
    
    @IBAction func login(_ sender: Any) {
        
        // Auth().token = "abcdef"
        
        Auth().autenticar(username: "rrgayer", password: "pacuja") { [weak self] response in
            switch response {
            case .failure:
                // print("Error da chamada da API")
                ErrorPresenter.showError(message: "Erro na autenticação", on: self)
            case .success(let token):
                Auth().token = token.access_token
                print(token.access_token)
            }
   
        }

    }
    
}
