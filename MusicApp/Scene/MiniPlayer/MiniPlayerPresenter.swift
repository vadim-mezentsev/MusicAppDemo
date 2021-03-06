//
//  MiniPlayerPresenter.swift
//  MusicApp
//
//  Created by Vadim on 19/02/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

protocol MiniPlayerPresenterLogic: class {
    func presentTrack(from model: TrackContentModel)
    func presentPlayState()
    func presentPauseState()
}

class MiniPlayerPresenter: MiniPlayerPresenterLogic {
    
    // MARK: - Properties
    
    weak var viewController: MiniPlayerDisplayLogic?

    // MARK: - Init
    
    init(viewController: MiniPlayerDisplayLogic? = nil) {
        self.viewController = viewController
    }

    // MARK: - MiniPlayerPresenterLogic
    
    func presentTrack(from model: TrackContentModel) {
        let title = model.trackName
        let imageUrl = makeImageUrl(from: model.artworkUrl100)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayTrack(title, imageUrl)
        }
    }

    func presentPlayState() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayPlayState()
        }
    }
    
    func presentPauseState() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayPauseState()
        }
    }
    
    // MARK: - Helper methods

    private func makeImageUrl(from artworkUrl100: String?) -> URL? {
        guard let artworkUrl100 = artworkUrl100 else { return nil }
        return URL(string: artworkUrl100)
    }
    
}
