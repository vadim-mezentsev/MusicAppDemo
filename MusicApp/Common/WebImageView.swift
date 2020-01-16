//
//  WebImageView.swift
//  MusicApp
//
//  Created by Vadim on 15/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import UIKit

class WebImageView: UIImageView {
    
    private var currentUrl: URL!
    
    func setImage(from url: URL) {
        currentUrl = url
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] (data, _, _) in
            guard url == self?.currentUrl else { return }
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.image = image
            }
        }
        dataTask.resume()
    }
}
