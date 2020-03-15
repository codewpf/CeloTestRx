//
//  CTNetworkManager.swift
//  CeloTestRx
//
//  Created by Alex on 14/03/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Moya

let CTNetworkManager = MoyaProvider<CTNetworkService>()

enum CTNetworkPath: String {
    case getPerson = "/api"
}

enum CTNetworkService {
    case getPerson(path: CTNetworkPath, pageSize: Int, pageIdx: Int)
}

extension CTNetworkService: TargetType {
    var baseURL: URL { return URL(string: "https://randomuser.me")!}
    
    var path: String {
        switch self {
        case .getPerson(let path,_, _): return path.rawValue
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".utf8Encoded
    }
    
    var task: Task {
        switch self {
        case let .getPerson(_,pageSize, pageIdx):
            return .requestParameters(parameters: ["seed": "CeloTest", "results": "\(pageSize)", "page": "\(pageIdx)"], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}




// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}

