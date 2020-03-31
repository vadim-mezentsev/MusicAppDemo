//
//  MainPlayerViewController.swift
//  MusicApp
//
//  Created by Vadim on 31/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import UIKit

protocol MainPlayerDisplayLogic: class {
    func displayPlayState()
    func displayPauseState()
    func displayCurrentPlayTime(_ currentTimeText: String, _ timeLeftDurationText: String, _ currentTimePercantage: Float)
    func displayTrack(_ title: String, _ author: String, _ imageUrl: URL?)
}

class MainPlayerViewController: UIViewController {
    
    // MARK: - Types
    
    enum State {
        case wait
        case play
        case pause
    }
    
    // MARK: - Properties
    
    let input: MainPlayerInput
    let output: MainPlayerOutput
    private let interactor: MainPlayerInteractorLogic
    private var state: MainPlayerViewController.State! {
        didSet {
            changeState(to: state)
        }
    }
    
    // MARK: - Load view
    
    var mainPlayerView: MainPlayerView {
        return view as! MainPlayerView
    }
    
    // MARK: - Init

    init(interactor: MainPlayerInteractorLogic, input: MainPlayerInput, output: MainPlayerOutput) {
        self.interactor = interactor
        self.input = input
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard not supported")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBAction

    @IBAction private func dragDownButtomTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func trackPositionSliderChanged(_ sender: Any) {
        interactor.seek(to: mainPlayerView.currentTimeSlider.value)
    }
    
    @IBAction private func volumeSliderChanged(_ sender: Any) {
        interactor.setVolume(to: mainPlayerView.volumeSlider.value)
    }
    
    @IBAction private func nextTrackButtonTapped(_ sender: Any) {
        interactor.playNextTrack()
    }
    
    @IBAction private func previousTrackButtonTapped(_ sender: Any) {
        interactor.playPreviousTrack()
    }
    
    @IBAction private func playPouseButtonTapped(_ sender: Any) {
        interactor.playerStatusToggle()
    }
    
    // MARK: - Interface preparation
    
    private func changeState(to state: MainPlayerViewController.State) {
        switch state {
        case .wait:
            mainPlayerView.scaleDownTrackImageView()
            let image = UIImage(systemName: "pause.fill")
            mainPlayerView.playPouseButton.setImage(image, for: .normal)
        case .play:
            let image = UIImage(systemName: "pause.fill")
            mainPlayerView.playPouseButton.setImage(image, for: .normal)
            mainPlayerView.scaleUpTrackImageView()
        case .pause:
            let image = UIImage(systemName: "play.fill")
            mainPlayerView.playPouseButton.setImage(image, for: .normal)
            mainPlayerView.scaleDownTrackImageView()
        }
    }
    
    deinit {
        interactor.prepareForRemove()
    }
}

// MARK: - MainPlayerDisplayLogic

extension MainPlayerViewController: MainPlayerDisplayLogic {
    
    func displayPlayState() {
        state = .play
    }
    
    func displayPauseState() {
        state = .pause
    }
    
    func displayCurrentPlayTime(_ currentTimeText: String, _ timeLeftDurationText: String, _ currentTimePercantage: Float) {
        mainPlayerView.currentTimeLabel.text = currentTimeText
        mainPlayerView.durationLabel.text = timeLeftDurationText
        mainPlayerView.currentTimeSlider.value = currentTimePercantage
    }

    func displayTrack(_ title: String, _ author: String, _ imageUrl: URL?) {
        state = .wait
        mainPlayerView.trackTitleLabel.text = title
        mainPlayerView.authorLabel.text = author
        if let imageUrl = imageUrl {
            mainPlayerView.trackImageView.setImage(from: imageUrl)
        }
    }
    
}
