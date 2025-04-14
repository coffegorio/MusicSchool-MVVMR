//
//  TeacherAuth.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 14.04.2025.
//

import Foundation
import Combine

class TeacherAuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoginEnabled: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private weak var router: AuthRouter?
    
    init(router: AuthRouter? = nil) {
        self.router = router
        setupValidation()
    }
    
    private func setupValidation() {
        Publishers.CombineLatest($email, $password)
            .map { email, password in
                return !email.isEmpty && !password.isEmpty && self.isValidEmail(email)
            }
            .assign(to: \.isLoginEnabled, on: self)
            .store(in: &cancellables)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func authorize() {
        // Логика авторизации преподавателя
        print("Авторизация преподавателя с email: \(email) и паролем: \(password)")
    }
    
    func dismiss() {
        router?.dismiss(animated: true)
    }
}
