//
//  GreetingsView.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 14.04.2025.
//

import SwiftUI

struct GreetingsView: View {
    
    var viewModel: GreetingsViewModel
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image("LogoImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Добро пожаловать!")
                        .font(.title)
                        .foregroundStyle(Color("TextColor"))
                        
                    VStack {
                        (Text("Это приложение создано специально для наших ")
                        + Text("любимых учеников").foregroundColor(Color("AccentColor")).bold()
                        + Text("! Здесь вы сможете ")
                        + Text("отслеживать свой прогресс").foregroundColor(Color("AccentColor")).bold()
                        + Text(", закреплять темы, изученные на уроках, выполнять различные ")
                        + Text("интересные задания").foregroundColor(Color("AccentColor")).bold()
                        + Text(", а также пользоваться своим личным ")
                        + Text("ИИ-ассистентом").foregroundColor(Color("AccentColor")).bold()
                        + Text(", который поможет разобраться с любой проблемой, возникшей на вашем музыкальном пути!"))
                            .font(.subheadline)
                            .foregroundStyle(Color("TextColor"))
                    }
                    .padding()
                    .background(Color("SecondaryBackgroundColor").clipShape(RoundedRectangle(cornerRadius: 20)))
                    
                    DefaultButton(action: {
                        viewModel.navigateToAuth()
                    }, isFill: true, title: "Начать")
                }
                .padding(30)
            }
        }
    }
}
