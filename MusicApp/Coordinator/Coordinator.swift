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
    
    var player: PlayerService!
    
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
        
        self.player = AVPlayerService()
        player.delegate = self
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
        let mainPlayerViewController = MainPlayerViewController()
        mainPlayerViewController.output.playNextTrackHandler = mainPlayerViewControllerPlayNextTrackHandler
        mainPlayerViewController.output.playPreviousTrackHandler = mainPlayerViewControllerPlayPreviousTrackHandler
        mainPlayerViewController.output.playerStatusToggleHandler = mainPlayerViewControllerPlayerStatusToggleHandler
        mainPlayerViewController.output.playerSeekHandler = mainPlayerViewControllerPlayerSeekHandler
        mainPlayerViewController.output.playerSetVolumeHandler = mainPlayerViewControllerPlayerSetVolumeHandler
        return mainPlayerViewController
    }
    
    private func mainPlayerViewControllerPlayNextTrackHandler() {
        searchViewController.input.playNextTrack()
    }
    
    private func mainPlayerViewControllerPlayPreviousTrackHandler() {
        searchViewController.input.playPreviousTrack()
    }

    private func mainPlayerViewControllerPlayerStatusToggleHandler() {
        togglePlayerStatus()
    }
    
    func mainPlayerViewControllerPlayerSeekHandler(to value: Float) {
        player.seek(to: value)
    }
    
    func mainPlayerViewControllerPlayerSetVolumeHandler(to value: Float) {
        player.setVolume(to: value)
    }
    
    // MARK: - MiniPlayerViewController setup
    
    private func createMiniPlayerViewController() -> MiniPlayerViewController {
        let miniPlayerViewController = MiniPlayerViewController()
        miniPlayerViewController.output.playerStatusToggleHandler = miniPlayerViewControllerPlayerStatusToggleHandler
        miniPlayerViewController.output.playNextTrackHandler = miniPlayerViewControllerPlayNextTrackHandler
        miniPlayerViewController.output.showMainPlayerHandler = miniPlayerViewControllerShowMainPlayerHandler
        return miniPlayerViewController
    }
    
    private func miniPlayerViewControllerPlayerStatusToggleHandler() {
        togglePlayerStatus()
    }
    
    private func miniPlayerViewControllerPlayNextTrackHandler() {
        searchViewController.input.playNextTrack()
    }
    
    private func miniPlayerViewControllerShowMainPlayerHandler() {
        rootViewController.present(mainPlayerViewController, animated: true)
    }
    
    // MARK: - Helper methods
    
    private func togglePlayerStatus() {
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }
    
}

// MARK: - PlayerServiceDelegate

extension MainCoordinator: PlayerServiceDelegate {

    func playDidStart() {
        mainPlayerViewController.input.setPlayStatus()
        miniPlayerViewController.input.setPlayStatus()
    }
    
    func playDidPause() {
        mainPlayerViewController.input.setPauseStatus()
        miniPlayerViewController.input.setPauseStatus()
    }
    
    func currentPlayTimeDidChange(currentTime: Float64, totalDuration: Float64) {
        mainPlayerViewController.input.setCurrentPlayTime(currentTime: currentTime, totalDuration: totalDuration)
    }
    
    func playDidEnd() {
        searchViewController.input.playNextTrack()
    }
    
}
