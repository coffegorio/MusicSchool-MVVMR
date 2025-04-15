//
//  ProfileScreenView.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 15.04.2025.
//

import SwiftUI

struct ProfileScreenView: View {
    
    var viewModel: ProfileScreenViewModel
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                // Шапка профиля
                VStack(spacing: 20) {
                    // Аватар
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .foregroundColor(Color("AccentColor"))
                        .padding(.top, 30)
                    
                    // Имя пользователя
                    Text("Иван Иванов")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color("TextColor"))
                    
                    // Статус
                    Text("Ученик • Фортепиано")
                        .font(.subheadline)
                        .foregroundColor(Color("TextColor").opacity(0.7))
                    
                    Divider()
                        .padding(.vertical)
                }
                
                // Информация о профиле
                VStack(spacing: 15) {
                    profileInfoRow(icon: "envelope.fill", title: "Email", value: "ivan@example.com")
                    profileInfoRow(icon: "phone.fill", title: "Телефон", value: "+7 (999) 123-45-67")
                    profileInfoRow(icon: "calendar", title: "Дата рождения", value: "01.01.2010")
                    profileInfoRow(icon: "music.note", title: "Инструмент", value: "Фортепиано")
                    profileInfoRow(icon: "person.fill", title: "Преподаватель", value: "Петров П.П.")
                }
                .padding()
                
                Spacer()
                
                // Кнопка выхода
                Button(action: {
                    // Выход из профиля
                }) {
                    Text("Выйти из аккаунта")
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("SecondaryBackgroundColor"))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding()
        }
    }
    
    private func profileInfoRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(Color("AccentColor"))
                .frame(width: 20, height: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(Color("TextColor").opacity(0.7))
                
                Text(value)
                    .foregroundColor(Color("TextColor"))
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

