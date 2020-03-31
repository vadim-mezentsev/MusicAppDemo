//
//  UITableView + extension.swift
//  MusicApp
//
//  Created by Vadim on 16/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import UIKit

extension UITableView {
    
    func stopDecelerating() {
        setContentOffset(contentOffset, animated: false)
    }
}
