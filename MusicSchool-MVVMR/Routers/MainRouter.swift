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
        
    }
    
    func createTabbarController() -> UITabBarController {
        let tabbarController = UITabBarController()
        
        return tabbarController
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
