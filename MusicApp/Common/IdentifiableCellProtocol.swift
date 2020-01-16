//
//  IdentifiableCellProtocol.swift
//  MusicApp
//
//  Created by Vadim on 15/01/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import UIKit

protocol IdentifiableCell: class {
    static var reuseId: String { get }
}

extension IdentifiableCell {
    static var reuseId: String { return String(describing: self) }
}

protocol IdentifiableCellFromNib: IdentifiableCell {
    static var nib: UINib { get }
}

extension IdentifiableCellFromNib {
    static var nib: UINib { return UINib(nibName: String(describing: self), bundle: nil) }
}
