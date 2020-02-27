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
    func prepareForRemove()
}

class MainPlayerInteractor: MainPlayerInteractorLogic, MainPlayerInput, MainPlayerOutput {
    
    // MARK: - Properties
    
    var presenter: MainPlayerPresenterLogic!
    weak var player: PlayerService?
    
    // MARK: - Init
    
    init(presenter: MainPlayerPresenterLogic, playerService: PlayerService) {
        self.presenter = presenter
        self.player = playerService
        self.player?.addObserver(self)
    }
    
    // MARK: - MainPlayerInteractorLogic
    
    func seek(to value: Float) {
        player?.seek(to: value)
    }
    
    func setVolume(to value: Float) {
        player?.setVolume(to: value)
    }
    
    func playerStatusToggle() {
        guard let player = player else { return }
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }
    
    func playNextTrack() {
        playNextTrackHandler?()
    }
    
    func playPreviousTrack() {
        playPreviousTrackHandler?()
    }
    
    func prepareForRemove() {
        player?.removeObserver(self)
    }
    
    // MARK: - MainPlayerInput
    
    func setTrack(from model: TrackContentModel) {
        presenter.presentTrack(from: model)
    }
    
    func setPlayStatus() {
        presenter.presentPlayState()
    }
    
    func setPauseStatus() {
        presenter.presentPauseState()
    }
    
    func setCurrentPlayTime(currentTime: Float64, totalDuration: Float64) {
        presenter.presentCurrentPlayTime(currentTime, totalDuration)
    }
    
    // MARK: - MainPlayerOutput
    
    var playNextTrackHandler: (() -> Void)?
    var playPreviousTrackHandler: (() -> Void)?
}

extension MainPlayerInteractor: PlayerServiceObserver {
    
    func playDidStart() {
        presenter.presentPlayState()
    }
    
    func playDidPause() {
        presenter.presentPauseState()
    }
    
    func playDidEnd() {
        playNextTrackHandler?()
    }
    
    func currentPlayTimeDidChange(_ currentTime: Float64, _ totalDuration: Float64) {
        presenter.presentCurrentPlayTime(currentTime, totalDuration)
    }

}
