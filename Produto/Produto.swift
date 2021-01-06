//
//  Produto.swift
//  Produto
//
//  Created by Ricardo Gayer on 04/01/21.
//

import Foundation

struct Produto: Decodable,Encodable {
    
    let id: Int?
    let nome: String
    let categoria: String
    
    init(_ id: Int?, nome: String, categoria:String) {
      self.id = id
      self.nome = nome
      self.categoria = categoria
    }

}
