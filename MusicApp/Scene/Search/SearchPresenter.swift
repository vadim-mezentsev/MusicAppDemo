//
//  SearchPresenter.swift
//  MusicApp
//
//  Created by Vadim on 15/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

protocol SearchPresenterLogic: class {
    //func fetchForecast(for sign: Sign)
}

class SearchPresenter: SearchPresenterLogic {
    
    // MARK: - Properties
    
    weak var viewController: SearchViewDisplayLogic?

    // MARK: - Init
    
    init(viewController: SearchViewDisplayLogic) {
        self.viewController = viewController
    }
    
}
