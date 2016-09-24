//
//  AddPatientViewController.swift
//  ToddsSyndromeIdentification
//
//  Created by Marina Butovich on 9/24/16.
//  Copyright © 2016 Marina Butovich. All rights reserved.
//

import Foundation
import UIKit

class AddPatientViewController: UIViewController {
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var ageField: UITextField!
    @IBOutlet var genderSegmentedControl: UISegmentedControl!
    @IBOutlet var migrainesSwitch: UISwitch!
    @IBOutlet var drugsSwitch: UISwitch!
    
    weak var delegate: AddPatientViewControllerDelegate?
    
    override func viewDidLoad() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(self.onCancel(button:)))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(self.onDone(button:)))
        
        let barItem = self.navigationItem
        barItem.leftBarButtonItem = cancelButton
        barItem.rightBarButtonItem = doneButton
    }
    
    @objc private func onCancel(button: UIBarButtonItem) {
        delegate?.addPatientViewController(didTapCancel: self)
    }
    
    @objc private func onDone(button: UIBarButtonItem) {
        let firstName = firstNameField.text!
        let lastName = lastNameField.text!

        let age = Int(ageField.text!) ?? 0
        let gender = Gender(rawValue: genderSegmentedControl.selectedSegmentIndex)!
        
        let hasMigraines = migrainesSwitch.isOn
        let usesDrugs = drugsSwitch.isOn
        
        let patient = Patient(firstName: firstName,
                              lastName: lastName,
                              age: age,
                              gender: gender,
                              hasMigraines: hasMigraines,
                              usesDrugs: usesDrugs)
        
        delegate?.addPatientViewController(self, didTapDoneWithPatient: patient)
    }
}
