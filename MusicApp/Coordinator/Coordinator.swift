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
    var miniPlayerViewController: MiniPlayerViewController!
    
    var player: PlayerService = AVPlayerService()
    var library: LibraryService = MemoryLibraryService()
    
    // MARK: - Init
    
    init(window: UIWindow) {
        self.window = window
    
        searchViewController = createSearchViewController()
        libraryViewController = createLibraryViewController()
        mainPlayerViewController = createMainPlayerViewController()
        miniPlayerViewController = createMiniPlayerViewController()
        
        rootViewController = MainTabBarController()
        rootViewController.miniPlayerController = miniPlayerViewController
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
        let searchViewController = SearchViewController(libraryService: library)
        searchViewController.output.playTrackHandler = searchViewControllerPlayTrackHandler
        return searchViewController
    }
    
    private func searchViewControllerPlayTrackHandler(trackModel: TrackContentModel) {
        guard let trackUrlString = trackModel.previewUrl, let trackUrl = URL(string: trackUrlString) else { return }
        mainPlayerViewController.input.setTrack(from: trackModel)
        miniPlayerViewController.input.setTrack(from: trackModel)
        player.setTrack(from: trackUrl)
    }

    // MARK: - LibraryViewController setup
    
    private func createLibraryViewController() -> LibraryViewController {
        let libraryViewController = LibraryViewController()
        return libraryViewController
    }
    
    // MARK: - MainPlayerViewController setup
    
    private func createMainPlayerViewController() -> MainPlayerViewController {
        let mainPlayerViewController = MainPlayerViewController(playerService: player)
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
    
    // MARK: - MiniPlayerViewController setup
    
    private func createMiniPlayerViewController() -> MiniPlayerViewController {
        let miniPlayerViewController = MiniPlayerViewController(playerService: player)
        miniPlayerViewController.output.playNextTrackHandler = miniPlayerViewControllerPlayNextTrackHandler
        miniPlayerViewController.output.showMainPlayerHandler = miniPlayerViewControllerShowMainPlayerHandler
        return miniPlayerViewController
    }
    
    private func miniPlayerViewControllerPlayNextTrackHandler() {
        searchViewController.input.playNextTrack()
    }
    
    private func miniPlayerViewControllerShowMainPlayerHandler() {
        let mainPlayerTransition = MainPlayerTransition()
        mainPlayerTransition.tabBarView = rootViewController.tabBar
        mainPlayerViewController.transitioningDelegate = mainPlayerTransition
        miniPlayerViewController.present(mainPlayerViewController, animated: true)
    }

}
