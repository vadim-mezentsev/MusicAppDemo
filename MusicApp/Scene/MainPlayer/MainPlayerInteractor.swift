//
//  MainPlayerInteractor.swift
//  MusicApp
//
//  Created by Vadim on 16/02/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

protocol MainPlayerInteractorLogic: class {
    func seek(to value: Float)
    func setVolume(to value: Float)
    func playerStatusToggle()
    func playTrack(urlString: String)
}

class MainPlayerInteractor: MainPlayerInteractorLogic {
    
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
    
    func playTrack(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        player.setTrack(from: url)
        player.play()
    }
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
