//
//  CTDetailModel.swift
//  CeloTestRx
//
//  Created by Alex on 17/03/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

struct CTDetailModel {
    let details: [(String, String)]
    init(details: [(String, String)]) {
        self.details = details
    }
    
    static func personToDetail(person: CTPersonModel) -> CTDetailModel {
        var temp: [(String, String)] = []
        temp.append(("Profile Photo",person.large))
        temp.append(("Name",person.fullName()))
        temp.append(("Gender",person.gender))
        temp.append(("Location",person.location()))
        temp.append(("Email",person.email))
        temp.append(("Birthday",person.birthdayString()))
        temp.append(("Phone",person.phone))
        temp.append(("Cell Phone",person.cell))
        return CTDetailModel(details: temp)
    }
}

