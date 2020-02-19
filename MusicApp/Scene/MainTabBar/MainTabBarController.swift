//
//  MainTabBarController.swift
//  MusicApp
//
//  Created by Vadim on 14/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let miniPlayerViewHeightMultiplayer: CGFloat = 1.4
    
    var miniPlayerController: MiniPlayerViewController! {
        didSet {
            setupMiniPlayer()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .systemPink
        tabBar.backgroundColor = .clear
    }
    
    private func setupMiniPlayer() {
        let miniPlayerView = miniPlayerController.miniPlayerView
        
        addChild(miniPlayerController)
        view.addSubview(miniPlayerView)
        miniPlayerController.didMove(toParent: self)
        
        miniPlayerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            miniPlayerView.heightAnchor.constraint(equalToConstant: tabBar.frame.height * miniPlayerViewHeightMultiplayer),
            miniPlayerView.widthAnchor.constraint(equalToConstant: view.frame.width),
            miniPlayerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -tabBar.frame.height)
        ])
    }

}
