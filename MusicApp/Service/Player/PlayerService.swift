//
//  PlayerService.swift
//  MusicApp
//
//  Created by Vadim on 31/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation
import AVFoundation

protocol PlayerService: class {
    var isPlaying: Bool { get }
    var delegate: PlayerServiceDelegate? { get set }
    func setTrack(from url: URL)
    func play()
    func pause()
    func seek(to percentage: Float)
    func setVolume(to value: Float)
}

protocol PlayerServiceDelegate: class {
    func playDidStart()
    func playDidPause()
    func currentPlayTimeDidChange(currentTime: Float64, totalDuration: Float64)
}

class AVPlayerService: PlayerService {
    
    // MARK: - Properties
    
    weak var delegate: PlayerServiceDelegate?
    var isPlaying: Bool {
        player.timeControlStatus == .playing ? true : false
    }
    
    private let player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    private let completionQueue: DispatchQueue!

    // MARK: - Init
    
    init(completionQueue: DispatchQueue? = nil) {
        self.completionQueue = completionQueue ?? DispatchQueue(label: "AVPlayerServiceQuiue", qos: .userInitiated)
        addStartPlaybackObserver()
        addCurrentPlayTimeObserver()
    }
    
    // MARK: - PlayerService
    
    func setTrack(from url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
    }
    
    func play() {
        player.play()
        delegate?.playDidStart()
    }
    
    func pause() {
        player.pause()
        delegate?.playDidPause()
    }
    
    func seek(to percentage: Float) {
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeUpSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeUpSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    func setVolume(to value: Float) {
        var newVolumeValue = value
        if value < 0.0 { newVolumeValue = 0.0 }
        if value > 1.0 { newVolumeValue = 1.0 }
        player.volume = newVolumeValue
    }
    
    // MARK: - AVPlayer observers
    
    private func addStartPlaybackObserver() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: completionQueue) { [weak self] in
            self?.delegate?.playDidStart()
        }
    }
    
    private func addCurrentPlayTimeObserver() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: completionQueue) { [weak self] _ in
            guard let self = self else { return }
            guard let currentItem = self.player.currentItem else { return }
            let durationTime = CMTimeGetSeconds(currentItem.duration)
            let currentTime = CMTimeGetSeconds(currentItem.currentTime())
            self.delegate?.currentPlayTimeDidChange(currentTime: currentTime, totalDuration: durationTime)
        }
    }
    
}
