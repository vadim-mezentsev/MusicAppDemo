//
//  PlayListView.swift
//  MusicApp
//
//  Created by Vadim on 14/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import UIKit

class PlayListView: UIView {

    // MARK: - Appereance
    
    var tableViewRowHeight: CGFloat = 84
    var tableViewBottomInset: CGFloat = 252
    var defaultHintLabelText: String = ""
    
    // MARK: - Interface properties

    lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "SearchBarPlaceholder".localized()
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TrackCell.nib, forCellReuseIdentifier: TrackCell.reuseId)
        tableView.rowHeight = tableViewRowHeight
        tableView.contentInset.bottom = tableViewBottomInset
        return tableView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    lazy var hintLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // MARK: - Life cicle
    
    override func safeAreaInsetsDidChange() {
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Setup view
    
    private func setupView() {
        backgroundColor = .systemBackground
        setupTableView()
        setupActivityIndicator()
        setupHintLabel()
    }
    
    private func setupTableView() {
        addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    private func setupActivityIndicator() {
        addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    private func setupHintLabel() {
        addSubview(hintLabel)
        
        hintLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.7).isActive = true
        hintLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        hintLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
    }
}
