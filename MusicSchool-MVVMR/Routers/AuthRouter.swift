//
//  AuthRouter.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 14.04.2025.
//

import UIKit
import SwiftUI

class AuthRouter: AppRouter {
    
    func start() {
        showGreetings()
    }
    
    func showGreetings() {
        let viewModel = GreetingsViewModel(router: self)
        let greetingsView = GreetingsView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: greetingsView)
        push(hostingController, animated: true)
    }
    
    func showAuth() {
        let viewModel = AuthViewModel(router: self)
        let authView = AuthView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: authView)
        push(hostingController, animated: true)
    }
    
    func showTeacherAuth() {
        // Пример использования полноэкранного модального представления для экрана авторизации преподавателя
        let viewModel = TeacherAuthViewModel(router: self)
        let teacherAuthView = TeacherAuthView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: teacherAuthView)
        presentModal(hostingController, animated: true)
    }
    
    func showMainScreens() {
        // Создаем MainRouter и передаем ему текущий navigationController
        let mainRouter = MainRouter(navigationController: self.navigationController)
        mainRouter.start()
    }
    
    func goBack() {
        pop(animated: true)
    }
}


