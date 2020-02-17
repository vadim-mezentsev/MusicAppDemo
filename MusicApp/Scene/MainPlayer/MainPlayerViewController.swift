//
//  MainPlayerViewController.swift
//  MusicApp
//
//  Created by Vadim on 31/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import UIKit

protocol MainPlayerDisplayLogic: class {
    func displayPlayStartedState()
    func displayPauseState()
    func displayCurrentPlayTime(_ currentTimeText: String, _ timeLeftDurationText: String, _ currentTimePercantage: Float)
}

class MainPlayerViewController: UIViewController {
    
    // MARK: - Types
    
    enum State {
        case wait
        case play
        case pause
    }
    
    // MARK: - Properties
    
    var interactor: MainPlayerInteractor!
    var state: MainPlayerViewController.State! {
        didSet {
            changeState(to: state)
        }
    }
    var trackModel: TrackCellModel!
    
    // MARK: - Load view
    
    var mainPlayerView: MainPlayerView {
        return view as! MainPlayerView
    }
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupScene()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupScene()
    }
    
    // MARK: Setup scene
    
    private func setupScene() {
        let presenter = MainPlayerPresenter(viewController: self)
        let interactor = MainPlayerInteractor(presenter: presenter)
        self.interactor = interactor
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        set(from: trackModel)
    }

    // MARK: - IBAction

    @IBAction func dragDownButtomTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func trackPositionSliderChanged(_ sender: Any) {
        interactor.seek(to: mainPlayerView.currentTimeSlider.value)
    }
    
    @IBAction func volumeSliderChanged(_ sender: Any) {
        interactor.setVolume(to: mainPlayerView.volumeSlider.value)
    }
    
    @IBAction func previousTrackButtonTapped(_ sender: Any) {
    }
    
    @IBAction func nextTrackButtonTapped(_ sender: Any) {
    }
    
    @IBAction func playPouseButtonTapped(_ sender: Any) {
        interactor.playerStatusToggle()
    }
    
    // MARK: - Interface preparation
    
    private func set(from model: TrackCellModel) {
        mainPlayerView.trackTitleLabel.text = model.trackTitle
        mainPlayerView.authorLabel.text = model.artist
        if let previewUrl = model.previewUrl {
            interactor.playTrack(urlString: previewUrl)
            state = .wait
        }
        guard let string600 = model.imageUrl?.absoluteString.replacingOccurrences(of: "100x100", with: "600x600"),
            let url = URL(string: string600) else { return }
        mainPlayerView.trackImageView.setImage(from: url)
    }
    
    private func changeState(to state: MainPlayerViewController.State) {
        switch state {
        case .wait:
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
}

// MARK: - MainPlayerDisplayLogic

extension MainPlayerViewController: MainPlayerDisplayLogic {
    
    func displayPlayStartedState() {
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

}
