//
//  GeometryPickerViewController.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-08-11.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import UIKit

private enum Segues: String {
    case PlantObservation = "showPlantObservationForm"
    case PlantMonitoring = "PlantMonitoring"
    case PlantTreatment = "PlantTreatment"
}

class GeometryPickerViewController: BaseViewController {
    
    var formType: ActivityFormType?
    var geometryType: DefineGeometryType?
    
    @IBOutlet weak var tempButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setup(form type: ActivityFormType, geometry: DefineGeometryType) {
        self.formType = type
        self.geometryType = geometry
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier, let segueId = Segues(rawValue: id) else {return}
        switch segueId {
        case .PlantObservation:
            guard let destination = segue.destination as? PlantObservationViewController else {return}
            // TODO:
            // Here we would set gemotry(selected in this component) for the form (destination)
        case .PlantMonitoring:
            return
        case .PlantTreatment:
            return
        }
    }
    
    @IBAction func tempButtonAction(_ sender: Any) {
        guard let type = formType else {return}
        switch type {
        case .PlantObservation:
            performSegue(withIdentifier: Segues.PlantObservation.rawValue, sender: self)
        case .PlantTreatment:
            showAlert(with: "Form type not supported", message: "")
        case .PlantMonitoring:
            showAlert(with: "Form type not supported", message: "")
        case .AnimalObservation:
            showAlert(with: "Form type not supported", message: "")
        case .AnimalTreatment:
            showAlert(with: "Form type not supported", message: "")
        case .AnimalMonitoring:
            showAlert(with: "Form type not supported", message: "")
        }
        
    }
    
}
