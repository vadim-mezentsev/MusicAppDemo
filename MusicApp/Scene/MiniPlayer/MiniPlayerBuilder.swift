//
//  MiniPlayerBuilder.swift
//  MusicApp
//
//  Created by Vadim on 30/03/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

class MiniPlayerBuilder {
    
    private let playerService: PlayerService
    
    init(playerService: PlayerService) {
        self.playerService = playerService
    }
    
    func build() -> MiniPlayerViewController {
        let presenter = MiniPlayerPresenter()
        let interactor = MiniPlayerInteractor(presenter: presenter, playerService: playerService)
        let viewController = MiniPlayerViewController(
            interactor: interactor,
            input: interactor,
            output: interactor)
        presenter.viewController = viewController
        return viewController
    }
    
}
