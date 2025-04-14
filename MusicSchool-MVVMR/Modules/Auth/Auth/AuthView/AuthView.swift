//
//  AuthView.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 14.04.2025.
//

import SwiftUI

struct AuthView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var showTooltip = false
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding(20)
                    .foregroundColor(Color("AccentColor"))
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 20) {
                    ZStack {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(alignment: .center) {
                                Text("Войдите в свой профиль")
                                    .font(.title2)
                                    .foregroundStyle(Color("TextColor"))
                                
                                Spacer()
                                
                                Button(action: {
                                    withAnimation(.spring()) {
                                        showTooltip.toggle()
                                    }
                                }) {
                                    Image(systemName: "questionmark.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(Color("AccentColor"))
                                        .overlay(
                                            Group {
                                                if showTooltip {
                                                    VStack(alignment: .leading, spacing: 8) {
                                                        Text("Для получения доступа к личному кабинету обратитесь к администраторам")
                                                            .font(.caption)
                                                            .foregroundColor(Color("TextColor"))
                                                            .padding(10)
                                                            .multilineTextAlignment(.leading)
                                                            .fixedSize(horizontal: false, vertical: true)
                                                    }
                                                    .frame(width: 220)
                                                    .background(Color("SecondaryBackgroundColor"))
                                                    .cornerRadius(10)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .stroke(Color("BorderColor"), lineWidth: 1)
                                                    )
                                                    .offset(x: -100, y: -70)
                                                    .transition(.opacity.combined(with: .move(edge: .top)))
                                                    .zIndex(1)
                                                    .onTapGesture {
                                                        withAnimation(.spring()) {
                                                            showTooltip = false
                                                        }
                                                    }
                                                }
                                            }
                                        )
                                }
                            }
                            .padding(.bottom, 20)
                        }
                    }
                    .frame(height: 40)
                    
                    VStack(spacing: 12) {
                        DefaultTextField(
                            text: $viewModel.login,
                            placeholder: "Логин",
                            leftIcon: Image(systemName: "person.fill")
                        )
                        
                        DefaultTextField(
                            text: $viewModel.password,
                            placeholder: "Пароль",
                            isSecure: true,
                            leftIcon: Image(systemName: "lock.fill")
                        )
                    }
                    
                    DefaultButton(
                        action: { viewModel.authorize() },
                        isFill: true,
                        title: "Продолжить"
                    )
                    .disabled(!viewModel.isLoginEnabled)
                    .opacity(viewModel.isLoginEnabled ? 1.0 : 0.6)
                    
                    DefaultButton(
                        action: { viewModel.showTeacherAuth() },
                        isFill: false,
                        title: "Авторизация для преподавателя"
                    )
                    
                    DefaultButton(
                        action: {
                            viewModel.goBack()
                        },
                        isFill: false,
                        title: "Назад"
                    )
                }
                .padding(30)
            }
        }
    }
}
