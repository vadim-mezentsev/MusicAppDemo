//
//  PlayListViewController.swift
//  MusicApp
//
//  Created by Vadim on 26/02/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import UIKit

class PlayListViewController: UIViewController {

    // MARK: - Types
    
    enum State {
        case wait
        case loading
        case show
        case error
    }
    
    // MARK: - Properties

    var state: SearchViewController.State! {
        didSet {
            changeState(to: state)
        }
    }
    
    // MARK: - Load view
    
    var playListView = PlayListView()
    override func loadView() {
        view = playListView
    }
    
    // MARK: - Interface preparation

    private func changeState(to state: SearchViewController.State) {
        switch state {
        case .wait:
            playListView.hintLabel.text = playListView.defaultHintLabelText
            playListView.hideSubviews(except: [playListView.hintLabel])
        case .loading:
            playListView.activityIndicator.startAnimating()
            playListView.hideSubviews(except: [playListView.activityIndicator])
        case .show:
            playListView.activityIndicator.stopAnimating()
            playListView.showSubviews(except: [playListView.activityIndicator, playListView.hintLabel])
        case .error:
            playListView.activityIndicator.stopAnimating()
            playListView.hideSubviews(except: [playListView.hintLabel])
        }
    }
}
