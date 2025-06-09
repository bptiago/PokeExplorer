//
//  UsuarioModel.swift
//  PokeExplorer
//
//  Created by Tiago Prestes on 09/06/25.
//

import Foundation
import SwiftData

@Model
class Usuario {
    
    @Attribute(.unique) var id: UUID = UUID()
    var username: String
    @Attribute(.unique) var email: String
    var senha: String
    
    init(username: String, email: String, senha: String) {
        self.id = UUID()
        self.username = username
        self.email = email
        self.senha = senha
    }
}
