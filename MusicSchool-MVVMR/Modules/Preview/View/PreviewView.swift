//
//  PreviewView.swift
//  MusicSchool-MVVMR
//
//  Created by Егорио on 13.04.2025.
//

import UIKit
import Lottie

class PreviewView: UIViewController {
    
    var viewModel: PreviewViewModel?
    
    lazy private var lottieView: LottieAnimationView = {
        $0.frame.size = CGSize(width: view.frame.width - 80, height: view.frame.width - 80)
        $0.center = view.center
        $0.loopMode = .loop
        return $0
    }(LottieAnimationView(name: "PreviewAnimation"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "BackgroundColor")
        self.view.addSubview(lottieView)
        lottieView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) {
            self.viewModel?.navigateToGreetings()
        }
    }
}
