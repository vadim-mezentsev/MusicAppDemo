//
//  MainPlayerBuilder.swift
//  MusicApp
//
//  Created by Vadim on 30/03/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

class MainPlayerBuilder {
    
    private let playerService: PlayerService
    
    init(playerService: PlayerService) {
        self.playerService = playerService
    }
    
    func build() -> MainPlayerViewController {
        let presenter = MainPlayerPresenter()
        let interactor = MainPlayerInteractor(presenter: presenter, playerService: playerService)
        let viewController = MainPlayerViewController(
            interactor: interactor,
            input: interactor,
            output: interactor)
        presenter.viewController = viewController
        return viewController
    }
    
}
