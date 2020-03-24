//
//  CTDataBaseManager.swift
//  NZDriverTest
//
//  Created by Alex on 19/03/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import FMDB

struct CTDataBaseManager {
    private let dbName = "celorx.db"
    
    static var manager: CTDataBaseManager = CTDataBaseManager()
    private init() {
    }
    
    lazy var dbURL: URL = {
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask,
                 appropriateFor: nil, create: true)
            .appendingPathComponent(dbName)
        return fileURL
    }()
    
    lazy var db: FMDatabase = {
        let database = FMDatabase(url: dbURL)
        return database
    }()
    
    lazy var dbQueue: FMDatabaseQueue? = {
        let databaseQueue = FMDatabaseQueue(url: dbURL)
        return databaseQueue
    }()


}
