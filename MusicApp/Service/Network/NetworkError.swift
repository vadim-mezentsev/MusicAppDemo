//
//  NetworkError.swift
//  MusicApp
//
//  Created by Vadim on 15/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

struct NetworkError: Error {
    enum ErrorType {
        case invalidRequest
        case invalidResponse
        case invalidJSON
    }
    
    let message: String
    let type: ErrorType
}
