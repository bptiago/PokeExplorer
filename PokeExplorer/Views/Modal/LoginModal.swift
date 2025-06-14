//
//  LoginModal.swift
//  CineFiles
//
//  Created by Tiago Prestes on 30/05/25.
//

import SwiftUI
import SwiftData

struct LoginModal: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var appInfo: AppInfo
        
    @Query private var usuarios: [Usuario]
    
    @Binding var isPresentingLogin: Bool
    @Binding var isPresentingCadastro: Bool
    
    @ObservedObject var viewModel = LoginViewModel()
    
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
                                        viewModel.isPasswordInvalid ? MyColors.warning : .clear,
                                        lineWidth: 1
                                    )
                            }
                            .textContentType(.password)
                            
                            if viewModel.isPasswordInvalid {
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
                    
                    if viewModel.isUserUnregistered {
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                            Text("Usuário não encontrado. Tente novamente")
                        }
                        .font(.footnote)
                        .foregroundStyle(MyColors.warning)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .formStyle(.columns)
            }
            
            Button(action: {
                // Passar essa lógica pro viewmodel
                withAnimation {
                    if !viewModel.isValidEmail(viewModel.email) {
                        viewModel.isEmailInvalid = true
                    } else if !viewModel.isValidPassword(viewModel.password) {
                        viewModel.isPasswordInvalid = true
                    } else {
                        viewModel.isEmailInvalid = false
                        viewModel.isPasswordInvalid = false
                        isPresentingCadastro = false
                        
                        guard let user = findUser(email: viewModel.email.lowercased(), password: viewModel.password) else {
                            viewModel.isUserUnregistered = true
                            return
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeInOut) {
                                appInfo.loggedUser = user
                                appInfo.appState = .navegacao
                            }
                        }
                    }
                }
                
            }) {
                Text("Entre no CineFilés")
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
                Text("Não possui uma conta?")
                    .foregroundStyle(MyColors.primary)
                
                Button {
                    withAnimation {
                        isPresentingLogin = false
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.easeInOut) {
                            isPresentingCadastro = true
                        }
                    }
                } label: {
                    Text("Crie agora")
                        .foregroundStyle(MyColors.accent)
                        .fontWeight(.semibold)
                }
            }
            .font(.subheadline)
            
        }
        .padding(.horizontal, MySpacings.big)
        .padding(.vertical, MySpacings.bigger)
    }

    func findUser(email: String, password: String) -> Usuario? {
        let predicate = #Predicate<Usuario> { user in
            user.email == email && user.senha == password
        }
        var descriptor = FetchDescriptor<Usuario>(predicate: predicate)
        descriptor.fetchLimit = 1
        do {
            let users = try modelContext.fetch(descriptor)
            return users.first
        } catch {
            print("Error fetching user by email: \(error)")
            return nil
        }
    }
}
