//
//  MainPlayerInteractor.swift
//  MusicApp
//
//  Created by Vadim on 16/02/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

protocol MainPlayerInput: class {
    func setTrack(from model: TrackContentModel)
}

protocol MainPlayerOutput: class {
    var playNextTrackHandler: (() -> Void)? { get set }
    var playPreviousTrackHandler: (() -> Void)? { get set }
}

protocol MainPlayerInteractorLogic: class {
    func seek(to value: Float)
    func setVolume(to value: Float)
    func playerStatusToggle()
    func playNextTrack()
    func playPreviousTrack()
}

class MainPlayerInteractor: MainPlayerInteractorLogic, MainPlayerInput, MainPlayerOutput {
    
    // MARK: - Properties
    
    var presenter: MainPlayerPresenterLogic!
    var operationQueue: DispatchQueue!
    var player: PlayerService!
    
    // MARK: - Init
    
    init(presenter: MainPlayerPresenterLogic) {
        self.presenter = presenter
        self.operationQueue = DispatchQueue(label: "MainPlayerOperationQueue", qos: .userInitiated)
        self.player = AVPlayerService(completionQueue: operationQueue)
        player.delegate = self
    }
    
    // MARK: - MainPlayerInteractorLogic
    
    func seek(to value: Float) {
        player.seek(to: value)
    }
    
    func setVolume(to value: Float) {
        player.setVolume(to: value)
    }
    
    func playerStatusToggle() {
        if player.isPlaying {
            player.pause()
            presenter.presentPauseState()
        } else {
            player.play()
            presenter.presentPlayState()
        }
    }
    
    func playNextTrack() {
        playNextTrackHandler?()
    }
    
    func playPreviousTrack() {
        playPreviousTrackHandler?()
    }
    
    // MARK: - MainPlayerInput
    
    func setTrack(from model: TrackContentModel) {
        guard let trackUrlString = model.previewUrl, let trackUrl = URL(string: trackUrlString) else { return }
        presenter.presentTrack(from: model)
        player.setTrack(from: trackUrl)
        player.play()
    }
    
    // MARK: - MainPlayerOutput
    
    var playNextTrackHandler: (() -> Void)?
    var playPreviousTrackHandler: (() -> Void)?
}

// MARK: - PlayerServiceDelegate

extension MainPlayerInteractor: PlayerServiceDelegate {

    func playDidStart() {
        presenter.presentPlayState()
    }
    
    func currentPlayTimeDidChange(currentTime: Float64, totalDuration: Float64) {
        presenter.presentCurrentPlayTime(currentTime, totalDuration)
    }
    
}
