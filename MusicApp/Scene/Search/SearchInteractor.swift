//
//  SearchInteractor.swift
//  MusicApp
//
//  Created by Vadim on 15/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

protocol SearchInteractorLogic: class {
    func fetchTracks(for term: String)
}

class SearchInteractor: SearchInteractorLogic {

    // MARK: - Properties
    
    var presenter: SearchPresenterLogic!
    var operationQueue: DispatchQueue!
    var networkService: NetworkService!

    // MARK: - Init
    
    init(presenter: SearchPresenterLogic) {
        self.presenter = presenter
        self.operationQueue = DispatchQueue(label: "SearchOperationQueue", qos: .userInitiated)
        self.networkService = NetworkService(completionQueue: operationQueue)
    }
  
    // MARK: - SearchInteractorLogic
    
    func fetchTracks(for term: String) {
        networkService.fetchTracks(term: term) { [weak self] (result) in
            switch result {
            case .success(let responce):
                if responce.results.isEmpty {
                    self?.presenter.presentError("Your search returned no results".localized())
                } else {
                   self?.presenter.presentTracks(responce.results)
                }
            case .failure(let error):
                self?.presenter.presentError(error.message)
            }
        }
    }
}
