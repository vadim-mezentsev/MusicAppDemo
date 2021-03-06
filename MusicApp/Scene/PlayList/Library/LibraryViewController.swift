//
//  ViewController.swift
//  MusicApp
//
//  Created by Vadim on 14/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import UIKit

protocol LibraryViewDisplayLogic: class {
    func displayTracks(_ trackCellModels: [TrackCellModel])
    func displayNewTrack(_ trackCellModel: TrackCellModel)
    func removeTrack(at index: Int)
    func selectTrack(at index: Int)
    func deselectTrack(at index: Int)
    func displayError(_ message: String)
}

class LibraryViewController: PlayListViewController {
    
    // MARK: - View data
    
    private var cellViewModels: [TrackCellModel] = []
    
    // MARK: - Properties

    let input: LibraryInput
    let output: LibraryOutput
    private let interactor: LibraryInteractorLogic
    
    // MARK: - Init
    
    init(interactor: LibraryInteractorLogic, input: LibraryInput, output: LibraryOutput) {
        self.interactor = interactor
        self.input = input
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard not supported")
    }
    
    // MARK: - Deinit
    
    deinit {
        interactor.prepareForRemove()
    }

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Interface preparation

    private func setupView() {
        playListView.defaultHintLabelText = "Add tracks to library".localized()

        playListView.tableView.dataSource = self
        playListView.tableView.delegate = self
                
        state = .wait
        
        interactor.fetchTracks()
    }

}

// MARK: - LibraryViewDisplayLogic

extension LibraryViewController: LibraryViewDisplayLogic {
    
    func displayTracks(_ trackCellModels: [TrackCellModel]) {
        cellViewModels = trackCellModels
        playListView.tableView.reloadData()
        state = .show
    }
    
    func displayNewTrack(_ trackCellModel: TrackCellModel) {
        cellViewModels.append(trackCellModel)
        playListView.tableView.reloadData()
        state = .show
    }
    
    func removeTrack(at index: Int) {
        cellViewModels.remove(at: index)
        playListView.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        state = cellViewModels.isEmpty ? .wait : .show
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
    
    func deselectTrack(at indexPath: Int) {
        let indexPath = IndexPath(row: indexPath, section: 0)
        playListView.tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

// MARK: - UITableViewDataSource

extension LibraryViewController: UITableViewDataSource {
    
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

extension LibraryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor.playTrack(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            interactor.removeTrack(at: indexPath.row)
        }
    }

}
