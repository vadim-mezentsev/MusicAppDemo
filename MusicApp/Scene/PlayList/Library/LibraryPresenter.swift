//
//  LibraryPresenter.swift
//  MusicApp
//
//  Created by Vadim on 26/02/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

protocol LibraryPresenterLogic: class {
    func presentTracks(_ tracks: [(model: TrackContentModel, isAddedToLibrary: Bool)])
    func addTrack(_ track: TrackContentModel)
    func removeTrack(at index: Int)
    func presentError(_ message: String)
    func selectNextTrack(currentIndex: Int, maxIndex: Int)
    func selectPreviousTrack(currentIndex: Int, maxIndex: Int)
    func deselectTrack(at index: Int)
}

class LibraryPresenter: LibraryPresenterLogic {

    // MARK: - Properties
    
    weak var viewController: LibraryViewDisplayLogic?

    // MARK: - Init
    
    init(viewController: LibraryViewDisplayLogic? = nil) {
        self.viewController = viewController
    }

    // MARK: - SearchPresenterLogic
    
    func presentTracks(_ tracks: [(model: TrackContentModel, isAddedToLibrary: Bool)]) {
        guard !tracks.isEmpty else { return }
        
        let trackCellModels = tracks.map { (model, isAddedToLibrary) -> TrackCellModel in
            return createTrackCellModel(from: model, isAddedToLibrary: isAddedToLibrary)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayTracks(trackCellModels)
        }
    }
    
    func addTrack(_ track: TrackContentModel) {
        let newTrackCellModel = createTrackCellModel(from: track, isAddedToLibrary: true)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayNewTrack(newTrackCellModel)
        }
    }
    
    func removeTrack(at index: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.removeTrack(at: index)
        }
    }
    
    func presentError(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayError(message)
        }
    }
    
    func selectNextTrack(currentIndex: Int, maxIndex: Int) {
        let nextCellRow = currentIndex + 1 <= maxIndex ? currentIndex + 1 : 0
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.selectTrack(at: nextCellRow)
        }
    }
    
    func selectPreviousTrack(currentIndex: Int, maxIndex: Int) {
        let previousCellRow = currentIndex - 1 >= 0 ? currentIndex - 1 : maxIndex
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.selectTrack(at: previousCellRow)
        }
    }
    
    func deselectTrack(at index: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.deselectTrack(at: index)
        }
    }
    
    // MARK: - Helper methods
    
    private func createTrackCellModel(from model: TrackContentModel, isAddedToLibrary: Bool) -> TrackCellModel {
        let imageUrl = model.artworkUrl100 != nil ? URL(string: model.artworkUrl100!) : nil
        return TrackCellModel(imageUrl: imageUrl,
                              trackTitle: model.trackName,
                              artist: model.artistName,
                              collection: model.collectionName ?? "Unknown".localized(),
                              isAddedToLibrary: isAddedToLibrary)
    }
    
}
