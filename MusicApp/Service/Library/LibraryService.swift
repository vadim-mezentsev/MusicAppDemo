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
    func fetchTracks(completion: @escaping ([TrackContentModel]) -> Void)
    func isTrackInLibrary(track: TrackContentModel) -> Bool
    func addObserver(_ observer: LibraryServiceObserver)
    func removeObserver(_ observer: LibraryServiceObserver)
}

enum LibraryServiceEvent {
    case trackDidAdd(TrackContentModel)
    case trackDidRemove(TrackContentModel)
}

protocol LibraryServiceObserver: class {
     func eventHandler(event: LibraryServiceEvent)
}
