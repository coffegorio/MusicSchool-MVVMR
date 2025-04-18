//
//  NewsManager.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 18.04.2025.
//

import Foundation
import FirebaseFirestore
import Combine

enum NewsError: Error {
    case fetchFailed
    case networkError
    case documentNotFound
    case parseError
    
    var message: String {
        switch self {
        case .fetchFailed:
            return "Не удалось загрузить новости"
        case .networkError:
            return "Ошибка сети. Проверьте подключение к интернету"
        case .documentNotFound:
            return "Новости не найдены"
        case .parseError:
            return "Ошибка обработки данных"
        }
    }
}

class NewsManager {
    static let shared = NewsManager()
    
    private let db = Firestore.firestore()
    
    private init() {}
    
    // Получение списка новостей
    func fetchNews() -> AnyPublisher<[NewsModel], NewsError> {
        return Future<[NewsModel], NewsError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.fetchFailed))
                return
            }
            
            // Получаем новости из коллекции "news", сортируем по дате (новые сверху)
            self.db.collection("news")
                .order(by: "date", descending: true)
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Ошибка при получении новостей: \(error.localizedDescription)")
                        promise(.failure(.fetchFailed))
                        return
                    }
                    
                    guard let documents = snapshot?.documents, !documents.isEmpty else {
                        promise(.failure(.documentNotFound))
                        return
                    }
                    
                    // Преобразуем документы в модели
                    var newsItems: [NewsModel] = []
                    
                    for document in documents {
                        let data = document.data()
                        
                        // Получаем поля из документа
                        guard let title = data["title"] as? String,
                              let subtitle = data["subtitle"] as? String,
                              let timestamp = data["date"] as? Timestamp else {
                            continue
                        }
                        
                        // Создаем объект новости
                        let newsItem = NewsModel(
                            id: document.documentID,
                            title: title,
                            subtitle: subtitle,
                            date: timestamp.dateValue()
                        )
                        
                        newsItems.append(newsItem)
                    }
                    
                    if newsItems.isEmpty {
                        promise(.failure(.documentNotFound))
                    } else {
                        promise(.success(newsItems))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
} 
