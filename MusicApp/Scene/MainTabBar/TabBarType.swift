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
        case .search: return "Search"
        case .library: return "Library"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .search: return UIImage(systemName: "magnifyingglass")
        case .library: return UIImage(systemName: "music.note.list")
        }
    }
    
    func buildViewController() -> UIViewController {
        let viewController: UIViewController!
        switch self {
        case .search: viewController = SearchViewController()
        case .library: viewController = LibraryViewController()
        }
        
        let navigationViewController = UINavigationController(rootViewController: viewController)
        
        navigationViewController.tabBarItem.image = self.image
        navigationViewController.tabBarItem.title = self.title
        viewController.navigationItem.title = self.title
        navigationViewController.navigationBar.prefersLargeTitles = true
        
        return navigationViewController
    }
}
