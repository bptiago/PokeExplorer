//
//  StartupView.swift
//  CineFiles
//
//  Created by Tiago Prestes on 30/05/25.
//

import SwiftUI

struct StartupView: View {
    @Binding var appState: AppState;
        
    @State private var isPresentingLogin = false
    @State private var isPresentingCadastro = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Spacer()
                    .frame(height: 560)
                
                Button(action: {
                    withAnimation {
                        isPresentingCadastro = true
                    }
                }) {
                    Text("Junte-se a nós")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                HStack (spacing: 4) {
                    Text("Já tem uma conta?")
                        .foregroundStyle(.white)
                    
                    Button {
                        withAnimation {
                            isPresentingLogin = true
                        }
                    } label: {
                        Text("Entre aqui")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.accentColor)
                    }
                }
                .font(.subheadline)
            }
            .sheet(isPresented: $isPresentingLogin) {
                LoginModal(
                    isPresentingLogin: $isPresentingLogin,
                    isPresentingCadastro: $isPresentingCadastro,
                    appState: $appState
                )
                    .presentationDetents([
                        .height(500)
                    ])
                    .presentationBackground(.ultraThinMaterial)
                    .preferredColorScheme(.dark)
            }
            
            .sheet(isPresented: $isPresentingCadastro, content: {
                CadastroModal(
                    isPresentingLogin: $isPresentingLogin,
                    isPresentingCadastro: $isPresentingCadastro,
                    appState: $appState
                )
                    .presentationDetents([
                        .height(700)
                    ])
                    .presentationBackground(.ultraThinMaterial)
                    .preferredColorScheme(.dark)
            })
            
            .padding(.horizontal, 24)
        }
    }
}
