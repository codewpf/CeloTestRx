//
//  Person.swift
//  CeloTestRx
//
//  Created by Alex on 12/03/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import ObjectMapper

struct CTPersonModel: Mappable {
    
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
        uuid        <- map["uuid"]
    }
    
    func allInformation() -> String{
        return self.gender + " " + self.first + "" + self.last + " " + self.city + " " + self.state + " " + self.email + " " + self.phone + "" + self.cell
    }
}


extension Date {
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

