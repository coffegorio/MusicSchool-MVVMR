//
//  TeacherAuthView.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 14.04.2025.
//

import SwiftUI

struct TeacherAuthView: View {
    
    @ObservedObject var viewModel: TeacherAuthViewModel
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Иконка преподавателя
                Image(systemName: "person.fill.badge.plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding(20)
                    .foregroundColor(Color("AccentColor"))
                
                Spacer()
                
                // Контент в нижней части экрана
                VStack(alignment: .leading, spacing: 20) {
                    // Заголовок
                    Text("Вход для преподавателей")
                        .font(.title2)
                        .foregroundStyle(Color("TextColor"))
                        .padding(.bottom, 20)
                    
                    VStack(spacing: 12) {
                        DefaultTextField(
                            text: $viewModel.email,
                            placeholder: "Электронная почта",
                            leftIcon: Image(systemName: "envelope.fill")
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
                        title: "Войти"
                    )
                    .disabled(!viewModel.isLoginEnabled)
                    .opacity(viewModel.isLoginEnabled ? 1.0 : 0.6)
                    
                    DefaultButton(
                        action: { viewModel.dismiss() },
                        isFill: false,
                        title: "Вернуться"
                    )
                }
                .padding(30)
            }
        }
        .transition(.move(edge: .bottom))
    }
}
