//
//  UIView + extension.swift
//  MusicApp
//
//  Created by Vadim on 15/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import UIKit

extension UIView {
    
    func hideSubviews(except: Set<UIView> = []) {
        for subview in subviews {
            if except.contains(subview) {
                subview.isHidden = false
                continue
            }
            subview.isHidden = true
        }
    }
    
    @objc     func showSubviews(except: Set<UIView> = []) {
        for subview in subviews {
            if except.contains(subview) {
                subview.isHidden = true
                continue
            }
            subview.isHidden = false
        }
    }
}
