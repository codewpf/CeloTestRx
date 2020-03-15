//
//  CTViewModelType.swift
//  CeloTestRx
//
//  Created by Alex on 14/03/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

protocol CTViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}
