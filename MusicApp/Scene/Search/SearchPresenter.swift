//
//  SearchPresenter.swift
//  MusicApp
//
//  Created by Vadim on 15/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

protocol SearchPresenterLogic: class {
    func presentTracks(_ tracks: [(model: TrackContentModel, isAddedToLibrary: Bool)])
    func showAddButton(forTrack track: TrackContentModel, at index: Int)
    func hideAddButton(forTrack track: TrackContentModel, at index: Int)
    func presentError(_ message: String)
    func selectNextTrack(currentIndex: Int, maxIndex: Int)
    func selectPreviousTrack(currentIndex: Int, maxIndex: Int)
}

class SearchPresenter: SearchPresenterLogic {

    // MARK: - Properties
    
    weak var viewController: SearchViewDisplayLogic?

    // MARK: - Init
    
    init(viewController: SearchViewDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - SearchPresenterLogic
    
    func presentTracks(_ tracks: [(model: TrackContentModel, isAddedToLibrary: Bool)]) {
        
        let trackCellModels = tracks.map { (model, isAddedToLibrary) -> TrackCellModel in
            return createTrackCellModel(from: model, isAddedToLibrary: isAddedToLibrary)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayTracks(trackCellModels)
        }
    }
    
    func showAddButton(forTrack track: TrackContentModel, at index: Int) {
        let newTrackCellModel = createTrackCellModel(from: track, isAddedToLibrary: false)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayTrack(newTrackCellModel, at: index)
        }
    }
    
    func hideAddButton(forTrack track: TrackContentModel, at index: Int) {
        let newTrackCellModel = createTrackCellModel(from: track, isAddedToLibrary: true)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayTrack(newTrackCellModel, at: index)
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
            self?.viewController?.selectCell(at: nextCellRow)
        }
    }
    
    func selectPreviousTrack(currentIndex: Int, maxIndex: Int) {
        let previousCellRow = currentIndex - 1 >= 0 ? currentIndex - 1 : maxIndex
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.selectCell(at: previousCellRow)
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
