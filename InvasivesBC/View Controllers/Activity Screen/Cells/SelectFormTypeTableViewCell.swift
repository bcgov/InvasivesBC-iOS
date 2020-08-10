//
//  SelectFormTypeTableViewCell.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-07-24.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import UIKit

class SelectFormTypeTableViewCell: UITableViewCell, Theme {
    
    var observationCallback: (()->Void)?
    var treatmentCallback: (()->Void)?
    var monitoringCallback: (()->Void)?
    
    @IBOutlet weak var createObservationButton: UIButton!
    @IBOutlet weak var createTreatmentButton: UIButton!
    @IBOutlet weak var createMonitoringButton: UIButton!
    
    @IBAction func createObservationAction(_ sender: Any) {
        guard let callback = observationCallback else {return}
        callback()
    }
    
    @IBAction func createTreatmentAction(_ sender: Any) {
        guard let callback = treatmentCallback else {return}
        callback()
    }
    
    @IBAction func createMonitoringAction(_ sender: Any) {
        guard let callback = monitoringCallback else {return}
        callback()
    }
    
    func setup(
        onObservation: @escaping ()->Void,
        onTreatment: @escaping ()->Void,
        onMonitoring: @escaping ()->Void
    ) {
        self.observationCallback = onObservation
        self.treatmentCallback = onTreatment
        self.monitoringCallback = onMonitoring
        style()
    }
    
    func style() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        styleOnMap(button: createMonitoringButton)
        styleOnMap(button: createTreatmentButton)
        styleOnMap(button: createObservationButton)
    }
}
