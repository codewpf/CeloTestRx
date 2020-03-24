//
//  DTDataBaseable.swift
//  NZDriverTest
//
//  Created by Alex on 21/03/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FMDB

typealias CTDataBaseHanlder = (_ status: Result<String, Error>) -> ()

protocol CTDataBasable {
}
extension CTDataBasable {
    
    static func createTable(with sql: String) -> Observable<String> {
        return Observable.create { (observer) -> Disposable in
            CTDataBaseManager.manager.dbQueue?.inDatabase({ (db) in
                if db.executeUpdate(sql, withArgumentsIn: []){
                    observer.on(.next("Success"))
                    observer.on(.completed)

                }else{
                    observer.on(.error(db.lastError()))
                }
            })
            return Disposables.create()
        }
    }
    
    func insertTable(with sql: String, arguments: [String]) -> Observable<[CTModelResultSetable]> {
        return Observable.create { (observer) -> Disposable in
            CTDataBaseManager.manager.dbQueue?.inDatabase({ (db) in
                if db.executeUpdate(sql, withArgumentsIn: arguments){
                    observer.on(.next([]))
                    observer.on(.completed)
                }else{
                    observer.on(.error(db.lastError()))
                }
            })
            return Disposables.create()
        }        
    }
    
    static func queryTable<Model: CTModelResultSetable>(with sql: String, model: Model.Type) -> Observable<[Model]> {
        return Observable.create { (observer) -> Disposable in
            CTDataBaseManager.manager.dbQueue?.inDatabase({ (db) in
                if let res = db.executeQuery(sql, withArgumentsIn: []){
                    var results: [Model] = []
                    while res.next() {
                        results.append(Model(res: res))
                    }
                    res.close()
                    observer.on(.next(results))
                    observer.on(.completed)
                }else{
                    observer.on(.error(db.lastError()))
                }
            })
            return Disposables.create()
        }
    }
    
}

