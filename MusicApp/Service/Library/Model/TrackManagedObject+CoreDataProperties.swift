//
//  Track+CoreDataProperties.swift
//  MusicApp
//
//  Created by Vadim on 28/02/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//
//

import Foundation
import CoreData

extension TrackManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackManagedObject> {
        return NSFetchRequest<TrackManagedObject>(entityName: "Track")
    }

    @NSManaged public var trackName: String
    @NSManaged public var artistName: String
    @NSManaged public var collectionName: String?
    @NSManaged public var previewUrl: String?
    @NSManaged public var artworkUrl100: String?

}
