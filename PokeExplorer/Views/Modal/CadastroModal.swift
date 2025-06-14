//
//  CadastroModal.swift
//  CineFiles
//
//  Created by Tiago Prestes on 30/05/25.
//

// TODO: EMAIL JÁ EXISTE, COLORAÇÃO E UI

import SwiftUI
import SwiftData

struct CadastroModal: View {
    @Environment(\.modelContext) var modelContext
    @Query private var users: [Usuario]
    
    @StateObject var viewModel = CadastroViewModel()
    
    @Binding var isPresentingLogin: Bool
    @Binding var isPresentingCadastro: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: MySpacings.bigger) {
            Text("Junte-se a nós!")
                .font(.title.bold())
                .foregroundStyle(MyColors.primary)
            
            VStack() {
                Form {
                    Section {
                        VStack {
                            TextField("",
                                      text: $viewModel.username,
                                      prompt: Text("Insira seu nome de usuário")
                                .font(.body)
                                .foregroundStyle(MyColors.secondary)
                            )
                            .padding(12)
                            .foregroundStyle(.black)
                            .background(MyColors.primary)
                            .font(.body)
                            .clipShape(.buttonBorder)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        viewModel.isUsernameInvalid ? MyColors.warning : .clear,
                                        lineWidth: 1
                                    )
                            }
                            .textContentType(.password)
                            
                            if viewModel.isUsernameInvalid {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle")
                                    Text("Nome de usuário precisa ter pelo menos 3 caracteres")
                                }
                                .font(.footnote)
                                .foregroundStyle(MyColors.warning)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    } header: {
                        Text("Nome de usuário")
                            .font(.headline.bold())
                            .foregroundStyle(MyColors.primary)
                    }
                    
                    Spacer()
                        .frame(height: 16)
                    
                    Section {
                        VStack {
                            TextField("",
                                      text: $viewModel.email,
                                      prompt: Text("Insira seu e-mail")
                                .font(.body)
                                .foregroundStyle(MyColors.secondary)
                            )
                            .textInputAutocapitalization(.never)
                            .padding(12)
                            .foregroundStyle(.black)
                            .background(MyColors.primary)
                            .font(.body)
                            .clipShape(.buttonBorder)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        viewModel.isEmailInvalid ? MyColors.warning : .clear,
                                        lineWidth: 1
                                    )
                            }
                            .textContentType(.password)
                            
                            if viewModel.isEmailInvalid {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle")
                                    Text("Formato de e-mail inválido. Tente novamente")
                                }
                                .font(.footnote)
                                .foregroundStyle(MyColors.warning)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    } header: {
                        Text("E-mail")
                            .font(.headline.bold())
                            .foregroundStyle(MyColors.primary)
                    }
                    
                    Spacer()
                        .frame(height: 16)
                    
                    Section {
                        VStack {
                            SecureField("",
                                        text: $viewModel.password,
                                        prompt: Text("Insira sua senha")
                                .font(.body)
                                .foregroundStyle(MyColors.secondary)
                            )
                            .padding(12)
                            .foregroundStyle(.black)
                            .background(MyColors.primary)
                            .font(.body)
                            .clipShape(.buttonBorder)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        viewModel.isPasswordsDifferent ? MyColors.warning : .clear,
                                        lineWidth: 1
                                    )
                            }
                            .textContentType(.password)
                            
                            if viewModel.isPasswordInvalid || viewModel.isPasswordsDifferent {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle")
                                    Text(viewModel.isPasswordInvalid ? "Senha inválida. Deve conter no mínimo 6 caracteres, uma letra maiúscula e um símbolo" : "Senhas incompatíveis. Por favor, tente novamente.")
                                }
                                .font(.footnote)
                                .foregroundStyle(MyColors.warning)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                        }
                    } header: {
                        Text("Senha")
                            .font(.headline.bold())
                            .foregroundStyle(MyColors.primary)
                    }
                    
                    Spacer()
                        .frame(height: 16)
                    
                    Section {
                        VStack {
                            SecureField("",
                                        text: $viewModel.confirmPassword,
                                        prompt: Text("Insira sua senha")
                                .font(.body)
                                .foregroundStyle(MyColors.secondary)
                            )
                            .padding(12)
                            .foregroundStyle(.black)
                            .background(MyColors.primary)
                            .font(.body)
                            .clipShape(.buttonBorder)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        viewModel.isPasswordsDifferent ? MyColors.warning : .clear,
                                        lineWidth: 1
                                    )
                            }
                            .textContentType(.password)
                            
                            if viewModel.isPasswordsDifferent {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle")
                                    Text("Senhas incompatíveis. Por favor, tente novamente.")
                                }
                                .font(.footnote)
                                .foregroundStyle(MyColors.warning)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    } header: {
                        Text("Confirmar senha")
                            .font(.headline.bold())
                            .foregroundStyle(MyColors.primary)
                    }
                }
                .formStyle(.columns)
            }
            
            Button(action: {
                withAnimation {
                    if viewModel.username.count < 3 {
                        viewModel.isUsernameInvalid = true
                    } else if !viewModel.isValidEmail(viewModel.email) {
                        viewModel.isEmailInvalid = true
                    } else if !viewModel.isValidPassword(viewModel.password) {
                        viewModel.isPasswordInvalid = true
                    } else if viewModel.password != viewModel.confirmPassword {
                        viewModel.isPasswordsDifferent = true
                    } else {
                        viewModel.isUsernameInvalid = false
                        viewModel.isEmailInvalid = false
                        viewModel.isPasswordInvalid = false
                        viewModel.isPasswordsDifferent = false
                        isPresentingCadastro = false
                                          
                        isPresentingLogin = true

                        insertUser()
                    }
                }
                
            }) {
                Text("Criar conta")
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(MyColors.primary)
                    .background(
                        viewModel.canContinue ? MyColors.accent : MyColors.disabledButton
                    )
                    .clipShape(.buttonBorder)
            }
            .disabled(!viewModel.canContinue)
            
            HStack (spacing: 4) {
                Text("Já tem uma conta?")
                    .foregroundStyle(MyColors.primary)
                
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
                        .foregroundStyle(MyColors.accent)
                        .fontWeight(.semibold)
                }
            }
            .font(.subheadline)
            
        }
        .padding(.horizontal, MySpacings.big)
        .padding(.vertical, MySpacings.bigger)
    }
    
    func insertUser() {
        let user = Usuario(username: viewModel.username, email: viewModel.email.lowercased(), senha: viewModel.password)
        modelContext.insert(user)
        try? modelContext.save()
    }
}
