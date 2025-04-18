//
//  ProfileScreenView.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 15.04.2025.
//

import SwiftUI
import FirebaseAuth

struct ProfileScreenView: View {
    
    @ObservedObject var viewModel: ProfileScreenViewModel
    @State private var showLogoutAlert = false
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            } else {
                ScrollView {
                    VStack {
                        // Шапка профиля
                        VStack(spacing: 20) {
                            // Аватар
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 120)
                                .foregroundColor(Color("AccentColor"))
                                .padding(.top, 30)
                            
                            // Имя пользователя
                            Text(viewModel.fullName)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color("TextColor"))
                                .multilineTextAlignment(.center)
                            
                            // Статус
                            Text(viewModel.statusString)
                                .font(.subheadline)
                                .foregroundColor(Color("TextColor").opacity(0.7))
                            
                            Divider()
                                .padding(.vertical)
                        }
                        
                        // Информация о профиле
                        VStack(spacing: 15) {
                            if !viewModel.userEmail.isEmpty {
                                profileInfoRow(icon: "envelope.fill", title: "Email", value: viewModel.userEmail)
                            }
                            
                            if !viewModel.userInstrument.isEmpty {
                                profileInfoRow(icon: "music.note", title: "Инструмент", value: viewModel.userInstrument)
                            }
                        }
                        .padding()
                        
                        Spacer()
                        
                        // Кнопка выхода
                        Button(action: {
                            showLogoutAlert = true
                        }) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .foregroundColor(.red)
                                
                                Text("Выйти из аккаунта")
                                    .foregroundColor(.red)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("SecondaryBackgroundColor"))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                        .alert(isPresented: $showLogoutAlert) {
                            Alert(
                                title: Text("Выход из аккаунта"),
                                message: Text("Вы уверены, что хотите выйти из аккаунта?"),
                                primaryButton: .destructive(Text("Выйти")) {
                                    resetAppToPreview()
                                },
                                secondaryButton: .cancel(Text("Отмена"))
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            // При появлении экрана загружаем данные пользователя
            viewModel.loadUserData()
        }
    }
    
    private func profileInfoRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(Color("AccentColor"))
                .frame(width: 20, height: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(Color("TextColor").opacity(0.7))
                
                Text(value)
                    .foregroundColor(Color("TextColor"))
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
    
    // Метод для сброса приложения к экрану Preview
    private func resetAppToPreview() {
        // Выход из Firebase Auth
        do {
            try FirebaseAuth.Auth.auth().signOut()
            print("ProfileScreenView: Успешный выход из Firebase")
        } catch let error {
            print("ProfileScreenView: Ошибка при выходе из Firebase: \(error.localizedDescription)")
        }
        
        // Получаем ссылку на SceneDelegate через окно
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate,
              let window = sceneDelegate.window else {
            print("ProfileScreenView: Не удалось получить окно для перезапуска приложения")
            return
        }
        
        // Создаем новый стек навигации
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        
        // Создаем PreviewRouter и его компоненты
        let previewRouter = PreviewRouter(navigationController: navigationController)
        
        // Инициализируем PreviewView и ViewModel
        let previewView = PreviewView()
        let previewViewModel = PreviewViewModel(router: previewRouter) 
        previewView.viewModel = previewViewModel
        
        // Устанавливаем PreviewView как единственный контроллер в стеке навигации
        navigationController.setViewControllers([previewView], animated: false)
        
        // Затем устанавливаем новый корневой контроллер
        window.rootViewController = navigationController
        
        // Обновляем окно
        window.makeKeyAndVisible()
        
        // НЕ вызываем previewRouter.start(), так как это
        // вызовет showPreview() повторно и приведет к дублированию
    }
}

