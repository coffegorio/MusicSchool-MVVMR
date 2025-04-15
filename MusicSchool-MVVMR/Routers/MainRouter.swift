//
//  MainRouter.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 15.04.2025.
//

import UIKit
import SwiftUI

class MainRouter: AppRouter {
    
    func start() {
        let tabBarController = createTabbarController()
        navigationController?.setViewControllers([tabBarController], animated: true)
    }
    
    func createTabbarController() -> UITabBarController {
        let tabbarController = UITabBarController()
        
        // Создаем основные экраны
        let mainScreenView = createMainScreenView()
        let profileScreenView = createProfileScreenView()
        let testScreenView = createTestScreenView()
        let aiScreenView = createAIScreenView()
        
        // Создаем навигационные контроллеры для каждого экрана
        let mainNavController = createNavController(
            for: mainScreenView,
            title: "Главная",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill"),
            hidesNavigationBar: true
        )
        
        let profileNavController = createNavController(
            for: profileScreenView,
            title: "Профиль",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill"),
            hidesNavigationBar: true
        )
        
        let testNavController = createNavController(
            for: testScreenView,
            title: "Тесты",
            image: UIImage(systemName: "checkmark.square"),
            selectedImage: UIImage(systemName: "checkmark.square.fill"),
            hidesNavigationBar: true
        )
        
        let aiNavController = createNavController(
            for: aiScreenView,
            title: "AI",
            image: UIImage(systemName: "brain"),
            selectedImage: UIImage(systemName: "brain.head.profile"),
            hidesNavigationBar: true
        )
        
        // Добавляем контроллеры в таббар
        tabbarController.viewControllers = [
            mainNavController,
            testNavController,
            aiNavController,
            profileNavController
        ]
        
        // Настройка внешнего вида таббара
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "BackgroundColor")
        
        tabbarController.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabbarController.tabBar.scrollEdgeAppearance = appearance
        }
        
        return tabbarController
    }
    
    // MARK: - Создание View для экранов
    
    private func createMainScreenView() -> some View {
        let viewModel = MainScreenViewModel(router: self)
        return MainScreenView(viewModel: viewModel)
    }
    
    private func createProfileScreenView() -> some View {
        let viewModel = ProfileScreenViewModel(router: self)
        return ProfileScreenView(viewModel: viewModel)
    }
    
    private func createTestScreenView() -> some View {
        let viewModel = TestScreenViewModel(router: self)
        return TestScreenView(viewModel: viewModel)
    }
    
    private func createAIScreenView() -> some View {
        let viewModel = AIScreenViewModel(router: self)
        return AIScreenView(viewModel: viewModel)
    }
    
    private func createNavController<V: View>(
        for view: V,
        title: String,
        image: UIImage?,
        selectedImage: UIImage?,
        hidesNavigationBar: Bool = false
    ) -> UINavigationController {
        let hostingController = UIHostingController(rootView: view)
        hostingController.title = title
        hostingController.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        
        let navController = UINavigationController(rootViewController: hostingController)
        navController.navigationBar.isHidden = hidesNavigationBar
        
        return navController
    }
    
}
