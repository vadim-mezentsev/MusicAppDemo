//
//  ItunesUrlHelper.swift
//  MusicApp
//
//  Created by Vadim on 15/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

class ItunesUrlHelper {
    
    // MARK: - Types
    
    private enum QueryItemKey: String {
        case term
        case media
        case limit
    }

    // MARK: - Properties
    
    private let scheme = "https"
    private let host = "itunes.apple.com"
    private let rootPath = "/search"
    private let queryItems: [(QueryItemKey, String)] = [
        (.media, "music"),
        (.limit, "30")
    ]
    
    private var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = rootPath
        urlComponents.queryItems = queryItems.map { URLQueryItem(name: $0.rawValue, value: $1) }
        return urlComponents
    }

    // MARK: - Build URL methods
    
    func fetchTracksUrl(for term: String) -> URL {
        var urlComponents = self.urlComponents
        urlComponents.queryItems?.append(URLQueryItem(name: QueryItemKey.term.rawValue, value: term))
        return urlComponents.url!
    }

}
