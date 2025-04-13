//
//  AuthViewModel.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 14.04.2025.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var login: String = ""
    @Published var password: String = ""
    @Published var isLoginEnabled: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private weak var router: AuthRouter?
    
    init(router: AuthRouter? = nil) {
        self.router = router
        setupValidation()
    }
    
    private func setupValidation() {
        Publishers.CombineLatest($login, $password)
            .map { login, password in
                return !login.isEmpty && !password.isEmpty
            }
            .assign(to: \.isLoginEnabled, on: self)
            .store(in: &cancellables)
    }
    
    func authorize() {
        // Здесь будет логика авторизации
        print("Авторизация с логином: \(login) и паролем: \(password)")
    }
    
    func showTeacherAuth() {
        // Здесь будет переход на экран авторизации для преподавателей
        print("Переход на экран авторизации для преподавателей")
    }
}
