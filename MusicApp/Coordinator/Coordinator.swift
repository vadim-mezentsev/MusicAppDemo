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
     
    // MARK: - Types
    
    enum PlaySource {
        case search
        case library
    }
    
    // MARK: - Properties

    private var window: UIWindow
    private var rootViewController: MainTabBarController!
    private var searchViewController: SearchViewController!
    private var libraryViewController: LibraryViewController!
    private var mainPlayerViewController: MainPlayerViewController!
    private var miniPlayerViewController: MiniPlayerViewController!
    
    var player: PlayerService = AVPlayerService()
    var library: LibraryService = CoreDataLibraryService()
    var playSource: PlaySource?
    
    // MARK: - Init
    
    init(window: UIWindow) {
        self.window = window
    
        searchViewController = createSearchViewController()
        libraryViewController = createLibraryViewController()
        mainPlayerViewController = createMainPlayerViewController()
        miniPlayerViewController = createMiniPlayerViewController()
        
        rootViewController = MainTabBarController(miniPlayerController: miniPlayerViewController)
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
        let searchViewController = SearchBuilder(libraryService: library).build()
        searchViewController.output.playTrackHandler = searchViewControllerPlayTrackHandler
        return searchViewController
    }
    
    private func searchViewControllerPlayTrackHandler(trackModel: TrackContentModel) {
        playTrack(from: trackModel)
        playSource = .search
        libraryViewController.input.deselectTrack()
    }

    // MARK: - LibraryViewController setup
    
    private func createLibraryViewController() -> LibraryViewController {
        let libraryViewController = LibraryBuilder(libraryService: library).build()
        libraryViewController.output.playTrackHandler = libraryViewControllerPlayTrackHandler
        return libraryViewController
    }
    
    private func libraryViewControllerPlayTrackHandler(trackModel: TrackContentModel) {
        playTrack(from: trackModel)
        playSource = .library
        searchViewController.input.deselectTrack()
    }
    
    // MARK: - MainPlayerViewController setup
    
    private func createMainPlayerViewController() -> MainPlayerViewController {
        let mainPlayerViewController = MainPlayerBuilder(playerService: player).build()
        mainPlayerViewController.output.playNextTrackHandler = mainPlayerViewControllerPlayNextTrackHandler
        mainPlayerViewController.output.playPreviousTrackHandler = mainPlayerViewControllerPlayPreviousTrackHandler
        return mainPlayerViewController
    }
    
    private func mainPlayerViewControllerPlayNextTrackHandler() {
        playNextTrack()
    }
    
    private func mainPlayerViewControllerPlayPreviousTrackHandler() {
        playPreviousTrack()
    }
    
    // MARK: - MiniPlayerViewController setup
    
    private func createMiniPlayerViewController() -> MiniPlayerViewController {
        let miniPlayerViewController = MiniPlayerBuilder(playerService: player).build()
        miniPlayerViewController.output.playNextTrackHandler = miniPlayerViewControllerPlayNextTrackHandler
        miniPlayerViewController.output.showMainPlayerHandler = miniPlayerViewControllerShowMainPlayerHandler
        return miniPlayerViewController
    }
    
    private func miniPlayerViewControllerPlayNextTrackHandler() {
        playNextTrack()
    }
    
    private func miniPlayerViewControllerShowMainPlayerHandler() {
        let mainPlayerTransition = MainPlayerTransition()
        mainPlayerTransition.tabBarView = rootViewController.tabBar
        mainPlayerViewController.transitioningDelegate = mainPlayerTransition
        miniPlayerViewController.present(mainPlayerViewController, animated: true)
    }

    // MARK: - Helper methods
    
    private func playTrack(from trackModel: TrackContentModel) {
        guard let trackUrlString = trackModel.previewUrl, let trackUrl = URL(string: trackUrlString) else { return }
        mainPlayerViewController.input.setTrack(from: trackModel)
        miniPlayerViewController.input.setTrack(from: trackModel)
        player.setTrack(from: trackUrl)
    }
    
    private func playNextTrack() {
        guard let playSource = playSource else { return }
        switch playSource {
        case .search:
            searchViewController.input.playNextTrack()
        case .library:
            libraryViewController.input.playNextTrack()
        }
    }
    
    private func playPreviousTrack() {
        guard let playSource = playSource else { return }
        switch playSource {
        case .search:
            searchViewController.input.playPreviousTrack()
        case .library:
            libraryViewController.input.playPreviousTrack()
        }
    }
}
