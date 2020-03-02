//
//  CoreDataLibraryService.swift
//  MusicApp
//
//  Created by Vadim on 28/02/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation
import CoreData

class CoreDataLibraryService: LibraryService {

    // MARK: - Properties
    
    private var notification = NotificationManager<LibraryServiceObserver>()
    private var coreData = CoreDataStack(persistentContainerName: "CoreDataLibraryService")
    
    // MARK: - LibraryService
    
    func add(track: TrackContentModel) {
        guard !isTrackInLibrary(track: track) else { return }
        
        let newLibraryTrack = TrackManagedObject(context: coreData.context)
        newLibraryTrack.trackName = track.trackName
        newLibraryTrack.artistName = track.artistName
        newLibraryTrack.collectionName = track.collectionName
        newLibraryTrack.previewUrl = track.previewUrl
        newLibraryTrack.artworkUrl100 = track.artworkUrl100
        
        do {
            try coreData.context.save()
            notification.notify { $0.trackDidAddToLibrary(track) }
        } catch let error {
            print("Add track failed: \(error.localizedDescription)")
        }
    }
    
    func remove(track: TrackContentModel) {
        let request = fetchRequest(for: track)
        guard let tracksForRemove = try? coreData.context.fetch(request) else { return }
        
        tracksForRemove.forEach { coreData.context.delete($0) }
        
        do {
            try coreData.context.save()
            notification.notify { $0.trackDidRemoveFromLibrary(track) }
        } catch let error {
            print("Remove track failed: \(error.localizedDescription)")
        }
    }
    
    func fetchTracks(completion: @escaping (Result<[TrackContentModel], Error>) -> Void) {
        let request: NSFetchRequest<TrackManagedObject> = TrackManagedObject.fetchRequest()
        do {
            let tracks = try coreData.context.fetch(request)
            let tracksContentModels = tracks.map { createTrackContentModel(from: $0) }
            completion(.success(tracksContentModels))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func isTrackInLibrary(track: TrackContentModel) -> Bool {
        let request = fetchRequest(for: track)
        if let fetchResultsCount = try? coreData.context.count(for: request), fetchResultsCount != 0 {
            return true
        }
        return false
    }
    
    func addObserver(_ observer: LibraryServiceObserver) {
        notification.addObserver(observer)    }

    func removeObserver(_ observer: LibraryServiceObserver) {
        notification.removeObserver(observer)
    }
    
    // MARK: - Helper methods
    
    private func createTrackContentModel(from track: TrackManagedObject) -> TrackContentModel {
        let trackContentModel = TrackContentModel(trackName: track.trackName,
                                                  artistName: track.artistName,
                                                  collectionName: track.collectionName,
                                                  previewUrl: track.previewUrl,
                                                  artworkUrl100: track.artworkUrl100)
        return trackContentModel
        
    }
    
    private func fetchRequest(for track: TrackContentModel) -> NSFetchRequest<TrackManagedObject> {
        let request = TrackManagedObject.fetchRequest() as NSFetchRequest<TrackManagedObject>
        var predicates = [NSPredicate]()
        
        predicates.append(NSPredicate(format: "trackName CONTAINS %@", track.trackName))
        predicates.append(NSPredicate(format: "artistName CONTAINS %@", track.artistName))
        if let collectionName = track.collectionName {
            predicates.append(NSPredicate(format: "collectionName CONTAINS %@", collectionName))
        }
        if let previewUrl = track.previewUrl {
            predicates.append(NSPredicate(format: "previewUrl CONTAINS %@", previewUrl))
        }
        if let artworkUrl100 = track.artworkUrl100 {
            predicates.append(NSPredicate(format: "artworkUrl100 CONTAINS %@", artworkUrl100))
        }
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        return request
    }
}
