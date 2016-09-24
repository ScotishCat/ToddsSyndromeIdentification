//
//  PatientsViewController.swift
//  ToddsSyndromeIdentification
//
//  Created by Marina Butovich on 9/23/16.
//  Copyright © 2016 Marina Butovich. All rights reserved.
//

import UIKit

class PatientsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var patientCards = [PatientCard]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension PatientsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientCards.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: PatientCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! PatientCell
        
        let card = self.patientCards[indexPath.row]
        let patient = card.patient
        
        cell.nameLabel.text = "\(patient.firstName) \(patient.lastName)"
        cell.ageLabel.text = "Age: \(patient.age)"
        cell.genderLabel.text = "\(patient.gender)"
        
        let toddsSyndromeProbability = card.syndromes.filter {
            $0.type == .toddsSyndrome
        }.first?.probability

        if let toddsSyndromeProbability = toddsSyndromeProbability {
            cell.toddsProbabilityLabel.text = "Todd’s Syndrome probability: \(toddsSyndromeProbability)%"
        }
        
        return cell
    }
}

