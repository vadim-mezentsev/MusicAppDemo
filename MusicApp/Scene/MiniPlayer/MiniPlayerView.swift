//
//  MiniPlayerView.swift
//  MusicApp
//
//  Created by Vadim on 19/02/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import UIKit

class MiniPlayerView: UIView {
    
    // MARK: - Appereance
    
    private let separatorViewHeight: CGFloat = 1
    private let trackImageViewCornerRadius: CGFloat = 4
    
    // MARK: - Interface properties
    
    @IBOutlet private(set) weak var trackImageView: WebImageView!
    @IBOutlet private(set) weak var trackTitleLabel: UILabel!
    @IBOutlet private(set) weak var playPouseButton: UIButton!
    @IBOutlet private(set) weak var nextButton: UIButton!
    
    private(set) lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    private(set) lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Setup view
    
    private func setupView() {
        backgroundColor = .clear
        setupBlurView()
        setupSeparatorView()
    }
    
    private func setupBlurView() {
        insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupSeparatorView() {
        addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: separatorViewHeight),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    // MARK: - Life cicle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        trackImageView.layer.cornerRadius = trackImageViewCornerRadius
        trackImageView.backgroundColor = .systemGray2
    }
    
    // MARK: - Animation

    func flipTrackImageView(from url: URL) {
        let fakeImageView = UIImageView()
        fakeImageView.frame = trackImageView.frame
        fakeImageView.image = trackImageView.image
        fakeImageView.layer.cornerRadius = trackImageViewCornerRadius
        trackImageView.superview!.addSubview(fakeImageView)
        trackImageView.setImage(from: url)
        layoutIfNeeded()
        
        UIView.transition(
            from: fakeImageView,
            to: trackImageView,
            duration: 1,
            options: [.curveEaseInOut, .transitionFlipFromRight],
            completion: { _ in
                fakeImageView.removeFromSuperview()
            }
        )
    }
}
