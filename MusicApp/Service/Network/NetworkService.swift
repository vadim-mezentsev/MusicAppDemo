//
//  NetworkService.swift
//  MusicApp
//
//  Created by Vadim on 15/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

class NetworkService {

    // MARK: - Properties
    
    private let urlHelper = ItunesUrlHelper()
    private let completionQueue: DispatchQueue!
    
    // MARK: - Init
    
    init(completionQueue: DispatchQueue) {
        self.completionQueue = completionQueue
    }

    // MARK: - Fetch tracks
    
    func fetchTracks(term: String, completion: @escaping (Result<TracksResponce, NetworkError>) -> Void) {
        let url = urlHelper.fetchTracksUrl(for: term)
        fetchModel(TracksResponce.self, from: url) { [weak self] (result) in
            self?.completionQueue.async {
                completion(result)
            }
        }
    }
    
    // MARK: - Fetch models
    
    private func fetchModel<T: ApiResponse>(_ modelType: T.Type, from url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        request(url) { [weak self] (result) in
            switch result {
            case .success(let data):
                if let model = self?.decodeJSON(modelType, from: data) {
                    completion(.success(model))
                } else {
                    let parsingError = NetworkError(message: "Error parsing JSON.".localized(), type: .invalidJSON)
                    completion(.failure(parsingError))
                }
            case .failure(let error):
                print(error.message)
                completion(.failure(error))
            }

        }
    }
    
    private func decodeJSON<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch let error {
            print(error)
        }
        return nil
    }
    
    private func request(_ url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                let requestError = NetworkError(message: error!.localizedDescription, type: .invalidRequest)
                completion(.failure(requestError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data else {
                let requestError = NetworkError(message: "Invalid response format.".localized(), type: .invalidResponse)
                completion(.failure(requestError))
                return
            }
            
            completion(.success(data))
        }
        dataTask.resume()
    }
}
