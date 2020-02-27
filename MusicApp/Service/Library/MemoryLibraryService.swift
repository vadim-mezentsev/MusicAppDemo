//
//  MemoryLibraryService.swift
//  MusicApp
//
//  Created by Vadim on 26/02/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

class MemoryLibraryService: LibraryService {
    
    private(set) var notification = NotificationManager<LibraryServiceObserver>()
    private var tracks = [TrackContentModel]()
    
    func add(track: TrackContentModel) {
        guard !tracks.contains(track) else { return }
        tracks.append(track)
        notification.notify { $0.trackDidAddToLibrary(track) }
    }
    
    func remove(track: TrackContentModel) {
        tracks = tracks.filter { $0 == track }
        notification.notify { $0.trackDidRemoveFromLibrary(track) }
    }
    
    func fetchTracks(completion: @escaping ([TrackContentModel]) -> Void) {
        completion(tracks)
    }
    
    func isTrackInLibrary(track: TrackContentModel) -> Bool {
        tracks.contains(track)
    }
    
    func addObserver(_ observer: LibraryServiceObserver) {
        notification.addObserver(observer)    }

    func removeObserver(_ observer: LibraryServiceObserver) {
        notification.removeObserver(observer)
    }
    
}
