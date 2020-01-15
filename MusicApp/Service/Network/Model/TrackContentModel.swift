//
//  TrackContentModel.swift
//  MusicApp
//
//  Created by Vadim on 15/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

struct TrackContentModel: Decodable {
    let trackName: String
    let artistName: String
    let collectionName: String
    let previewUrl: String?
    let artworkUrl100: String?
}
