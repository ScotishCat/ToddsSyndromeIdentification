//
//  PatientCard.swift
//  ToddsSyndromeIdentification
//
//  Created by Marina Butovich on 9/24/16.
//  Copyright © 2016 Marina Butovich. All rights reserved.
//

import Foundation

public struct PatientCard {
    let patient: Patient
    
    var syndromes = [Syndrome]()
    
    init(patient: Patient) {
        self.patient = patient
    }

    init(patient: Patient, syndromes: [Syndrome]) {
        self.patient = patient
        self.syndromes = syndromes
    }

    mutating func addSyndrome(syndrome: Syndrome) {
        var hasFoundSyndrome = false
        for var currentSyndrome in self.syndromes {
            if currentSyndrome.type == syndrome.type {
                currentSyndrome.probability = syndrome.probability
                hasFoundSyndrome = true
                break
            }
        }
        
        if !hasFoundSyndrome {
            self.syndromes.append(syndrome)
        }
    }
    
    mutating func removeSyndrome(syndromeType: SyndromeType) {
        var index: Int?
        for iterator in self.syndromes.enumerated() {
            if iterator.element.type == syndromeType {
                index = iterator.offset
                break
            }
        }
        
        guard let indexToRemove = index else {
            return
        }
        
        syndromes.remove(at: indexToRemove)
    }
}

public extension PatientCard {
    func dictionaryRepresentation() -> NSDictionary {
        return ["patient": patient.dictionaryRepresentation(),
                "syndromes": syndromes.map({$0.dictionaryRepresentation()}) as NSArray] as NSDictionary
    }
    
    init?(dict: NSDictionary) {
        let optionalSyndromes = dict["syndromes"]
        guard let patientDict = dict["patient"] as? NSDictionary,
            let patient = Patient(dict: patientDict),
            let syndromesArray = optionalSyndromes as? NSArray
        else {
            return nil
        }
        
        let syndromes: [Syndrome] = syndromesArray.map { (dictionary) in
            return Syndrome(dict: dictionary as! NSDictionary)!
        }
        
        self.init(patient: patient, syndromes: syndromes)
    }
}
