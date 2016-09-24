//
//  ToddsSyndromeIdentificationTests.swift
//  ToddsSyndromeIdentificationTests
//
//  Created by Marina Butovich on 9/23/16.
//  Copyright © 2016 Marina Butovich. All rights reserved.
//

import XCTest
@testable import ToddsSyndromeIdentification

class ToddsSyndromeIdentificationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDictionarySerialization() {
        let patient = Patient(firstName: "John", lastName: "Doe", age: 15, gender: .male, hasMigraines: true, usesDrugs: false)
        let patientDict = patient.dictionaryRepresentation()
        XCTAssertTrue(patientDict.isKind(of: NSDictionary.self), "Invalid class")
        XCTAssertTrue(PropertyListSerialization.propertyList(patientDict, isValidFor: .binary), "")
        
        let newPatient = Patient(dict: patientDict)
        XCTAssertTrue(newPatient != nil, "Patient must be created from a dictionary representation")

        var card = PatientCard(patient: patient)
        card.addSyndrome(syndrome: Syndrome(type: .toddsSyndrome, probability: 40.0))
        let cardDict = card.dictionaryRepresentation()
        XCTAssertTrue(cardDict.isKind(of: NSDictionary.self), "Invalid class")
        let newCard = PatientCard(dict: cardDict)
        XCTAssertTrue(newCard != nil, "Patient card must be created from a dictionary representation")
        XCTAssertEqual(newCard!.syndromes.count, 1, "")
        
        XCTAssertTrue(PropertyListSerialization.propertyList(cardDict, isValidFor: .binary), "")
    }
    
    func testPersistencyManager() {
        let saveExpectation = expectation(description: "Saved context successfully")
        
        let destinationURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true, relativeTo: nil)
        let manager = PatientsPersistencyManager(with: destinationURL)
        
        let patient1 = Patient(firstName: "John", lastName: "Doe", age: 15, gender: .male, hasMigraines: true, usesDrugs: false)
        let card1 = PatientCard(patient: patient1)
        let patient2 = Patient(firstName: "Jane", lastName: "Smith", age: 16, gender: .female, hasMigraines: false, usesDrugs: true)
        let card2 = PatientCard(patient: patient2)
        let patient3 = Patient(firstName: "Bruce", lastName: "Willis", age: 46, gender: .male, hasMigraines: false, usesDrugs: true)
        let card3 = PatientCard(patient: patient3)
        
        manager.saveCards(cards: [card1, card2, card3]) {
            (success) in
            XCTAssertTrue(success, "Failed to save cards")
            saveExpectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
        
        let loadExpectation = expectation(description: "Loaded context successfully")
        manager.loadCards {
            (cards) in
            XCTAssertEqual(cards?.count, 3, "Count must be equal")
            loadExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
