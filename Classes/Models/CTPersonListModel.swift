//
//  Test.swift
//  CeloTestRx
//
//  Created by Alex on 12/03/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import RxDataSources

struct CTPersonListModel {
    var items: [CTPersonModel]
}

extension CTPersonListModel: SectionModelType {
    typealias Item = CTPersonModel

    init(original: CTPersonListModel, items: [CTPersonModel]) {
        self = original
        self.items = items
    }

}
