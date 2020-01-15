//
//  SearchPresenter.swift
//  MusicApp
//
//  Created by Vadim on 15/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

protocol SearchPresenterLogic: class {
    func presentTracks(_ tracks: [TrackContentModel])
    func presentError(_ message: String)
}

class SearchPresenter: SearchPresenterLogic {

    // MARK: - Properties
    
    weak var viewController: SearchViewDisplayLogic?

    // MARK: - Init
    
    init(viewController: SearchViewDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - SearchPresenterLogic
    
    func presentTracks(_ tracks: [TrackContentModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayTracks(tracks)
        }
    }
    
    func presentError(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayError(message)
        }
    }
}
