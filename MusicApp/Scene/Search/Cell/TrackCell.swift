//
//  TrackCell.swift
//  MusicApp
//
//  Created by Vadim on 15/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import UIKit

struct TrackCellModel {
    let imageUrl: URL?
    let trackTitle: String
    let artist: String
    let collection: String
}

class TrackCell: UITableViewCell, IdentifiableCellFromNib {

    // MARK: - Interface properties
    
    @IBOutlet weak var trackImageView: WebImageView!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var collectionLabel: UILabel!

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Setup view
    
    func set(from model: TrackCellModel) {
        trackTitleLabel.text = model.trackTitle
        artistLabel.text = model.artist
        collectionLabel.text = model.collection
        
        if let url = model.imageUrl {
            trackImageView.setImage(from: url)
        }
    }

    private func setup() {
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        trackImageView.image = nil
    }
    
}
