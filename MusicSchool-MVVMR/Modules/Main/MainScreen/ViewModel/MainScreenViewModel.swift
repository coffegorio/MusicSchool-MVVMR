//
//  MainScreenViewModel.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 15.04.2025.
//

import Foundation
import Combine

class MainScreenViewModel: ObservableObject {
    private weak var router: MainRouter?
    private var cancellables = Set<AnyCancellable>()
    
    private var username: String = "Пользователь"
    
    // Данные для отображения в UI
    @Published var news: [NewsModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    init(router: MainRouter? = nil) {
        self.router = router
        fetchUsername()
        fetchNews()
    }
    
    func fetchUsername() {
        AuthManager.shared.fetchCurrentUser()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Ошибка при получении данных пользователя: \(error.message)")
                }
            }, receiveValue: { [weak self] userModel in
                self?.username = userModel.name
            })
            .store(in: &cancellables)
    }
    
    func getUserName() -> String {
        return username
    }
    
    func greetingForCurrentTime() -> String {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 6..<12:
            return "Доброе утро"
        case 12..<18:
            return "Добрый день"
        case 18..<22:
            return "Добрый вечер"
        default:
            return "Доброй ночи"
        }
    }
    
    // Получение новостей из Firebase
    func fetchNews() {
        isLoading = true
        errorMessage = ""
        showError = false
        
        NewsManager.shared.fetchNews()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                if case .failure(let error) = completion {
                    self.errorMessage = error.message
                    self.showError = true
                    print("Ошибка при получении новостей: \(error.message)")
                }
            }, receiveValue: { [weak self] news in
                guard let self = self else { return }
                self.news = news
            })
            .store(in: &cancellables)
    }
    
    // Обновление списка новостей (для Pull-to-Refresh)
    func refreshNews() {
        fetchNews()
    }
}
