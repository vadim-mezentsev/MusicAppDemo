//
//  MiniPlayerInteractor.swift
//  MusicApp
//
//  Created by Vadim on 19/02/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

protocol MiniPlayerInput: class {
    func setTrack(from model: TrackContentModel)
}

protocol MiniPlayerOutput: class {
    var playNextTrackHandler: (() -> Void)? { get set }
    var showMainPlayerHandler: (() -> Void)? { get set }
}

protocol MiniPlayerInteractorLogic: class {
    func playerStatusToggle()
    func playNextTrack()
    func showMainPlayer()
    func prepareForRemove()
}

class MiniPlayerInteractor: MiniPlayerInteractorLogic, MiniPlayerInput, MiniPlayerOutput {
    
    // MARK: - Properties
    
    private var presenter: MiniPlayerPresenterLogic!
    private weak var player: PlayerService?
    
    // MARK: - Init
    
    init(presenter: MiniPlayerPresenterLogic, playerService: PlayerService) {
        self.presenter = presenter
        self.player = playerService
        self.player?.addObserver(self)
    }
    
    // MARK: - MiniPlayerInteractorLogic
    
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
    
    func showMainPlayer() {
        showMainPlayerHandler?()
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

    // MARK: - MainPlayerOutput

    var playNextTrackHandler: (() -> Void)?
    var showMainPlayerHandler: (() -> Void)?
}

extension MiniPlayerInteractor: PlayerServiceObserver {
    
    func playDidStart() {
        presenter.presentPlayState()
    }
    
    func playDidPause() {
        presenter.presentPauseState()
    }

}
