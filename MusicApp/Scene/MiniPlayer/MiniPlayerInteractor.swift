//
//  MiniPlayerInteractor.swift
//  MusicApp
//
//  Created by Vadim on 19/02/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

protocol MiniPlayerInput: class {
}

protocol MiniPlayerOutput: class {
}

protocol MiniPlayerInteractorLogic: class {
}

class MiniPlayerInteractor: MiniPlayerInteractorLogic, MiniPlayerInput, MiniPlayerOutput {
    
    // MARK: - Properties
    
    var presenter: MiniPlayerPresenterLogic!
    var operationQueue: DispatchQueue!
    var player: PlayerService!
    
    // MARK: - Init
    
    init(presenter: MiniPlayerPresenterLogic) {
        self.presenter = presenter
        self.operationQueue = DispatchQueue(label: "MiniPlayerOperationQueue", qos: .userInitiated)
        self.player = AVPlayerService(completionQueue: operationQueue)
        player.delegate = self
    }
    
    // MARK: - MiniPlayerInteractorLogic
    
    // MARK: - MainPlayerInput

    // MARK: - MainPlayerOutput

}

// MARK: - PlayerServiceDelegate

extension MiniPlayerInteractor: PlayerServiceDelegate {

    func playDidStart() {
    }
    
    func currentPlayTimeDidChange(currentTime: Float64, totalDuration: Float64) {
    }
    
}
