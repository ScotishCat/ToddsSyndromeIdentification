//
//  AppCoordinator.swift
//  ToddsSyndromeIdentification
//
//  Created by Marina Butovich on 9/24/16.
//  Copyright © 2016 Marina Butovich. All rights reserved.
//

import UIKit

class AppCoordinator {
    var window: UIWindow
    var rootController: UINavigationController! = nil
    var patientsController: PatientsViewController! = nil
    var addPatientController: AddPatientViewController! = nil
    
    var dataProvider: PatientsDataProviderProtocol! = nil
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        guard let destinationURL = FileManager.default.urls(for: .documentDirectory,
                                                            in: .userDomainMask).first else {
            NSLog("Error: persistency URL cannot be created")
            abort()
        }
        
        self.dataProvider = self.makeDataProvider(withURL: destinationURL)
        
        self.patientsController = self.makePatientsController()
        let navController = UINavigationController(rootViewController: patientsController)
        self.rootController = navController
        self.window.rootViewController = navController
        self.window.makeKeyAndVisible()
        
        self.dataProvider.loadCards {
            (cards) in
            self.patientsController.patientCards = cards ?? []
        }
    }
    
    private func makeDataProvider(withURL destinationURL: URL) -> PatientsDataProviderProtocol {
        return PatientsPersistencyManager(with: destinationURL)
    }
    
    private func makePatientsController() -> PatientsViewController {
        let identifier = String(describing: PatientsViewController.self)
        let patientsController = self.controllerWithID(identifier: identifier)
        patientsController.title = "Patients"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(self.onAddButton(button:)))
        
        let barItem = patientsController.navigationItem
        barItem.rightBarButtonItem = addButton
        
        return patientsController as! PatientsViewController
    }
    
    private func makeAddPatientController() -> AddPatientViewController {
        let identifier = String(describing: AddPatientViewController.self)
        let addPatientController = self.controllerWithID(identifier: identifier)
        
        return addPatientController as! AddPatientViewController
    }
    
    private func controllerWithID(identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        
        return viewController
    }
    
    @objc private func onAddButton(button: UIBarButtonItem) {
        self.addPatientController = self.makeAddPatientController()
        self.rootController.pushViewController(self.addPatientController, animated: true)
        self.addPatientController.delegate = self
    }
}

extension AppCoordinator: AddPatientViewControllerDelegate {
    
    func addPatientViewController(_ addPatientViewController: AddPatientViewController,
                                  didTapDoneWithPatient patient: Patient)
    {
        var card = PatientCard(patient: patient)
        
        let syndromeDetector = makeSyndromeDetector(syndrome: .toddsSyndrome)
        let toddsSyndromeProbability = syndromeDetector.getSyndromeProbability(patient: patient)
        
        card.addSyndrome(syndrome: Syndrome(type: .toddsSyndrome,
                                            probability: toddsSyndromeProbability))
        
        var cards = self.patientsController.patientCards
        cards.append(card)
        
        dataProvider.saveCards(cards: cards) {
            (success) in
            if success {
                self.patientsController.patientCards = cards
            }
        }
        
        self.rootController.popViewController(animated: true)
    }
    
    func addPatientViewController(didTapCancel addPatientViewController: AddPatientViewController) {
        self.rootController.popViewController(animated: true)
    }
}
