//
//  ProfileScreenViewModel.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 15.04.2025.
//

import Foundation
import Combine

class ProfileScreenViewModel: ObservableObject {
    private weak var router: MainRouter?
    private let authManager = AuthManager.shared
    
    @Published var userName: String = "Пользователь"
    @Published var userSurname: String = ""
    @Published var userEmail: String = ""
    @Published var userRole: String = "Ученик"
    @Published var userInstrument: String = ""
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(router: MainRouter? = nil) {
        self.router = router
        loadUserData()
    }
    
    // Загрузка данных пользователя
    func loadUserData() {
        isLoading = true
        
        authManager.fetchCurrentUser()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Ошибка при загрузке данных пользователя: \(error.message)")
                }
            }, receiveValue: { [weak self] userModel in
                self?.isLoading = false
                self?.updateUserInfo(with: userModel)
            })
            .store(in: &cancellables)
    }
    
    // Обновление данных пользователя
    private func updateUserInfo(with userModel: UserModel) {
        userName = userModel.name
        userSurname = userModel.surname
        userEmail = userModel.email
        userInstrument = userModel.mainInstrument
        userRole = userModel.role == "teacher" ? "Преподаватель" : "Ученик"
    }
    
    // Выход из аккаунта
    func signOut() {
        print("ProfileScreenViewModel: Вызван метод signOut()")
        if router == nil {
            print("ProfileScreenViewModel: ОШИБКА - router равен nil!")
        } else {
            print("ProfileScreenViewModel: router существует, вызываем goToPreview()")
        }
        // Перенаправляем на Preview, который уже содержит логику выхода из аккаунта
        router?.goToPreview()
        print("ProfileScreenViewModel: Метод goToPreview() вызван")
    }
    
    // Формирование полного имени пользователя
    var fullName: String {
        return "\(userName) \(userSurname)".trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // Формирование строки статуса
    var statusString: String {
        var status = userRole
        
        if !userInstrument.isEmpty {
            status += " • \(userInstrument)"
        }
        
        return status
    }
}
