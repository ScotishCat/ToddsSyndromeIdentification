//
//  AddPatientViewControllerDelegate.swift
//  ToddsSyndromeIdentification
//
//  Created by Marina Butovich on 9/24/16.
//  Copyright © 2016 Marina Butovich. All rights reserved.
//

import Foundation

protocol AddPatientViewControllerDelegate: class {
    func addPatientViewController(didTapCancel addPatientViewController: AddPatientViewController)

    func addPatientViewController(_ addPatientViewController: AddPatientViewController,
                                  didTapDoneWithPatient patient: Patient)
}
