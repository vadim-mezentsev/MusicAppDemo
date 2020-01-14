//
//  MainTabBarController.swift
//  MusicApp
//
//  Created by Vadim on 14/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = TabBarType.allCases.map { $0.buildViewController() }
        tabBar.tintColor = .systemPink
    }

}
