//
//  SearchInteractor.swift
//  MusicApp
//
//  Created by Vadim on 15/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

protocol SearchInput: class {
    func playNextTrack()
    func playPreviousTrack()
}

protocol SearchOutput: class {
    var playTrackHandler: ((TrackContentModel) -> Void)? { get set }
}

protocol SearchInteractorLogic: class {
    func fetchTracks(for term: String)
    func playTrack(index: Int)
}

class SearchInteractor: SearchInteractorLogic, SearchInput, SearchOutput {

    // MARK: - Properties
    
    var presenter: SearchPresenterLogic!
    var operationQueue: DispatchQueue!
    var networkService: NetworkService!
    private(set) var tracks: [TrackContentModel]?
    private(set) var currentTrackIndex: Int?

    // MARK: - Init
    
    init(presenter: SearchPresenterLogic) {
        self.presenter = presenter
        self.operationQueue = DispatchQueue(label: "SearchOperationQueue", qos: .userInitiated)
        self.networkService = NetworkService(completionQueue: operationQueue)
    }
  
    // MARK: - SearchInteractorLogic
    
    func fetchTracks(for term: String) {
        networkService.fetchTracks(term: term) { [weak self] (result) in
            switch result {
            case .success(let responce):
                if responce.results.isEmpty {
                    self?.presenter.presentError("Your search returned no results".localized())
                } else {
                    self?.tracks = responce.results
                    self?.currentTrackIndex = nil
                    self?.presenter.presentTracks(responce.results)
                }
            case .failure(let error):
                self?.presenter.presentError(error.message)
            }
        }
    }
    
    func playTrack(index: Int) {
        guard let trackModel = tracks?[index] else { return }
        currentTrackIndex = index
        playTrackHandler?(trackModel)
    }
    
    // MARK: - SearchInput
    
    func playNextTrack() {
        guard let currentIndex = currentTrackIndex, let tracksCount = tracks?.count else { return }
        presenter.selectNextTrack(currentIndex: currentIndex, maxIndex: tracksCount - 1)
    }
    
    func playPreviousTrack() {
        guard let currentIndex = currentTrackIndex, let tracksCount = tracks?.count else { return }
        presenter.selectPreviousTrack(currentIndex: currentIndex, maxIndex: tracksCount - 1)
    }
    
    // MARK: - SearchOutput
    
    var playTrackHandler: ((TrackContentModel) -> Void)?
    
}
