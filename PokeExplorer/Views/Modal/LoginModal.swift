//
//  LoginModal.swift
//  CineFiles
//
//  Created by Tiago Prestes on 30/05/25.
//

import SwiftUI

struct LoginModal: View {
    @Binding var isPresentingLogin: Bool
    @Binding var isPresentingCadastro: Bool
    @Binding var appState: AppState
    
    @State private var email: String = ""
    @State private var senha: String = ""
        
    private var canContinue: Bool {
        !email.isEmpty && !senha.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            Text("Bem-vindo de volta!")
                .font(.title.bold())
            
            VStack() {
                Form {
                    Section {
                        TextField("",
                                  text: $email,
                                  prompt: Text("Insira seu e-mail")
                            .font(.body)
                            .foregroundStyle(.gray)
                        )
                        .padding(12)
                        .background(.white)
                        .foregroundStyle(.black)
                        .font(.body)
                        .clipShape(.capsule)
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
                                        text: $senha,
                                        prompt: Text("Insira sua senha")
                                .font(.body)
                                .foregroundStyle(.gray)
                            )
                            .padding(12)
                            .foregroundStyle(.black)
                            .background(.white)
                            .font(.body)
                            .clipShape(.capsule)
                            .textContentType(.password)
                        }
                    } header: {
                        Text("Senha")
                            .font(.headline.bold())
                            .foregroundStyle(.white)
                    }
                }
                .formStyle(.columns)
            }
            
            Button(action: {
                withAnimation {
                    isPresentingLogin = false
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeInOut) {
                        appState = .navegacao
                    }
                }
                
            }) {
                Text("Login")
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(
                        .white
                    )
                    .background(
                        canContinue ? .blue : .gray
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }
            .disabled(!canContinue)
            
            HStack (spacing: 4) {
                Text("Não tem uma conta?")
                
                Button {
                    withAnimation {
                        isPresentingLogin = false
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut) {
                            isPresentingCadastro = true
                        }
                    }
                } label: {
                    Text("Crie agora")
                        .foregroundStyle(.yellow)
                        .fontWeight(.semibold)
                }
            }
            .font(.subheadline)
            
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
    }
}
