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

class SearchViewController: UIViewController {

    // MARK: - View data
    
    var cellViewModels: [TrackCellModel] = [TrackCellModel(trackName: "Tr1", artistName: "An1"),
                                            TrackCellModel(trackName: "Tr2", artistName: "An2")]
    
    // MARK: - Load view
    
    var searchView = SearchView()
    override func loadView() {
        view = searchView
    }
    
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
