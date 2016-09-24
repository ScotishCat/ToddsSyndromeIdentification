//
//  ToddsSyndromeDetector.swift
//  ToddsSyndromeIdentification
//
//  Created by Marina Butovich on 9/23/16.
//  Copyright © 2016 Marina Butovich. All rights reserved.
//

import Foundation

internal class ToddsSyndromeDetector: SyndromeDetector {
    func getSyndromeProbability(patient: Patient) -> Double {
        var probability = 0.0
        
        if patient.hasMigraines {
            probability += 25
        }

        if patient.age <= 15 {
            probability += 25
        }
        
        if patient.gender == .male {
            probability += 25
        }

        if patient.usesDrugs {
            probability += 25
        }
        
        return probability
    }
}
