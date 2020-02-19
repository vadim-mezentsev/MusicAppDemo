//
//  SearchViewController.swift
//  MusicApp
//
//  Created by Vadim on 14/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import UIKit

protocol SearchViewDisplayLogic: class {
    func displayTracks(_ trackCellModels: [TrackCellModel])
    func displayError(_ message: String)
    func selectCell(at row: Int)
}

class SearchViewController: UIViewController {

    // MARK: - Types
    
    enum State {
        case wait
        case loading
        case show
        case error
    }
    
    // MARK: - View data
    
    var cellViewModels: [TrackCellModel] = [] {
        didSet {
            searchView.tableView.reloadData()
        }
    }
    
    // MARK: - Properties

    var input: SearchInput!
    var output: SearchOutput!
    var interactor: SearchInteractorLogic!
    var state: SearchViewController.State! {
        didSet {
            changeState(to: state)
        }
    }
    private var timer: Timer?
    
    // MARK: - Load view
    
    var searchView = SearchView()
    override func loadView() {
        view = searchView
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
        let presenter = SearchPresenter(viewController: self)
        let interactor = SearchInteractor(presenter: presenter)
        self.interactor = interactor
        self.input = interactor
        self.output = interactor
    }

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Interface preparation

    private func setupView() {
        state = .wait
        
        navigationItem.searchController = searchView.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchView.searchController.searchBar.delegate = self
        searchView.tableView.dataSource = self
        searchView.tableView.delegate = self
    }
    
    private func changeState(to state: SearchViewController.State) {
        switch state {
        case .wait:
            searchView.hintLabel.text = "Enter your search term above".localized()
            searchView.hideSubviews(except: [searchView.hintLabel])
        case .loading:
            searchView.activityIndicator.startAnimating()
            searchView.hideSubviews(except: [searchView.activityIndicator])
        case .show:
            searchView.activityIndicator.stopAnimating()
            searchView.showSubviews(except: [searchView.activityIndicator, searchView.hintLabel])
        case .error:
            searchView.activityIndicator.stopAnimating()
            searchView.hideSubviews(except: [searchView.hintLabel])
        }
    }
    
}

// MARK: - SearchViewDisplayLogic

extension SearchViewController: SearchViewDisplayLogic {
    
    func displayTracks(_ trackCellModels: [TrackCellModel]) {
        cellViewModels = trackCellModels
        state = .show
    }
    
    func displayError(_ message: String) {
        searchView.hintLabel.text = message
        state = .error
    }
        
    func selectCell(at row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        searchView.tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.middle)
        interactor.playTrack(index: indexPath.row)
    }
    
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = cellViewModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as! TrackCell
        cell.set(from: cellViewModel)
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor.playTrack(index: indexPath.row)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchView.searchController.searchBar.resignFirstResponder()
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        
        guard !searchText.isEmpty else {
            state = .wait
            return
        }
    
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.state = .loading
            self?.interactor.fetchTracks(for: searchText)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        state = .wait
        searchView.tableView.stopDecelerating()
        cellViewModels = []
    }
    
}
