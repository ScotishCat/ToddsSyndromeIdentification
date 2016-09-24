//
//  Syndrome.swift
//  ToddsSyndromeIdentification
//
//  Created by Marina Butovich on 9/24/16.
//  Copyright © 2016 Marina Butovich. All rights reserved.
//

import Foundation

public enum SyndromeType: Int {
    case toddsSyndrome
    
    init?(description: String) {
        switch description {
        case "Todd's Syndrome":
            self = .toddsSyndrome
        default:
            return nil
        }
    }
}

extension SyndromeType: CustomStringConvertible {
    public var description: String {
        get {
            switch self {
            case .toddsSyndrome:
                return "Todd's Syndrome"
            }
        }
    }
}

public struct Syndrome {
    let type: SyndromeType
    var probability: Double
}

public extension Syndrome {
    func dictionaryRepresentation() -> NSDictionary {
        return ["type": self.type.description, "probability": self.probability] as NSDictionary
    }
    
    init?(dict: NSDictionary) {
        guard let typeString = dict["type"] as? String,
            let type = SyndromeType(description: typeString),
            let probability = dict["probability"] as? Double
        else {
            return nil
        }
        
        self.init(type: type, probability: probability)
    }
}
