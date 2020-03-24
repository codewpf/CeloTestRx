//
//  CTResponseObjectMapper.swift
//  CeloTestRx
//
//  Created by Alex on 15/03/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper


// MARK: - Json -> Model
extension Response {
    /// map json to a single model
    public func mapObject<T: BaseMappable>(_ type: T.Type) throws -> T {
        guard let object = Mapper<T>().map(JSONObject: try mapJSON()) else {
            throw MoyaError.jsonMapping(self)
        }
        return object
    }
    
    /// map json to model array
    public func mapArray<T:BaseMappable>(_ type: T.Type) throws -> [T] {
        guard let json = try mapJSON() as? [String : Any] else {
            throw MoyaError.jsonMapping(self)
        }

        //TODO: The key should be change for different json format
        guard let jsonArr = (json["results"] as? [[String : Any]]) else {
            throw MoyaError.jsonMapping(self)
        }
        
        return Mapper<T>().mapArray(JSONArray: jsonArr)
    }
}

// MARK: - Json -> Observable<Model>
extension ObservableType where Element == Response {
    /// json to Observable<Model>
    public func mapObject<T: BaseMappable>(_ type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapObject(T.self))
        }
    }
    /// json to Observable<[Model]>
    public func mapArray<T: BaseMappable>(_ type: T.Type) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapArray(T.self))
        }
    }
}
