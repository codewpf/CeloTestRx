//
//  CTCellConstant.swift
//  CeloTestRx
//
//  Created by Alex on 16/03/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit

protocol CTCellConstant {
    static var height: CGFloat { get }

}

extension CTCellConstant {
    func cellMargin() -> CGFloat {
        return 25
    }
}
