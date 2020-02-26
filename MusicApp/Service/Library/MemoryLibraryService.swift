//
//  MemoryLibraryService.swift
//  MusicApp
//
//  Created by Vadim on 26/02/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

class MemoryLibraryService: LibraryService {
    
    private var observers = [LibraryServiceObserver]()
    private var tracks = [TrackContentModel]()
    
    func add(track: TrackContentModel) {
        guard !tracks.contains(track) else { return }
        tracks.append(track)
        notify(event: .trackDidAdd(track))
    }
    
    func remove(track: TrackContentModel) {
        tracks = tracks.filter { $0 == track }
        notify(event: .trackDidRemove(track))
    }
    
    func fetchTracks(completion: @escaping ([TrackContentModel]) -> Void) {
        completion(tracks)
    }
    
    func isTrackInLibrary(track: TrackContentModel) -> Bool {
        tracks.contains(track)
    }
    
    func addObserver(_ observer: LibraryServiceObserver) {
        observers.append(observer)
    }

    func removeObserver(_ observer: LibraryServiceObserver) {
        observers = observers.filter { $0 !== observer}
    }
    
    func notify(event: LibraryServiceEvent) {
        observers.forEach { $0.eventHandler(event: event) }
    }
    
}
