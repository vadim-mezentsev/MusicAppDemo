//
//  Coordinator.swift
//  MusicApp
//
//  Created by Vadim on 17/02/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import UIKit

protocol Coordinator {
    func start()
}

class MainCoordinator: Coordinator {
    
    // MARK: - Properties

    var window: UIWindow!
    var rootViewController: MainTabBarController!
    var searchViewController: SearchViewController!
    var libraryViewController: LibraryViewController!
    var mainPlayerViewController: MainPlayerViewController!
    
    // MARK: - Init
    
    init(window: UIWindow) {
        self.window = window
        
        rootViewController = MainTabBarController()
        searchViewController = createSearchViewController()
        libraryViewController = createLibraryViewController()
        mainPlayerViewController = createMainPlayerViewController()
        
        rootViewController.viewControllers = [
            TabBarType.search.buildNavigationController(for: searchViewController),
            TabBarType.library.buildNavigationController(for: libraryViewController)
        ]
    }
    
    // MARK: - Coordinator
    
    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    // MARK: - SearchViewController setup
    
    private func createSearchViewController() -> SearchViewController {
        let searchViewController = SearchViewController()
        searchViewController.output.playTrackHandler = searchViewControllerPlayTrackHandler
        return searchViewController
    }
    
    private func searchViewControllerPlayTrackHandler(trackModel: TrackContentModel) {
        presentMainPlayer(model: trackModel)
    }

    // MARK: - LibraryViewController setup
    
    private func createLibraryViewController() -> LibraryViewController {
        let libraryViewController = LibraryViewController()
        return libraryViewController
    }
    
    // MARK: - MainPlayerViewController setup
    
    private func createMainPlayerViewController() -> MainPlayerViewController {
        let mainPlayerViewController = MainPlayerViewController()
        mainPlayerViewController.output.playNextTrackHandler = mainPlayerViewControllerPlayNextTrackHandler
        mainPlayerViewController.output.playPreviousTrackHandler = mainPlayerViewControllerPlayPreviousTrackHandler
        return mainPlayerViewController
    }
    
    private func mainPlayerViewControllerPlayNextTrackHandler() {
        searchViewController.input.playNextTrack()
    }
    
    private func mainPlayerViewControllerPlayPreviousTrackHandler() {
        searchViewController.input.playPreviousTrack()
    }

    private func presentMainPlayer(model: TrackContentModel) {
        mainPlayerViewController.input.setTrack(from: model)
        if mainPlayerViewController.view.window == nil {
            rootViewController.present(mainPlayerViewController, animated: true)
        }
    }
}
