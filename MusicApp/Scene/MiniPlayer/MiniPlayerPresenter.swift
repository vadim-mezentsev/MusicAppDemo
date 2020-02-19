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
    func togglePlayerStatus()
}

class MiniPlayerPresenter: MiniPlayerPresenterLogic {
    
    // MARK: - Properties
    
    weak var viewController: MiniPlayerDisplayLogic?

    // MARK: - Init
    
    init(viewController: MiniPlayerDisplayLogic) {
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
    
    func togglePlayerStatus() {
        viewController?.togglePlayerStatus()
    }
    
    // MARK: - Helper methods

    private func makeImageUrl(from artworkUrl100: String?) -> URL? {
        guard let artworkUrl100 = artworkUrl100 else { return nil }
        return URL(string: artworkUrl100)
    }
    
}
