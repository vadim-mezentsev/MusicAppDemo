//
//  LibraryBuilder.swift
//  MusicApp
//
//  Created by Vadim on 30/03/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

class LibraryBuilder {
    
    private let libraryService: LibraryService
    
    init(libraryService: LibraryService) {
        self.libraryService = libraryService
    }
    
    func build() -> LibraryViewController {
        let presenter = LibraryPresenter()
        let interactor = LibraryInteractor(presenter: presenter, libraryService: libraryService)
        let viewController = LibraryViewController(
            interactor: interactor,
            input: interactor,
            output: interactor)
        presenter.viewController = viewController
        return viewController
    }
    
}
