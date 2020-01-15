//
//  ApiResponse.swift
//  MusicApp
//
//  Created by Vadim on 15/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

protocol ApiResponse: Decodable {
    associatedtype ContentModel: Decodable
    
    var resultCount: Int { get }
    var results: [ContentModel] { get }
}
