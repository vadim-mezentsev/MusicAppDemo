//
//  PlayerService.swift
//  MusicApp
//
//  Created by Vadim on 31/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

protocol PlayerService: class {
    var isPlaying: Bool { get }
    func setTrack(from url: URL)
    func play()
    func pause()
    func seek(to percentage: Float)
    func setVolume(to value: Float)
    func addObserver(_ observer: PlayerServiceObserver)
    func removeObserver(_ observer: PlayerServiceObserver)
}

protocol PlayerServiceObserver: class {
    func playDidStart()
    func playDidPause()
    func playDidEnd()
    func currentPlayTimeDidChange(_ currentTime: Float64, _ totalDuration: Float64)
}

extension PlayerServiceObserver {
    func playDidStart() {}
    func playDidPause() {}
    func playDidEnd() {}
    func currentPlayTimeDidChange(_ currentTime: Float64, _ totalDuration: Float64) {}

}
