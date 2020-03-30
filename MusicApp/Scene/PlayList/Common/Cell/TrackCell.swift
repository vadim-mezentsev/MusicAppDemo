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
    let isAddedToLibrary: Bool
}

protocol TrackCellDelegate: class {
    func addButtomTapped(at indexPath: IndexPath)
}

class TrackCell: UITableViewCell, IdentifiableCellFromNib {
    
    // MARK: - Properties
    
    weak var delegate: TrackCellDelegate?

    // MARK: - Interface properties
    
    @IBOutlet weak var trackImageView: WebImageView!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!

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
    
    // MARK: - IBAction
    
    @IBAction func addButtomTapped(_ sender: Any) {
        guard
            let tableView = superview as? UITableView,
            let indexPath = tableView.indexPath(for: self)
        else {
            return
        }
        delegate?.addButtomTapped(at: indexPath)
    }
    
    // MARK: - Setup view
    
    func set(from model: TrackCellModel) {
        trackTitleLabel.text = model.trackTitle
        artistLabel.text = model.artist
        collectionLabel.text = model.collection
        addButton.isHidden = model.isAddedToLibrary
        
        if let url = model.imageUrl {
            trackImageView.setImage(from: url)
        }
    }

    private func setup() {
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackImageView.image = nil
    }
    
}
