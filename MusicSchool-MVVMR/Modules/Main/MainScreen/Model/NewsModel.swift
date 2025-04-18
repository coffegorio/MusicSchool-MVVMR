//
//  NewsModel.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 18.04.2025.
//

import Foundation
import FirebaseFirestore

struct NewsModel: Identifiable {
    var id: String
    var title: String
    var subtitle: String
    var date: Date
    
    // Форматированная дата для отображения
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

