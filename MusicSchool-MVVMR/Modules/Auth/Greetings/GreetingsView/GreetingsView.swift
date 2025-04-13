//
//  GreetingsView.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 14.04.2025.
//

import SwiftUI

struct GreetingsView: View {
    
    var viewModel: GreetingsViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    // Определяем цвет акцентов в зависимости от темы
    private var highlightColor: Color {
        colorScheme == .dark ? Color("AccentColor") : Color("ErrorColor")
    }
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Логотип по центру экрана
                Image("LogoImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                
                Spacer()
                
                // Контент в нижней части экрана
                VStack(alignment: .leading, spacing: 20) {
                    Text("Добро пожаловать!")
                        .font(.title)
                        .foregroundStyle(Color("TextColor"))
                        
                    VStack {
                        (Text("Это приложение создано специально для наших ")
                        + Text("любимых учеников").foregroundColor(highlightColor).bold()
                        + Text("! Здесь вы сможете ")
                        + Text("отслеживать свой прогресс").foregroundColor(highlightColor).bold()
                        + Text(", закреплять темы, изученные на уроках, выполнять различные ")
                        + Text("интересные задания").foregroundColor(highlightColor).bold()
                        + Text(", а также пользоваться своим личным ")
                        + Text("ИИ-ассистентом").foregroundColor(highlightColor).bold()
                        + Text(", который поможет разобраться с любой проблемой, возникшей на вашем музыкальном пути!"))
                            .font(.subheadline)
                            .foregroundStyle(Color("TextColor"))
                    }
                    .padding()
                    .background(Color("SecondaryBackgroundColor").clipShape(RoundedRectangle(cornerRadius: 20)))
                    
                    DefaultButton(action: {
                        
                    }, isFill: true, title: "Начать")
                }
                .padding(30)
            }
        }
    }
}
