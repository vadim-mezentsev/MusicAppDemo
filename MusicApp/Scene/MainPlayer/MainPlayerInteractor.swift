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
    func setPlayStatus()
    func setPauseStatus()
    func setCurrentPlayTime(currentTime: Float64, totalDuration: Float64)
}

protocol MainPlayerOutput: class {
    var playNextTrackHandler: (() -> Void)? { get set }
    var playPreviousTrackHandler: (() -> Void)? { get set }
    var playerStatusToggleHandler: (() -> Void)? { get set }
    var playerSeekHandler: ((Float) -> Void)? { get set }
    var playerSetVolumeHandler: ((Float) -> Void)? { get set }
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
    
    // MARK: - Init
    
    init(presenter: MainPlayerPresenterLogic) {
        self.presenter = presenter
    }
    
    // MARK: - MainPlayerInteractorLogic
    
    func seek(to value: Float) {
        playerSeekHandler?(value)
    }
    
    func setVolume(to value: Float) {
        playerSetVolumeHandler?(value)
    }
    
    func playerStatusToggle() {
        playerStatusToggleHandler?()
    }
    
    func playNextTrack() {
        playNextTrackHandler?()
    }
    
    func playPreviousTrack() {
        playPreviousTrackHandler?()
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
    var playerStatusToggleHandler: (() -> Void)?
    var playerSeekHandler: ((Float) -> Void)?
    var playerSetVolumeHandler: ((Float) -> Void)?
}
