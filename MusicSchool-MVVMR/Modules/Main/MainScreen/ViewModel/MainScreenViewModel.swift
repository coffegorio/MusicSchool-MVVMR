//
//  MainScreenViewModel.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 15.04.2025.
//

import Foundation

class MainScreenViewModel {
    private weak var router: MainRouter?
    
    init(router: MainRouter? = nil) {
        self.router = router
    }
}
