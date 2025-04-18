//
//  MainRouter.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 15.04.2025.
//

import UIKit
import SwiftUI
import FirebaseAuth

class MainRouter: AppRouter {
    
    func start() {
        let tabBarController = createTabbarController()
        navigationController?.setViewControllers([tabBarController], animated: true)
    }
    
    // Функция для возврата на Preview при выходе из аккаунта
    func goToPreview() {
        print("MainRouter: Вызван метод goToPreview()")
        
        // Cначала выход из аккаунта, чтобы при новой загрузке Preview пользователь был не авторизован
        do {
            try Auth.auth().signOut()
            print("MainRouter: Успешный выход из Firebase")
        } catch let error {
            print("MainRouter: Ошибка при выходе из Firebase: \(error.localizedDescription)")
        }
        
        // Получаем window из SceneDelegate
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate,
              let window = sceneDelegate.window else {
            print("MainRouter: ОШИБКА - Не удалось получить window для перезапуска приложения")
            return
        }
        
        print("MainRouter: Успешно получен window")
        
        // Создаем новый корневой контроллер
        let rootNavigationController = UINavigationController()
        rootNavigationController.isNavigationBarHidden = true
        
        // Создаем PreviewRouter и PreviewView
        let previewRouter = PreviewRouter(navigationController: rootNavigationController)
        let previewViewModel = PreviewViewModel(router: previewRouter)
        let previewView = PreviewView()
        previewView.viewModel = previewViewModel
        
        print("MainRouter: PreviewView и PreviewRouter успешно созданы")
        
        // ВАЖНО: Запускаем PreviewRouter до установки нового rootViewController,
        // чтобы PreviewView был уже настроен
        previewRouter.start()
        print("MainRouter: PreviewRouter.start() выполнен")
        
        // Устанавливаем новый корневой контроллер
        window.rootViewController = rootNavigationController
        
        // Применяем дополнительное обновление, чтобы гарантировать применение изменений
        window.makeKeyAndVisible()
        
        // Форсированное обновление размеров окна для гарантированного применения изменений
        let bounds = window.bounds
        window.frame = CGRect(x: bounds.origin.x + 1, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
        window.frame = bounds
        
        print("MainRouter: Установлен новый rootViewController и выполнено обновление окна")
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
