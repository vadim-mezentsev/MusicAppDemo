//
//  MainPlayerPresenter.swift
//  MusicApp
//
//  Created by Vadim on 16/02/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

protocol MainPlayerPresenterLogic: class {
    func presentPlayState()
    func presentPauseState()
    func presentCurrentPlayTime(_ currentTime: Float64, _ duration: Float64)
    func presentTrack(from model: TrackContentModel)
}

class MainPlayerPresenter: MainPlayerPresenterLogic {
    
    // MARK: - Properties
    
    weak var viewController: MainPlayerDisplayLogic?

    // MARK: - Init
    
    init(viewController: MainPlayerDisplayLogic? = nil) {
        self.viewController = viewController
    }

    // MARK: - MainPlayerPresenterLogic
    
    func presentPlayState() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayPlayState()
        }
    }
    
    func presentPauseState() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayPauseState()
        }
    }
    
    func presentCurrentPlayTime(_ currentTime: Float64, _ duration: Float64) { 
        let currentTimeString = floatToString(currentTime)
        let timeLeftString = "-" + floatToString(duration - currentTime)
        let currentTimePercantage = Float(currentTime / duration)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayCurrentPlayTime(currentTimeString, timeLeftString, currentTimePercantage)
        }
    }
    
    func presentTrack(from model: TrackContentModel) {
        let title = model.trackName
        let author = model.artistName
        let imageUrl = makeImageUrl(from: model.artworkUrl100)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayTrack(title, author, imageUrl)
        }
    }
    
    // MARK: - Helper methods
    
    private func floatToString(_ value: Float64) -> String {
        guard !value.isNaN else { return "-:-" }
        let totalSecond = Int(value)
        let seconds = totalSecond % 60
        let minutes = totalSecond / 60
        let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
        return timeFormatString
    }
    
    private func makeImageUrl(from artworkUrl100: String?) -> URL? {
        guard let artworkUrl600 = artworkUrl100?.replacingOccurrences(of: "100x100", with: "600x600") else { return nil }
        return URL(string: artworkUrl600)
    }
    
}
