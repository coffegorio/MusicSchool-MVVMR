//
//  SceneDelegate.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 13.04.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var router: PreviewRouter?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        router = PreviewRouter(navigationController: navigationController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        router?.start()
    }
}

