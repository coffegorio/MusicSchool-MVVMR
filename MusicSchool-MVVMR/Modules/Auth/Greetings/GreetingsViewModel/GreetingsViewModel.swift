//
//  GreetingsViewModel.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 14.04.2025.
//

import Foundation

class GreetingsViewModel {
    private weak var router: AuthRouter?
    
    init(router: AuthRouter? = nil) {
        self.router = router
    }
    
    func navigateToAuth() {
        router?.showAuth()
    }
}
