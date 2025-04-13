//
//  PreviewViewModel.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 13.04.2025.
//

import Foundation

class PreviewViewModel {
    private weak var router: PreviewRouter?
    private var authRouter: AuthRouter?
    
    init(router: PreviewRouter? = nil) {
        self.router = router
        self.authRouter = AuthRouter(navigationController: router?.navigationController)
    }
    
    func navigateToGreetings() {
        self.authRouter?.showGreetings()
    }
}
