//
//  MiniPlayerPresenter.swift
//  MusicApp
//
//  Created by Vadim on 19/02/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

protocol MiniPlayerPresenterLogic: class {
}

class MiniPlayerPresenter: MiniPlayerPresenterLogic {
    
    // MARK: - Properties
    
    weak var viewController: MiniPlayerDisplayLogic?

    // MARK: - Init
    
    init(viewController: MiniPlayerDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - MiniPlayerPresenterLogic
    
    // MARK: - Helper methods

}
