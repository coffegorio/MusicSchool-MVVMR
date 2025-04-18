//
//  AuthViewModel.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 14.04.2025.
//

import Foundation
import Combine
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var login: String = ""
    @Published var password: String = ""
    @Published var isLoginEnabled: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private weak var router: AuthRouter?
    private let authManager = AuthManager.shared
    
    init(router: AuthRouter? = nil) {
        self.router = router
        setupValidation()
        checkCurrentUser()
    }
    
    private func setupValidation() {
        Publishers.CombineLatest($login, $password)
            .map { email, password in
                let isValidEmail = self.isValidEmail(email)
                let isPasswordValid = password.count >= 6
                return !email.isEmpty && !password.isEmpty && isValidEmail && isPasswordValid
            }
            .assign(to: \.isLoginEnabled, on: self)
            .store(in: &cancellables)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func checkCurrentUser() {
        if authManager.isUserLoggedIn {
            isLoading = true
            authManager.fetchCurrentUser()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        print("Ошибка получения данных пользователя: \(error.message)")
                        _ = self?.authManager.signOut()
                    }
                }, receiveValue: { [weak self] _ in
                    self?.router?.showMainScreens()
                })
                .store(in: &cancellables)
        }
    }
    
    func authorize() {
        isLoading = true
        errorMessage = ""
        showError = false
        
        if !isInternetAvailable() {
            isLoading = false
            errorMessage = "Отсутствует подключение к интернету"
            showError = true
            return
        }
        
        print("Попытка авторизации с email: \(login)")
        
        authManager.signInUser(email: login, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.message
                    self?.showError = true
                    print("Ошибка авторизации: \(error.message)")
                }
            }, receiveValue: { [weak self] _ in
                self?.isLoading = false
                print("Авторизация успешна")
                self?.router?.showMainScreens()
            })
            .store(in: &cancellables)
    }
    
    func goBack() {
        self.router?.goBack()
    }
    
    private func isInternetAvailable() -> Bool {
        return true
    }
}
