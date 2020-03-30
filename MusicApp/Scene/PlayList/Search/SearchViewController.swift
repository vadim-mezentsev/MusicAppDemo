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
    func displayTrack(_ trackCellModel: TrackCellModel, at index: Int)
    func selectTrack(at index: Int)
    func deselectTrack(at index: Int)
    func displayError(_ message: String)
}

class SearchViewController: PlayListViewController {
    
    // MARK: - View data
    
    private var cellViewModels: [TrackCellModel] = []
    
    // MARK: - Properties

    private(set) var input: SearchInput!
    private(set) var output: SearchOutput!
    private var interactor: SearchInteractorLogic!
    private var timer: Timer?

    // MARK: - Init
    
    init(libraryService: LibraryService) {
        super.init(nibName: nil, bundle: nil)
        setupScene(libraryService: libraryService)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard not supported")
    }
    
    // MARK: - Deinit
    
    deinit {
        interactor.prepareForRemove()
    }
    
    // MARK: Setup scene
    
    private func setupScene(libraryService: LibraryService) {
        let presenter = SearchPresenter(viewController: self)
        let interactor = SearchInteractor(presenter: presenter, libraryService: libraryService)
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
        playListView.defaultHintLabelText = "Enter your search term above".localized()
        
        navigationItem.searchController = playListView.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        playListView.searchController.searchBar.delegate = self
        playListView.tableView.dataSource = self
        playListView.tableView.delegate = self
        
        state = .wait
    }
    
}

// MARK: - SearchViewDisplayLogic

extension SearchViewController: SearchViewDisplayLogic {
    
    func displayTracks(_ trackCellModels: [TrackCellModel]) {
        cellViewModels = trackCellModels
        playListView.tableView.reloadData()
        state = .show
    }
    
    func displayTrack(_ trackCellModel: TrackCellModel, at index: Int) {
        cellViewModels[index] = trackCellModel
        if let cell = playListView.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TrackCell {
            cell.set(from: trackCellModel)
        }
    }
    
    func displayError(_ message: String) {
        playListView.hintLabel.text = message
        state = .error
    }
        
    func selectTrack(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        playListView.tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.middle)
        interactor.playTrack(index: indexPath.row)
    }
    
    func deselectTrack(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        playListView.tableView.deselectRow(at: indexPath, animated: false)
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
        cell.delegate = self
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
        playListView.searchController.searchBar.resignFirstResponder()
    }
}

// MARK: - TrackCellDelegate

extension SearchViewController: TrackCellDelegate {
    
    func addButtomTapped(at indexPath: IndexPath) {
        interactor.addTrackToLibrary(index: indexPath.row)
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
        playListView.tableView.stopDecelerating()
        cellViewModels = []
        playListView.tableView.reloadData()
        interactor.clearSearchResults()
    }
    
}
