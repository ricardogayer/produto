//
//  Token.swift
//  Produto
//
//  Created by Ricardo Gayer on 06/01/21.
//

import Foundation

struct Token: Decodable {
    
    let access_token: String
    let expires_in: Int
    let refresh_expires_in: Int
    let refresh_token: String
    let token_type: String
    let session_state: String
    let scope: String

}
