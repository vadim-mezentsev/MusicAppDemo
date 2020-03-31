//
//  TrackCell.swift
//  MusicApp
//
//  Created by Vadim on 15/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import UIKit

protocol TrackCellDelegate: class {
    func addButtomTapped(at indexPath: IndexPath)
}

class TrackCell: UITableViewCell, IdentifiableCellFromNib {
    
    // MARK: - Properties
    
    weak var delegate: TrackCellDelegate?

    // MARK: - Interface properties
    
    @IBOutlet private(set) weak var trackImageView: WebImageView!
    @IBOutlet private(set) weak var trackTitleLabel: UILabel!
    @IBOutlet private(set) weak var artistLabel: UILabel!
    @IBOutlet private(set) weak var collectionLabel: UILabel!
    @IBOutlet private(set) weak var addButton: UIButton!

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
    
    @IBAction private func addButtomTapped(_ sender: Any) {
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
