//
//  TrackPlayerView.swift
//  MusicApp
//
//  Created by Vadim on 16/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import UIKit

class MainPlayerView: UIView {
    
    // MARK: - Appereance
    
    private let trackImageViewScaleDownTransform: CGAffineTransform = {
        let scale: CGFloat = 0.8
        return CGAffineTransform(scaleX: scale, y: scale)
    }()
    private let trackImageViewCornerRadius: CGFloat = 8
    
    // MARK: - Interface properties
    
    @IBOutlet weak var trackImageView: WebImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var playPouseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    // MARK: - Life cicle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        trackImageView.transform = trackImageViewScaleDownTransform
        trackImageView.layer.cornerRadius = trackImageViewCornerRadius
        trackImageView.backgroundColor = .systemGray2
    }
    
    // MARK: - Animation
    
    func scaleUpTrackImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {  [weak self] in
            self?.trackImageView.transform = .identity
            }
        )
    }
    
    func scaleDownTrackImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {  [weak self] in
            guard let self = self else { return }
            self.trackImageView.transform = self.trackImageViewScaleDownTransform
            }
        )
    }
    
}
