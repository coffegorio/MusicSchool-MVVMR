//
//  News.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 19.04.2025.
//

import SwiftUI

struct NewsCard: View {
    let newsItem: NewsModel
    
    var body: some View {
        HStack(spacing: 15) {
            // Контент новости
            VStack(alignment: .leading, spacing: 5) {
                Text(newsItem.title)
                    .font(.headline)
                    .foregroundColor(Color("TextColor"))
                    .lineLimit(2)
                
                Text(newsItem.subtitle)
                    .font(.subheadline)
                    .foregroundColor(Color("TextColor").opacity(0.7))
                    .lineLimit(2)
                
                Text(newsItem.formattedDate)
                    .font(.caption)
                    .foregroundColor(Color("TextColor").opacity(0.5))
            }
            .padding(15)
            .background(Color("SecondaryBackgroundColor"))
            .cornerRadius(15)
        }
    }
}
