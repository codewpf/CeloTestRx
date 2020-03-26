//
//  Person.swift
//  CeloTestRx
//
//  Created by Alex on 12/03/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import ObjectMapper
import FMDB
import RxSwift

struct CTPersonModel: Mappable, CTModelResultSetable  {
    
    static let sql = "CREATE TABLE IF NOT EXISTS Person( \n " +
        "id INTEGER PRIMARY KEY, \n " +
        "gender TEXT NOT NULL, \n " +
        "name TEXT NOT NULL, \n " +
        "location TEXT NOT NULL, \n " +
        "email TEXT NOT NULL, \n " +
        "birthday TEXT NOT NULL, \n " +
        "phone TEXT NOT NULL, \n " +
        "cell TEXT NOT NULL, \n " +
        "thumbnail TEXT NOT NULL, \n " +
        "large TEXT NOT NULL, \n " +
        "uuid TEXT NOT NULL UNIQUE\n " +
    "); \n"
    
    private let dateFormat = "yyyy-MM-dd"
    
    var gender: String = ""
    var first: String  = ""
    var last: String  = ""
    var city: String = ""
    var state: String = ""
    var email: String = ""
    var birthday: Date = Date()
    var phone: String = ""
    var cell: String = ""
    var thumbnail: String = ""
    var large: String = ""
    var uuid: String = ""
    
    static let disposeBag: DisposeBag = DisposeBag()
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        gender      <- map["gender"]
        first       <- map["name.first"]
        last        <- map["name.last"]
        city        <- map["location.city"]
        state       <- map["location.state"]
        email       <- map["email"]
        birthday    <- (map["dob.date"], DateTransform())
        phone       <- map["phone"]
        cell        <- map["cell"]
        thumbnail   <- map["picture.thumbnail"]
        large       <- map["picture.large"]
        uuid        <- map["login.uuid"]
    }
    
    
    init(res: FMResultSet) {
        self.gender = res.string(forColumn: "gender") ?? "gender"
        self.first = res.string(forColumn: "first") ?? "first"
        self.last = res.string(forColumn: "last") ?? "last"
        self.city = res.string(forColumn: "city") ?? "city"
        self.state = res.string(forColumn: "state") ?? "state"
        self.email = res.string(forColumn: "email") ?? "email"
        self.birthday = (res.string(forColumn: "email") ?? "email").toDate(format: dateFormat)
        self.phone = res.string(forColumn: "phone") ?? "phone"
        self.cell = res.string(forColumn: "cell") ?? "cell"
        self.thumbnail = res.string(forColumn: "thumbnail") ?? "thumbnail"
        self.large = res.string(forColumn: "large") ?? "large"
        self.uuid = res.string(forColumn: "uuid") ?? "uuid"
        
    }
    
    func allInformation() -> String{
        return self.gender + " " + self.first + "" + self.last + " " + self.city + " " + self.state + " " + self.email + " " + self.phone + "" + self.cell
    }
    
    func fullName() -> String {
        return self.first + " " + self.last
    }
    
    func location() -> String {
        return self.city + " " + self.state
    }
    
    func birthdayString() -> String {
        return self.birthday.toString(format: dateFormat)
    }
}


extension CTPersonModel: CTDataBasable {
    func insertPerson() -> Completable {
        let sql = "INSERT OR IGNORE INTO Person(gender, name, location, email, birthday, phone, cell, thumbnail, large, uuid) VALUES(?,?,?,?,?,?,?,?,?,?)"
        let arguments = [self.gender, self.fullName(), self.location(), self.email, self.birthdayString(), self.phone, self.cell, self.thumbnail, self.large, self.uuid]
        return self.insertTable(with: sql, arguments: arguments)
    }
    
    static func queryPerson(with pageIndx: Int, pageSize: Int) -> Observable<[CTPersonModel]> {
        let sql = "SELECT * FROM Person LIMIT \((pageIndx-1) * pageSize),\(pageSize)"
        return self.queryTable(with: sql, model: CTPersonModel.self)
    }
    
}


extension Date {
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension String {
    func toDate(format: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self) ?? Date()
        
    }
}

