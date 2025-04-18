//
//  PreviewViewModel.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 13.04.2025.
//

import Foundation
import Combine

class PreviewViewModel {
    private weak var router: PreviewRouter?
    private var authRouter: AuthRouter?
    private let authManager = AuthManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init(router: PreviewRouter? = nil) {
        self.router = router
        self.authRouter = AuthRouter(navigationController: router?.navigationController)
    }
    
    func checkAuthAndNavigate() {
        print("PreviewViewModel: Вызван метод checkAuthAndNavigate()")
        
        if authManager.isUserLoggedIn {
            print("PreviewViewModel: Пользователь залогинен, запрашиваем данные пользователя")
            
            authManager.fetchCurrentUser()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    if case .failure = completion {
                        print("PreviewViewModel: Ошибка при получении данных пользователя, выходим из аккаунта")
                        _ = self?.authManager.signOut()
                        self?.navigateToGreetings()
                    }
                }, receiveValue: { [weak self] _ in
                    print("PreviewViewModel: Данные пользователя получены, переходим на главный экран")
                    self?.navigateToMainScreens()
                })
                .store(in: &cancellables)
        } else {
            print("PreviewViewModel: Пользователь не залогинен, переходим на экран приветствия")
            navigateToGreetings()
        }
    }
    
    private func navigateToGreetings() {
        print("PreviewViewModel: Переход на экран приветствия")
        
        // Дополнительная логика для отладки
        if let navigationController = router?.navigationController {
            print("PreviewViewModel: Текущий стек контроллеров: \(navigationController.viewControllers)")
        }
        
        if router == nil {
            print("PreviewViewModel: ОШИБКА - router равен nil!")
        }
        if authRouter == nil {
            print("PreviewViewModel: ОШИБКА - authRouter равен nil!")
        }
        self.authRouter?.showGreetings()
        print("PreviewViewModel: Метод showGreetings() вызван")
    }
    
    private func navigateToMainScreens() {
        print("PreviewViewModel: Переход на главный экран")
        if router == nil {
            print("PreviewViewModel: ОШИБКА - router равен nil!")
        }
        if authRouter == nil {
            print("PreviewViewModel: ОШИБКА - authRouter равен nil!")
        }
        self.authRouter?.showMainScreens()
        print("PreviewViewModel: Метод showMainScreens() вызван")
    }
}
