//
//  PatientsPersistencyManager.swift
//  ToddsSyndromeIdentification
//
//  Created by Marina Butovich on 9/23/16.
//  Copyright © 2016 Marina Butovich. All rights reserved.
//

import Foundation

public class PatientsPersistencyManager: PatientsDataProviderProtocol {
    var baseURL: URL
    private var cardsURL: URL {
        get {
            return self.baseURL.appendingPathComponent("PatientCards")
        }
    }
    
    init(with baseURL: URL) {
        self.baseURL = baseURL
    }
    
    public func loadCards(completion: @escaping (_ cards: [PatientCard]?) -> ()) {
        DispatchQueue.global(qos: .default).async {
            let destinationURL = self.cardsURL
            let data = try? Data(contentsOf: destinationURL)
            guard let plistData = data,
            let plistArray = try? PropertyListSerialization.propertyList(from: plistData,
                                                                         options: [],
                                                                         format: nil),
            let cardsArray = plistArray as? NSArray else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            var cards = [PatientCard]()
            for cardDict in cardsArray {
                let card = PatientCard(dict: cardDict as! NSDictionary)
                if let card = card {
                    cards.append(card)
                }
            }
            
            DispatchQueue.main.async {
                if cards.count == 0 {
                    completion(nil)
                } else {
                    completion(cards)
                }
            }
        }
    }
    
    public func saveCards(cards: [PatientCard], completion: @escaping (_ success: Bool) -> ()) {
        DispatchQueue.global(qos: .default).async {
            let cardsDicts = cards.map { $0.dictionaryRepresentation() }
            
            guard let data = try? PropertyListSerialization.data(fromPropertyList: cardsDicts,
                                                                 format: .binary,
                                                                 options: 0) else {
                DispatchQueue.main.async {
                    completion(false)
                }
                
                return
            }
            
            let destinationURL = self.cardsURL
            do {
                try data.write(to: destinationURL)
                
                DispatchQueue.main.async {
                    completion(true)
                }
            }
            catch (let error) {
                NSLog("ERROR: Failed to save data at URL: \(destinationURL), with error: \(error)")
            }
            
        }
    }
}
