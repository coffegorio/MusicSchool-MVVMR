//
//  AuthManager.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 16.04.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

enum AuthError: Error {
    case userNotFound
    case invalidCredentials
    case malformedCredentials
    case networkError
    case serverError
    case unknownError(String)
    
    var message: String {
        switch self {
        case .userNotFound:
            return "Пользователь с указанным email не найден"
        case .invalidCredentials:
            return "Неверный email или пароль"
        case .malformedCredentials:
            return "Некорректные учетные данные. Возможно, аккаунт был удален или отключен"
        case .networkError:
            return "Ошибка сети. Проверьте подключение к интернету"
        case .serverError:
            return "Ошибка сервера. Пожалуйста, попробуйте позже"
        case .unknownError(let details):
            return "Неизвестная ошибка: \(details)"
        }
    }
}

class AuthManager {
    
    static let shared = AuthManager()
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    private init() {}
    
    var currentUser: FirebaseAuth.User? {
        return auth.currentUser
    }
    
    var isUserLoggedIn: Bool {
        return auth.currentUser != nil
    }
    
    func signInUser(email: String, password: String) -> AnyPublisher<UserModel, AuthError> {
        return Future<UserModel, AuthError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.unknownError("Ошибка инициализации AuthManager")))
                return
            }
            
            print("Попытка входа для email: \(email)")
            
            self.auth.signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("Ошибка входа: \(error.localizedDescription)")
                    print("Детали ошибки: \(error)")
                    
                    let nsError = error as NSError
                    let errorCode = nsError.code
                    let errorMessage = nsError.localizedDescription
                    
                    print("Код ошибки: \(errorCode), сообщение: \(errorMessage)")
                    
                    switch errorCode {
                    case AuthErrorCode.userNotFound.rawValue:
                        promise(.failure(.userNotFound))
                    case AuthErrorCode.wrongPassword.rawValue:
                        promise(.failure(.invalidCredentials))
                    case AuthErrorCode.invalidCredential.rawValue, AuthErrorCode.credentialAlreadyInUse.rawValue:
                        promise(.failure(.malformedCredentials))
                    case AuthErrorCode.networkError.rawValue:
                        promise(.failure(.networkError))
                    default:
                        promise(.failure(.unknownError("Код ошибки: \(errorCode), \(errorMessage)")))
                    }
                    return
                }
                
                guard let user = authResult?.user else {
                    promise(.failure(.unknownError("Аутентификация успешна, но информация о пользователе недоступна")))
                    return
                }
                
                print("Аутентификация успешна для пользователя: \(user.uid), email: \(user.email ?? "неизвестно")")
                
                self.testFirestoreAccess { hasAccess in
                    if !hasAccess {
                        print("У пользователя нет доступа к Firestore. Проверьте правила безопасности.")
                        promise(.failure(.serverError))
                        return
                    }
                    
                    self.fetchUserData(for: user.uid) { result in
                        switch result {
                        case .success(let userModel):
                            promise(.success(userModel))
                        case .failure(let error):
                            if case .userNotFound = error {
                                print("Пользователь авторизован, но документ в Firestore не найден. Создаем базовую модель.")
                                if let email = user.email {
                                    let displayName = user.displayName ?? "Пользователь"
                                    let nameParts = displayName.split(separator: " ")
                                    
                                    let name = nameParts.first.map(String.init) ?? "Пользователь"
                                    let surname = nameParts.count > 1 ? String(nameParts[1]) : ""
                                    
                                    let basicUserModel = UserModel(
                                        name: name,
                                        surname: surname,
                                        age: 0,
                                        mainInstrument: "",
                                        secondInstrument: nil,
                                        currentStage: 0,
                                        currentLesson: 0,
                                        email: email,
                                        role: "student"
                                    )
                                    
                                    // Создаем документ пользователя в Firestore
                                    self.createUserDocument(user: user, userModel: basicUserModel)
                                    
                                    promise(.success(basicUserModel))
                                } else {
                                    promise(.failure(.userNotFound))
                                }
                            } else {
                                promise(.failure(error))
                            }
                        }
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Тестирование доступа к Firestore
    private func testFirestoreAccess(completion: @escaping (Bool) -> Void) {
        guard let uid = auth.currentUser?.uid else {
            completion(false)
            return
        }
        
        // Пробуем прочитать пустую коллекцию, чтобы проверить доступ
        db.collection("access_test").document(uid).getDocument { document, error in
            if let error = error {
                print("Ошибка при проверке доступа: \(error.localizedDescription)")
                if (error.localizedDescription.contains("permission") || 
                    error.localizedDescription.contains("Missing or insufficient permissions")) {
                    completion(false)
                } else {
                    // Если ошибка не связана с отсутствием прав, считаем, что доступ есть
                    completion(true)
                }
            } else {
                completion(true)
            }
        }
    }
    
    // Создание документа пользователя в Firestore
    private func createUserDocument(user: FirebaseAuth.User, userModel: UserModel) {
        let userData: [String: Any] = [
            "name": userModel.name,
            "surname": userModel.surname,
            "age": userModel.age,
            "mainInstrument": userModel.mainInstrument,
            "currentStage": userModel.currentStage,
            "currentLesson": userModel.currentLesson,
            "email": userModel.email,
            "role": userModel.role
        ]
        
        if let secondInstrument = userModel.secondInstrument {
            var mutableData = userData
            mutableData["secondInstrument"] = secondInstrument
            
            db.collection("users").document(user.uid).setData(mutableData) { error in
                if let error = error {
                    print("Ошибка при создании документа пользователя: \(error.localizedDescription)")
                } else {
                    print("Документ пользователя успешно создан в Firestore")
                }
            }
        } else {
            db.collection("users").document(user.uid).setData(userData) { error in
                if let error = error {
                    print("Ошибка при создании документа пользователя: \(error.localizedDescription)")
                } else {
                    print("Документ пользователя успешно создан в Firestore")
                }
            }
        }
    }
    
    // Выход пользователя из системы
    func signOut() -> Bool {
        do {
            try auth.signOut()
            return true
        } catch {
            print("Ошибка при выходе: \(error.localizedDescription)")
            return false
        }
    }
    
    // Получение данных пользователя из Firestore
    private func fetchUserData(for uid: String, completion: @escaping (Result<UserModel, AuthError>) -> Void) {
        print("Запрос данных пользователя из Firestore для UID: \(uid)")
        
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                print("Ошибка при получении данных пользователя: \(error.localizedDescription)")
                print("Детали ошибки: \(error)")
                completion(.failure(.serverError))
                return
            }
            
            guard let document = document else {
                print("Документ для пользователя \(uid) не существует")
                completion(.failure(.userNotFound))
                return
            }
            
            if !document.exists {
                print("Документ для пользователя \(uid) существует, но пуст")
                completion(.failure(.userNotFound))
                return
            }
            
            guard let data = document.data() else {
                print("Документ для пользователя \(uid) не содержит данных")
                completion(.failure(.userNotFound))
                return
            }
            
            print("Получены данные пользователя из Firestore: \(data)")
            
            let name = data["name"] as? String ?? ""
            let surname = data["surname"] as? String ?? ""
            let age = data["age"] as? Int ?? 0
            let mainInstrument = data["mainInstrument"] as? String ?? ""
            let secondInstrument = data["secondInstrument"] as? String
            let currentStage = data["currentStage"] as? Int ?? 0
            let currentLesson = data["currentLesson"] as? Int ?? 0
            let email = data["email"] as? String ?? ""
            let role = data["role"] as? String ?? ""
            
            let userModel = UserModel(
                name: name,
                surname: surname,
                age: age,
                mainInstrument: mainInstrument,
                secondInstrument: secondInstrument,
                currentStage: currentStage, 
                currentLesson: currentLesson,
                email: email,
                role: role
            )
            
            print("Создана модель пользователя: \(userModel)")
            completion(.success(userModel))
        }
    }
    
    // Получение данных текущего пользователя
    func fetchCurrentUser() -> AnyPublisher<UserModel, AuthError> {
        return Future<UserModel, AuthError> { [weak self] promise in
            guard let self = self, let currentUser = self.currentUser else {
                promise(.failure(.userNotFound))
                return
            }
            
            print("Запрос данных для текущего пользователя: \(currentUser.uid)")
            
            self.fetchUserData(for: currentUser.uid) { result in
                switch result {
                case .success(let userModel):
                    promise(.success(userModel))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
