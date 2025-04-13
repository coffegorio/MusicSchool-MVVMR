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
        showPreview()
    }
    
    func showPreview() {
        let previewView = PreviewView()
        let previewViewModel = PreviewViewModel(router: self)
        previewView.viewModel = previewViewModel
        navigationController?.pushViewController(previewView, animated: true)
    }
}
