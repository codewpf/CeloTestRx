//
//  CTRefreshStatus.swift
//  CeloTestRx
//
//  Created by Alex on 14/03/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import MJRefresh

enum CTRefreshStatus {
    case none
    case beginHeaderRefresh
    case endHeaderRefresh
    case beginFooterRefresh
    case endFooterRefresh
    case noMoreData
    
    var refresh: String {
        get {
            switch self {
            case .none:
                return "None"
            case .beginHeaderRefresh:
                return "Begin Header Refresh"
            case .endHeaderRefresh:
                return "End Header Refresh"
            case .beginFooterRefresh:
                return "Begin Footer Refresh"
            case .endFooterRefresh:
                return "End Footer Refresh"
            case .noMoreData:
                return "No More Data"
            }
        }
    }
    
    
}
