//
//  CadastroViewModel.swift
//  PokeExplorer
//
//  Created by Tiago Prestes on 10/06/25.
//

import Foundation
import SwiftUI
import SwiftData

class CadastroViewModel : ObservableObject {
    @Environment(\.modelContext) var modelContext
    
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var isUsernameInvalid = false
    @Published var isEmailInvalid = false
    @Published var isPasswordInvalid = false
    @Published var isPasswordsDifferent = false
    
    var canContinue: Bool {
        !username.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        if password.count < 6 {
            return false
        }
        
        let uppercaseRegex = ".*[A-Z].*"
        let uppercasePredicate = NSPredicate(format: "SELF MATCHES %@", uppercaseRegex)
        if !uppercasePredicate.evaluate(with: password) {
            return false
        }
        
        let symbolRegex = ".*[!@#$%^&*()\\-_=+\\[{\\]};:'\"<,>.\\/?`~].*"
        let symbolPredicate = NSPredicate(format: "SELF MATCHES %@", symbolRegex)
        if !symbolPredicate.evaluate(with: password) {
            return false
        }
        
        return true
    }
    
    func insertUser() {
        let user = Usuario(username: username, email: email, senha: password)
        modelContext.insert(user)
    }
}
