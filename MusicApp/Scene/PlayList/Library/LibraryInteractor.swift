//
//  LibraryInteractor.swift
//  MusicApp
//
//  Created by Vadim on 26/02/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

protocol LibraryInput: class {
    func playNextTrack()
    func playPreviousTrack()
    func deselectTrack()
}

protocol LibraryOutput: class {
    var playTrackHandler: ((TrackContentModel) -> Void)? { get set }
}

protocol LibraryInteractorLogic: class {
    func fetchTracks()
    func playTrack(index: Int)
    func removeTrack(at index: Int)
    func prepareForRemove()
}

class LibraryInteractor: LibraryInteractorLogic, LibraryInput, LibraryOutput {

    // MARK: - Properties
    
    var presenter: LibraryPresenterLogic!
    var operationQueue: DispatchQueue!
    var libraryService: LibraryService!
    private(set) var tracks: [TrackContentModel]?
    private(set) var currentTrackIndex: Int?

    // MARK: - Init
    
    init(presenter: LibraryPresenterLogic, libraryService: LibraryService) {
        self.presenter = presenter
        self.libraryService = libraryService
        self.libraryService.addObserver(self)
        self.operationQueue = DispatchQueue(label: "LibraryOperationQueue", qos: .userInitiated)
    }
  
    // MARK: - SearchInteractorLogic
    
    func fetchTracks() {
        libraryService.fetchTracks { [weak self] (result) in
            switch result {
            case .success(let models):
                self?.tracks = models
                self?.currentTrackIndex = nil
                let tracks: [(TrackContentModel, Bool)] = models.map { ($0, true) }
                self?.presenter.presentTracks(tracks)
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
    
    func removeTrack(at index: Int) {
        guard let trckForRemove = tracks?[index] else { return }
        libraryService.remove(track: trckForRemove)
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

extension LibraryInteractor: LibraryServiceObserver {
    
    func trackDidAddToLibrary(_ track: TrackContentModel) {
        guard let tracks = tracks, !tracks.contains(track) else { return }
        presenter.addTrack(track)
        self.tracks?.append(track)
    }
    
    func trackDidRemoveFromLibrary(_ track: TrackContentModel) {
        if let trackIndex = tracks?.firstIndex(of: track) {
            presenter.removeTrack(at: trackIndex)
            tracks?.remove(at: trackIndex)
            if let currentTrackIndex = currentTrackIndex, currentTrackIndex == trackIndex {
                self.currentTrackIndex = nil
            }
        }
    }
    
}
