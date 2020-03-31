//
//  NetworkError.swift
//  MusicApp
//
//  Created by Vadim on 15/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest(initialError: Error?)
    case invalidResponse
    case invalidJSON
}

extension NetworkError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidRequest(let initialError):
            return initialError?.localizedDescription ?? "Invalid request.".localized()
        case .invalidResponse:
            return "Invalid response format.".localized()
        case .invalidJSON:
            return "Error parsing JSON.".localized()
        }
    }
    
}
