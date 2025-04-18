//
//  NewsCard.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 18.04.2025.
//

import SwiftUI

// Компонент карточки новости для главного экрана
struct MainScreenNewsCard: View {
    let newsItem: NewsModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Заголовок
            Text(newsItem.title)
                .font(.headline)
                .foregroundColor(Color("TextColor"))
                .lineLimit(2)
            
            // Подзаголовок
            Text(newsItem.subtitle)
                .font(.subheadline)
                .foregroundColor(Color("TextColor").opacity(0.7))
                .lineLimit(3)
            
            // Дата
            HStack {
                Spacer()
                Text(newsItem.formattedDate)
                    .font(.caption)
                    .foregroundColor(Color("TextColor").opacity(0.5))
            }
        }
        .padding(15)
        .background(Color("SecondaryBackgroundColor"))
        .cornerRadius(15)
    }
} 