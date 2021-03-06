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
    
    let input: MiniPlayerInput
    let output: MiniPlayerOutput
    private let interactor: MiniPlayerInteractorLogic
    private var state: MiniPlayerViewController.State! {
        didSet {
            changeState(to: state)
        }
    }
    
    // MARK: - Load view
    
    var miniPlayerView: MiniPlayerView {
        return view as! MiniPlayerView
    }
    
    // MARK: - Init
    
    init(interactor: MiniPlayerInteractorLogic, input: MiniPlayerInput, output: MiniPlayerOutput) {
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
        setupView()
    }

    // MARK: - IBAction
    
    @IBAction private func playPouseButtonTapped(_ sender: Any) {
        if state == .play {
            state = .pause
        } else {
            state = .play
        }
        interactor.playerStatusToggle()
    }
    
    @IBAction private func nextTrackButtonTapped(_ sender: Any) {
        interactor.playNextTrack()
    }
    
    @IBAction private func viewTapped(_ sender: Any) {
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
            let image = Assets.Image.pauseFill
            miniPlayerView.playPouseButton.setImage(image, for: .normal)
            miniPlayerView.playPouseButton.isEnabled = true
            miniPlayerView.nextButton.isEnabled = true
        case .pause:
            let image = Assets.Image.playFill
            miniPlayerView.playPouseButton.setImage(image, for: .normal)
            miniPlayerView.playPouseButton.isEnabled = true
            miniPlayerView.nextButton.isEnabled = true
        }
    }
    
    deinit {
        interactor.prepareForRemove()
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
            miniPlayerView.flipTrackImageView(from: imageUrl)
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
