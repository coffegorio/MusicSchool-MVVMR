//
//  Router.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 13.04.2025.
//

import UIKit
import SwiftUI

protocol BaseRouter: AnyObject {
    var navigationController: UINavigationController? { get set }
    
    func push(_ viewController: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func present(_ viewController: UIViewController, animated: Bool)
    func dismiss(animated: Bool)
    func presentAsSheet(_ viewController: UIViewController, animated: Bool)
    func presentAsSheet(_ viewController: UIViewController, 
                       animated: Bool, 
                       detents: [UISheetPresentationController.Detent], 
                       showGrabber: Bool)
    func presentModal(_ viewController: UIViewController, animated: Bool)
}

class AppRouter: BaseRouter {
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
        navigationController?.isNavigationBarHidden = true
    }
    
    func push(_ viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }
    
    func present(_ viewController: UIViewController, animated: Bool) {
        navigationController?.present(viewController, animated: animated)
    }
    
    func dismiss(animated: Bool) {
        navigationController?.dismiss(animated: animated)
    }
    
    func presentAsSheet(_ viewController: UIViewController, animated: Bool) {
        presentAsSheet(viewController, animated: animated, detents: [.medium(), .large()], showGrabber: true)
    }
    
    func presentAsSheet(_ viewController: UIViewController, 
                       animated: Bool, 
                       detents: [UISheetPresentationController.Detent] = [.medium(), .large()], 
                       showGrabber: Bool = true) {
        
        if #available(iOS 15.0, *) {
            viewController.modalPresentationStyle = .pageSheet
            
            if let sheet = viewController.sheetPresentationController {
                sheet.detents = detents
                if #available(iOS 16.0, *) {
                    sheet.largestUndimmedDetentIdentifier = detents.first?.identifier
                } else {
                    sheet.largestUndimmedDetentIdentifier = .medium
                }
                
                sheet.prefersScrollingExpandsWhenScrolledToEdge = true
                sheet.prefersEdgeAttachedInCompactHeight = true
                sheet.prefersGrabberVisible = showGrabber
            }
            
            navigationController?.present(viewController, animated: animated)
        } else {
            viewController.modalPresentationStyle = .formSheet
            navigationController?.present(viewController, animated: animated)
        }
    }
    
    func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        navigationController?.setNavigationBarHidden(hidden, animated: animated)
    }
    
    func presentModal(_ viewController: UIViewController, animated: Bool) {
        // Используем .pageSheet вместо .overFullScreen для создания зазора сверху
        viewController.modalPresentationStyle = .pageSheet
        viewController.modalTransitionStyle = .coverVertical
        
        // Обернем контроллер в навигационный контроллер
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.isNavigationBarHidden = true
        navigationController.modalPresentationStyle = .pageSheet
        navigationController.modalTransitionStyle = .coverVertical
        
        // Настраиваем UISheetPresentationController для iOS 15+
        if #available(iOS 15.0, *) {
            if let sheet = navigationController.sheetPresentationController {
                // Устанавливаем только большой детент
                sheet.detents = [.large()]
                // Отключаем "перетягивание" для большего размера
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                // Скругленные углы сверху
                sheet.prefersEdgeAttachedInCompactHeight = true
                // Показываем "захват" сверху
                sheet.prefersGrabberVisible = true
            }
        }
        
        self.navigationController?.present(navigationController, animated: animated)
    }
}
