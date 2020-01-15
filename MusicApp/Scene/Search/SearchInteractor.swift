//
//  SearchInteractor.swift
//  MusicApp
//
//  Created by Vadim on 15/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

protocol SearchInteractorLogic: class {
    //func fetchForecast(for sign: Sign)
}

class SearchInteractor: SearchInteractorLogic {

    // MARK: - Properties
    
    var presenter: SearchPresenterLogic!

    // MARK: - Init
    
    init(presenter: SearchPresenterLogic) {
        self.presenter = presenter
    }
    
}
