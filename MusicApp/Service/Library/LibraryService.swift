//
//  LibraryService.swift
//  MusicApp
//
//  Created by Vadim on 25/02/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

protocol LibraryService: class {
    func add(track: TrackContentModel)
    func remove(track: TrackContentModel)
    func fetchTracks(completion: @escaping (Result<[TrackContentModel], Error>) -> Void)
    func isTrackInLibrary(track: TrackContentModel) -> Bool
    func addObserver(_ observer: LibraryServiceObserver)
    func removeObserver(_ observer: LibraryServiceObserver)
}

protocol LibraryServiceObserver: class {
    func trackDidAddToLibrary(_ track: TrackContentModel)
    func trackDidRemoveFromLibrary(_ track: TrackContentModel)
}
