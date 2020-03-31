//
//  TabBarType.swift
//  MusicApp
//
//  Created by Vadim on 14/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation
import UIKit

enum TabBarType: CaseIterable {
    
    case search
    case library
    
    var title: String {
        switch self {
        case .search: return "Search".localized()
        case .library: return "Library".localized()
        }
    }
    
    var image: UIImage? {
        switch self {
        case .search: return Assets.Image.magnifyingGlass
        case .library: return Assets.Image.musicNoteList
        }
    }
    
    func buildNavigationController(for viewController: UIViewController) -> UINavigationController {        
        let navigationViewController = UINavigationController(rootViewController: viewController)
        
        navigationViewController.tabBarItem.image = self.image
        navigationViewController.tabBarItem.title = self.title
        viewController.navigationItem.title = self.title
        navigationViewController.navigationBar.prefersLargeTitles = true
        
        return navigationViewController
    }
}
