//
//  MainScreenView.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 15.04.2025.
//

import SwiftUI

struct MainScreenView: View {
    
    var viewModel: MainScreenViewModel
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Заголовок
                HStack {
                    Text("Музыкальная школа")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("TextColor"))
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Доступные инструменты
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Доступные инструменты")
                                .font(.headline)
                                .foregroundColor(Color("TextColor"))
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    instrumentCard(name: "Гитара", icon: "guitars")
                                    instrumentCard(name: "Барабаны", icon: "music.quarternote.3")
                                    instrumentCard(name: "Укулеле", icon: "music.mic")
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical, 10)
                        
                        // Новости
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Новости")
                                .font(.headline)
                                .foregroundColor(Color("TextColor"))
                                .padding(.horizontal)
                            
                            VStack(spacing: 15) {
                                newsCard(
                                    title: "Концерт классической музыки",
                                    description: "В эту субботу в нашей школе состоится концерт классической музыки с участием наших учеников.",
                                    date: "12 мая",
                                    imageName: "music.note.list"
                                )
                                
                                newsCard(
                                    title: "Новые курсы по гитаре",
                                    description: "Мы открываем новые курсы для начинающих гитаристов. Записывайтесь уже сейчас!",
                                    date: "10 мая",
                                    imageName: "guitars"
                                )
                                
                                newsCard(
                                    title: "Мастер-класс по барабанам",
                                    description: "Известный барабанщик проведет мастер-класс для всех желающих. Не пропустите!",
                                    date: "5 мая",
                                    imageName: "music.quarternote.3"
                                )
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 10)
                        
                        // Полезные материалы
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Полезные материалы")
                                .font(.headline)
                                .foregroundColor(Color("TextColor"))
                                .padding(.horizontal)
                            
                            VStack(spacing: 15) {
                                materialCard(
                                    title: "Основы нотной грамоты",
                                    description: "Изучите базовые принципы чтения нот и музыкальной теории.",
                                    category: "Теория"
                                )
                                
                                materialCard(
                                    title: "Аккорды для начинающих",
                                    description: "Базовые аккорды для гитары и укулеле, которые должен знать каждый.",
                                    category: "Практика"
                                )
                                
                                materialCard(
                                    title: "Ритмические упражнения",
                                    description: "Упражнения для развития чувства ритма для барабанщиков и не только.",
                                    category: "Практика"
                                )
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 10)
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
    
    private func instrumentCard(name: String, icon: String) -> some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(Color("AccentColor"))
                .padding(20)
                .background(Color("SecondaryBackgroundColor"))
                .cornerRadius(12)
            
            Text(name)
                .font(.caption)
                .foregroundColor(Color("TextColor"))
        }
        .frame(width: 100)
    }
    
    private func newsCard(title: String, description: String, date: String, imageName: String) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(Color("AccentColor"))
                .padding(8)
                .background(Color("SecondaryBackgroundColor"))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color("TextColor"))
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(Color("TextColor").opacity(0.7))
                    .lineLimit(2)
                
                Text(date)
                    .font(.caption)
                    .foregroundColor(Color("AccentColor"))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("SecondaryBackgroundColor"))
        .cornerRadius(12)
    }
    
    private func materialCard(title: String, description: String, category: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color("TextColor"))
                
                Spacer()
                
                Text(category)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        category == "Теория" ? Color.blue.opacity(0.2) : Color.green.opacity(0.2)
                    )
                    .foregroundColor(
                        category == "Теория" ? Color.blue : Color.green
                    )
                    .cornerRadius(8)
            }
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(Color("TextColor").opacity(0.7))
                .lineLimit(2)
            
            HStack {
                Spacer()
                
                Button(action: {
                    // Открыть материал
                }) {
                    Text("Подробнее")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color("AccentColor"))
                }
            }
        }
        .padding()
        .background(Color("SecondaryBackgroundColor"))
        .cornerRadius(12)
    }
}
