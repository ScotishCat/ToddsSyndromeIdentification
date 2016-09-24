//
//  Patient.swift
//  ToddsSyndromeIdentification
//
//  Created by Marina Butovich on 9/23/16.
//  Copyright © 2016 Marina Butovich. All rights reserved.
//

import Foundation

public enum Gender: Int {
    case male = 0
    case female = 1
    
    init?(desription: String) {
        switch desription {
        case "Male":
            self = .male
        case "Female":
            self = .female
        default:
            return nil
        }
    }
}

extension Gender: CustomStringConvertible {
    public var description: String {
        get {
            switch self {
            case .male:
                return "Male"
            case .female:
                return "Female"
            }
        }
    }
}

public struct Patient {
    let firstName: String
    let lastName: String
    
    let age: Int
    
    let gender: Gender
    
    let hasMigraines: Bool
    let usesDrugs: Bool
}

public extension Patient {
    func dictionaryRepresentation() -> NSDictionary {
        return ["firstName": firstName,
                "lastName": lastName,
                "age": age,
                "gender": gender.description,
                "hasMigraines": hasMigraines as NSNumber,
                "usesDrugs": usesDrugs as NSNumber] as NSDictionary
    }
    
    init?(dict: NSDictionary) {
        guard let firstName = dict["firstName"] as? String,
        let lastName = dict["lastName"] as? String,
        let age = dict["age"] as? Int,
        let genderString = dict["gender"] as? String, let gender = Gender(desription: genderString),
        let hasMigraines = dict["hasMigraines"] as? Bool,
        let usesDrugs = dict["usesDrugs"] as? Bool
        else {
            return nil
        }
        self.init(firstName: firstName,
                  lastName: lastName,
                  age: age,
                  gender: gender,
                  hasMigraines: hasMigraines,
                  usesDrugs: usesDrugs)
    }
}
