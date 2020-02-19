//
//  MiniPlayerViewController.swift
//  MusicApp
//
//  Created by Vadim on 19/02/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import UIKit

protocol MiniPlayerDisplayLogic: class {

}

class MiniPlayerViewController: UIViewController {
    
    // MARK: - Types
    
    enum State {
        case some
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
    }

    // MARK: - IBAction
    
    // MARK: - Interface preparation
    
    private func changeState(to state: MiniPlayerViewController.State) {
        switch state {
        case .some: break
        }
    }
}

// MARK: - MainPlayerDisplayLogic

extension MiniPlayerViewController: MiniPlayerDisplayLogic {

}
