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
}

class MainPlayerPresenter: MainPlayerPresenterLogic {
    
    // MARK: - Properties
    
    weak var viewController: MainPlayerDisplayLogic?

    // MARK: - Init
    
    init(viewController: MainPlayerDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - MainPlayerPresenterLogic
    
    func presentPlayState() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayPlayStartedState()
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
    
    // MARK: - Helper methods
    
    private func floatToString(_ value: Float64) -> String {
        guard !value.isNaN else { return "-:-" }
        let totalSecond = Int(value)
        let seconds = totalSecond % 60
        let minutes = totalSecond / 60
        let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
        return timeFormatString
    }
    
}
