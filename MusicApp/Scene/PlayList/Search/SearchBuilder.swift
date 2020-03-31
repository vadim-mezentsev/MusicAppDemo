//
//  SearchViewBuilder.swift
//  MusicApp
//
//  Created by Vadim on 30/03/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

class SearchBuilder {
    
    private let libraryService: LibraryService
    
    init(libraryService: LibraryService) {
        self.libraryService = libraryService
    }
    
    func build() -> SearchViewController {
        let presenter = SearchPresenter()
        let interactor = SearchInteractor(presenter: presenter, libraryService: libraryService)
        let viewController = SearchViewController(
            interactor: interactor,
            input: interactor,
            output: interactor)
        
        presenter.viewController = viewController
        return viewController
    }
    
}
