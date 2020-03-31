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
    func deselectTrack()
}

protocol SearchOutput: class {
    var playTrackHandler: ((TrackContentModel) -> Void)? { get set }
}

protocol SearchInteractorLogic: class {
    func fetchTracks(for term: String)
    func playTrack(index: Int)
    func clearSearchResults()
    func addTrackToLibrary(index: Int)
    func prepareForRemove()
}

class SearchInteractor: SearchInteractorLogic, SearchInput, SearchOutput {

    // MARK: - Properties
    
    private let presenter: SearchPresenterLogic
    private let operationQueue: DispatchQueue
    private let networkService: NetworkService
    private let libraryService: LibraryService
    private var tracks: [TrackContentModel]?
    private var currentTrackIndex: Int?

    // MARK: - Init
    
    init(presenter: SearchPresenterLogic, libraryService: LibraryService) {
        self.presenter = presenter
        self.operationQueue = DispatchQueue(label: "SearchOperationQueue", qos: .userInitiated)
        self.networkService = NetworkService(completionQueue: operationQueue)
        self.libraryService = libraryService
        self.libraryService.addObserver(self)
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
                    
                    let tracks: [(TrackContentModel, Bool)] = responce.results.map { model in
                        let isAddedToLibrary = self?.libraryService.isTrackInLibrary(track: model) ?? false
                        return (model, isAddedToLibrary)
                    }
                    
                    self?.presenter.presentTracks(tracks)
                }
            case .failure(let error):
                self?.presenter.presentError(error.localizedDescription)
            }
        }
    }
    
    func playTrack(index: Int) {
        guard let trackModel = tracks?[index] else { return }
        currentTrackIndex = index
        playTrackHandler?(trackModel)
    }
    
    func clearSearchResults() {
        tracks = nil
        currentTrackIndex = nil
    }
    
    func addTrackToLibrary(index: Int) {
        guard let trackToLibrary = tracks?[index] else { return }
        libraryService.add(track: trackToLibrary)
    }
    
    func prepareForRemove() {
        libraryService.removeObserver(self)
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
    
    func deselectTrack() {
        guard let currentTrackIndex = currentTrackIndex else { return }
        presenter.deselectTrack(at: currentTrackIndex)
        self.currentTrackIndex = nil
    }
    
    // MARK: - SearchOutput
    
    var playTrackHandler: ((TrackContentModel) -> Void)?
    
}

extension SearchInteractor: LibraryServiceObserver {
    
    func trackDidAddToLibrary(_ track: TrackContentModel) {
        if let trackIndex = tracks?.firstIndex(of: track) {
            presenter.hideAddButton(forTrack: track, at: trackIndex)
        }
    }
    
    func trackDidRemoveFromLibrary(_ track: TrackContentModel) {
        if let trackIndex = tracks?.firstIndex(of: track) {
            presenter.showAddButton(forTrack: track, at: trackIndex)
        }
    }

}
