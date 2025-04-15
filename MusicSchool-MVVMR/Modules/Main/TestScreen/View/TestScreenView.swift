//
//  TestScreenView.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 15.04.2025.
//

import SwiftUI

struct TestScreenView: View {
    
    var viewModel: TestScreenViewModel
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Заголовок
                Text("Тесты и задания")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextColor"))
                    .padding(.top, 20)
                
                // Фильтры
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(["Все", "Теория", "Сольфеджио", "Бас-гитара", "Общее"], id: \.self) { category in
                            Text(category)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(category == "Все" ? Color("AccentColor") : Color("SecondaryBackgroundColor"))
                                .foregroundColor(category == "Все" ? Color("BackgroundColor") : Color("TextColor"))
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Список тестов
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(1...5, id: \.self) { index in
                            testCard(
                                title: "Тест \(index): Теория музыки",
                                description: "Базовые понятия и термины в музыке",
                                questions: 10,
                                time: 15,
                                completed: index % 3 == 0
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                
                Spacer()
            }
        }
    }
    
    private func testCard(title: String, description: String, questions: Int, time: Int, completed: Bool) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color("TextColor"))
                
                Spacer()
                
                if completed {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(Color("TextColor").opacity(0.7))
                .lineLimit(2)
            
            HStack {
                testInfoBadge(icon: "list.bullet", text: "\(questions) вопросов")
                testInfoBadge(icon: "clock", text: "\(time) минут")
                
                Spacer()
                
                Button(action: {
                    // Начать тест
                }) {
                    Text(completed ? "Пройти снова" : "Начать")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Color("BackgroundColor"))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(Color("AccentColor"))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color("SecondaryBackgroundColor"))
        .cornerRadius(12)
    }
    
    private func testInfoBadge(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
            
            Text(text)
                .font(.caption)
        }
        .foregroundColor(Color("TextColor").opacity(0.6))
    }
}

