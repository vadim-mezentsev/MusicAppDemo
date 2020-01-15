//
//  SearchViewController.swift
//  MusicApp
//
//  Created by Vadim on 14/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import UIKit

struct TrackCellModel {
    let trackName: String
    let artistName: String
}

protocol SearchViewDisplayLogic: class {
    //func displayForecast(viewModel: ForecastViewModel)
    //func displayError(message: String)
}

class SearchViewController: UIViewController, SearchViewDisplayLogic {

    // MARK: - Types
    
    enum State {
        case loading
        case show
        case error
    }
    
    // MARK: - View data
    
    var cellViewModels: [TrackCellModel] = [TrackCellModel(trackName: "Tr1", artistName: "An1"),
                                            TrackCellModel(trackName: "Tr2", artistName: "An2")]
    
    // MARK: - Properties
    
    var interactor: SearchInteractorLogic!
    var state: SearchViewController.State! {
        didSet {
            changeState(to: state)
        }
    }
    
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
    }

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Interface preparation

    private func setupView() {
        navigationItem.searchController = searchView.searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchView.searchController.searchBar.delegate = self
        searchView.tableView.dataSource = self
    }
    
    private func changeState(to state: SearchViewController.State) {
        switch state {
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

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = cellViewModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(cellViewModel.trackName) \(cellViewModel.artistName)"
        cell.imageView?.image = UIImage(systemName: "music.mic")
        return cell
    }
    
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }

}
