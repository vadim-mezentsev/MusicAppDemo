//
//  TrackCellModel.swift
//  MusicApp
//
//  Created by Vadim on 31/03/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//
import Foundation

struct TrackCellModel {
    let imageUrl: URL?
    let trackTitle: String
    let artist: String
    let collection: String
    let isAddedToLibrary: Bool
}
