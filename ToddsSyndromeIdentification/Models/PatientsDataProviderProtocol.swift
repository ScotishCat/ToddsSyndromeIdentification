//
//  PatientsDataProviderProtocol.swift
//  ToddsSyndromeIdentification
//
//  Created by Marina Butovich on 9/23/16.
//  Copyright © 2016 Marina Butovich. All rights reserved.
//

import Foundation

public protocol PatientsDataProviderProtocol: class {
    func loadCards(completion: @escaping (_ cards: [PatientCard]?) -> ())
    func saveCards(cards: [PatientCard], completion: @escaping (_ success: Bool) -> ())
}
