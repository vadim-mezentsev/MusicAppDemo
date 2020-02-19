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
    func togglePlayerStatus()
}

protocol MiniPlayerOutput: class {
    var playNextTrackHandler: (() -> Void)? { get set }
    var playerStatusToggleHandler: (() -> Void)? { get set }
    var showMainPlayerHandler: (() -> Void)? { get set }
}

protocol MiniPlayerInteractorLogic: class {
    func playerStatusToggle()
    func playNextTrack()
    func showMainPlayer()
}

class MiniPlayerInteractor: MiniPlayerInteractorLogic, MiniPlayerInput, MiniPlayerOutput {
    
    // MARK: - Properties
    
    var presenter: MiniPlayerPresenterLogic!
    
    // MARK: - Init
    
    init(presenter: MiniPlayerPresenterLogic) {
        self.presenter = presenter
    }
    
    // MARK: - MiniPlayerInteractorLogic
    
    func playerStatusToggle() {
        playerStatusToggleHandler?()
    }
    
    func playNextTrack() {
        playNextTrackHandler?()
    }
    
    func showMainPlayer() {
        showMainPlayerHandler?()
    }
    
    // MARK: - MainPlayerInput
    
    func setTrack(from model: TrackContentModel) {
        presenter.presentTrack(from: model)
    }
    
    func togglePlayerStatus() {
        presenter.togglePlayerStatus()
    }

    // MARK: - MainPlayerOutput

    var playNextTrackHandler: (() -> Void)?
    var playerStatusToggleHandler: (() -> Void)?
    var showMainPlayerHandler: (() -> Void)?
}
