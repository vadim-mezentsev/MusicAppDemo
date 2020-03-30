//
//  MainTabBarController.swift
//  MusicApp
//
//  Created by Vadim on 14/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private let miniPlayerViewHeightMultiplayer: CGFloat = 1.4
    private let miniPlayerController: MiniPlayerViewController
    
    // MARK: - Init
    
    init(miniPlayerController: MiniPlayerViewController) {
        self.miniPlayerController = miniPlayerController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupMiniPlayer()
    }
    
    // MARK: - Interface preparation
    
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
