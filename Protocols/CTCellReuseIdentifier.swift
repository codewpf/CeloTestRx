//
//  CTCellReuseIdentifier.swift
//  CeloTestRx
//
//  Created by Alex on 12/03/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

protocol CTCellReuseIdentifier {}

extension CTCellReuseIdentifier {
    static var identifier: String {
        get {
            return "\(Self.self)_identifier"
        }
    }
}


