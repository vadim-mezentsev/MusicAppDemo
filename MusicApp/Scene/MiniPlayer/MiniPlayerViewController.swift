//
//  MiniPlayerViewController.swift
//  MusicApp
//
//  Created by Vadim on 19/02/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import UIKit

protocol MiniPlayerDisplayLogic: class {
    func displayPlayState()
    func displayPauseState()
    func displayTrack(_ title: String, _ imageUrl: URL?)
    func togglePlayerStatus()
}

class MiniPlayerViewController: UIViewController {
    
    // MARK: - Types
    
    enum State {
        case wait
        case play
        case pause
    }
    
    // MARK: - Properties
    
    var input: MiniPlayerInput!
    var output: MiniPlayerOutput!
    var interactor: MiniPlayerInteractorLogic!
    var state: MiniPlayerViewController.State! {
        didSet {
            changeState(to: state)
        }
    }
    
    // MARK: - Load view
    
    var miniPlayerView: MiniPlayerView {
        return view as! MiniPlayerView
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
        let presenter = MiniPlayerPresenter(viewController: self)
        let interactor = MiniPlayerInteractor(presenter: presenter)
        self.interactor = interactor
        self.input = interactor
        self.output = interactor
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - IBAction
    
    @IBAction func playPouseButtonTapped(_ sender: Any) {
        if state == .play {
            state = .pause
        } else {
            state = .play
        }
        interactor.playerStatusToggle()
    }
    
    @IBAction func nextTrackButtonTapped(_ sender: Any) {
        interactor.playNextTrack()
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        interactor.showMainPlayer()
    }
    
    // MARK: - Interface preparation
    
    private func setupView() {
        state = .wait
    }
    
    private func changeState(to state: MiniPlayerViewController.State) {
        switch state {
        case .wait:
            miniPlayerView.trackTitleLabel.text = "Not Playing".localized()
            miniPlayerView.playPouseButton.isEnabled = false
            miniPlayerView.nextButton.isEnabled = false
        case .play:
            let image = UIImage(systemName: "pause.fill")
            miniPlayerView.playPouseButton.setImage(image, for: .normal)
            miniPlayerView.playPouseButton.isEnabled = true
            miniPlayerView.nextButton.isEnabled = true
            miniPlayerView.trackImageView.contentMode = .scaleToFill
        case .pause:
            let image = UIImage(systemName: "play.fill")
            miniPlayerView.playPouseButton.setImage(image, for: .normal)
            miniPlayerView.playPouseButton.isEnabled = true
            miniPlayerView.nextButton.isEnabled = true
            miniPlayerView.trackImageView.contentMode = .scaleToFill
        }
    }
}

// MARK: - MainPlayerDisplayLogic

extension MiniPlayerViewController: MiniPlayerDisplayLogic {
    
    func displayPlayState() {
        state = .play
    }
    
    func displayPauseState() {
        state = .pause
    }
    
    func displayTrack(_ title: String, _ imageUrl: URL?) {
        state = .play
        miniPlayerView.trackTitleLabel.text = title
        if let imageUrl = imageUrl {
            miniPlayerView.trackImageView.setImage(from: imageUrl)
        }
    }
    
    func togglePlayerStatus() {
        if state == .play {
            state = .pause
        } else {
            state = .play
        }
    }
    
}
