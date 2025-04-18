//
//  PreviewRouter.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 13.04.2025.
//

import UIKit
import SwiftUI

class PreviewRouter: AppRouter {
    
    func start() {
        print("PreviewRouter: Вызван метод start()")
        showPreview()
        print("PreviewRouter: Метод showPreview() выполнен")
    }
    
    func showPreview() {
        print("PreviewRouter: Вызван метод showPreview()")
        if navigationController == nil {
            print("PreviewRouter: ОШИБКА - navigationController равен nil!")
            return
        }
        
        if let topController = navigationController?.viewControllers.first, topController is PreviewView {
            print("PreviewRouter: PreviewView уже установлен как верхний контроллер, пропускаем")
            return
        }
        
        let previewView = PreviewView()
        let previewViewModel = PreviewViewModel(router: self)
        previewView.viewModel = previewViewModel
        print("PreviewRouter: PreviewView и ViewModel созданы")
        
        navigationController?.setViewControllers([previewView], animated: true)
        print("PreviewRouter: Установлен новый стек контроллеров")
    }
}
