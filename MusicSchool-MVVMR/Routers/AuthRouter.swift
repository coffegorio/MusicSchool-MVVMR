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
    
}


