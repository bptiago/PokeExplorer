//
//  CadastroModal.swift
//  CineFiles
//
//  Created by Tiago Prestes on 30/05/25.
//

// TODO: EMAIL JÁ EXISTE, COLORAÇÃO E UI

import SwiftUI

struct CadastroModal: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Binding var isPresentingLogin: Bool
    @Binding var isPresentingCadastro: Bool
    @Binding var appState: AppState
    
    @State private var username: String = ""
    
    @State private var email: String = ""
    
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var isUsernameInvalid = false
    @State private var isEmailInvalid = false
    @State private var isPasswordInvalid = false
    @State private var isPasswordsDifferent = false
    
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
    
    private var canContinue: Bool {
        !username.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            Text("Junte-se a nós!")
                .font(.title.bold())
            
            VStack() {
                Form {
                    Section {
                        VStack {
                            TextField("",
                                      text: $username,
                                      prompt: Text("Insira seu nome de usuário")
                                .font(.body)
                                .foregroundStyle(Color.accentColor)
                            )
                            .padding(12)
                            .foregroundStyle(.black)
                            .background(.white)
                            .font(.body)
                            .clipShape(.capsule)
                            .overlay {
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(
                                        isUsernameInvalid ? .red : .clear,
                                        lineWidth: 1
                                    )
                            }
                            .textContentType(.password)
                            
                            if isUsernameInvalid {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle")
                                    Text("Nome de usuário precisa ter pelo menos 3 caracteres")
                                }
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    } header: {
                        Text("Nome de usuário")
                            .font(.headline.bold())
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                        .frame(height: 16)
                    
                    Section {
                        VStack {
                            TextField("",
                                      text: $email,
                                      prompt: Text("Insira seu e-mail")
                                .font(.body)
                                .foregroundStyle(Color.accentColor)
                            )
                            .padding(12)
                            .foregroundStyle(.black)
                            .background(.white)
                            .font(.body)
                            .clipShape(.capsule)
                            .overlay {
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(
                                        isEmailInvalid ? .red : .clear,
                                        lineWidth: 1
                                    )
                            }
                            .textContentType(.password)
                            
                            if isEmailInvalid {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle")
                                    Text("Formato de e-mail inválido. Tente novamente")
                                }
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    } header: {
                        Text("E-mail")
                            .font(.headline.bold())
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                        .frame(height: 16)
                    
                    Section {
                        VStack {
                            SecureField("",
                                        text: $password,
                                        prompt: Text("Insira sua senha")
                                .font(.body)
                                .foregroundStyle(.red)
                            )
                            .padding(12)
                            .foregroundStyle(.black)
                            .background(.white)
                            .font(.body)
                            .clipShape(.capsule)
                            .overlay {
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(
                                        isPasswordsDifferent ? .red : .clear,
                                        lineWidth: 1
                                    )
                            }
                            .textContentType(.password)
                            
                            if isPasswordInvalid || isPasswordsDifferent {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle")
                                    Text(isPasswordInvalid ? "Senha inválida. Deve conter no mínimo 6 caracteres, uma letra maiúscula e um símbolo" : "Senhas incompatíveis. Por favor, tente novamente.")
                                }
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                        }
                    } header: {
                        Text("Senha")
                            .font(.headline.bold())
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                        .frame(height: 16)
                    
                    Section {
                        VStack {
                            SecureField("",
                                        text: $confirmPassword,
                                        prompt: Text("Insira sua senha")
                                .font(.body)
                                .foregroundStyle(.gray)
                            )
                            .padding(12)
                            .foregroundStyle(.black)
                            .background(.white)
                            .font(.body)
                            .clipShape(.capsule)
                            .overlay {
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(
                                        isPasswordsDifferent ? .red : .clear,
                                        lineWidth: 1
                                    )
                            }
                            .textContentType(.password)
                            
                            if isPasswordsDifferent {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle")
                                    Text("Senhas incompatíveis. Por favor, tente novamente.")
                                }
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    } header: {
                        Text("Confirmar senha")
                            .font(.headline.bold())
                            .foregroundStyle(.white)
                    }
                }
                .formStyle(.columns)
            }
            
            Button(action: {
                withAnimation {
                    if username.count < 3 {
                        isUsernameInvalid = true
                    } else if !isValidEmail(email) {
                        isEmailInvalid = true
                    } else if !isValidPassword(password) {
                        isPasswordInvalid = true
                    } else if password != confirmPassword {
                        isPasswordsDifferent = true
                    } else {
                        isUsernameInvalid = false
                        isEmailInvalid = false
                        isPasswordInvalid = false
                        isPasswordsDifferent = false
                        isPresentingCadastro = false
                        
                        insertUser()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeInOut) {
                                appState = .navegacao
                            }
                        }
                    }
                }
                
            }) {
                Text("Entre no CineFilés")
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(
                        canContinue ? .blue : .gray
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }
            .disabled(!canContinue)
            
            HStack (spacing: 4) {
                Text("Já tem uma conta?")
                
                Button {
                    withAnimation {
                        isPresentingCadastro = false
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.easeInOut) {
                            isPresentingLogin = true
                        }
                    }
                } label: {
                    Text("Entre aqui")
                        .foregroundStyle(.red)
                        .fontWeight(.semibold)
                }
            }
            .font(.subheadline)
            
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
    }
    
    private func insertUser() {
        let user = Usuario(username: username, email: email, senha: password)
        modelContext.insert(user)
    }
}
