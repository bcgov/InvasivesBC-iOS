//
//  LaunchViewController.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-07-23.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import UIKit
import MapKit

private enum Segues: String {
    case showActivity = "showActivity"
    case showTools = "showTools"
    case showStatus = "showStatus"
    case showLayers = "showLayers"
    case showPlantObservation = "showPlantObservation"
}

class LaunchViewController: BaseViewController {
    
    // MARK: Variables
    var tileRenderer: MKOverlayRenderer?
    var locationManager: CLLocationManager = CLLocationManager()
    var locationAuthorizationstatus: CLAuthorizationStatus?
    var currentLocation: CLLocation?
    
    // TEMP
    var plantObservationToShow: PlantObservationModel?
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var layersButton: UIButton!
    @IBOutlet weak var toolsButton: UIButton!
    @IBOutlet weak var activityButton: UIButton!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        setupMap()
        
         print("***")
        let allDrodowns = CodeTableService.shared.getAllDropdownNames()
        for each in allDrodowns {
            print(each)
        }
        
        print("***")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Segues.showPlantObservation.rawValue, let model = plantObservationToShow else {return}
        guard let plantObservationViewController = segue.destination as? PlantObservationViewController else { return }
        plantObservationViewController.setup(editable: false, model: model)
    }
    
    @IBAction func testPlantObservationButtonAction(_ sender: Any) {
        let allPlantObservations = StorageService.shared.getAllForms(type: .PlantObservation)
        if let last = allPlantObservations.last as? PlantObservationModel {
            plantObservationToShow = last
            performSegue(withIdentifier: Segues.showPlantObservation.rawValue, sender: self)
        } else {
            showAlert(with: "No Plant observations found", message: "Create a record first")
        }
        
    }
    
    @IBAction func layersAction(_ sender: Any) {
        performSegue(withIdentifier: Segues.showLayers.rawValue, sender: self)
    }
    
    @IBAction func toolsAction(_ sender: Any) {
        performSegue(withIdentifier: Segues.showTools.rawValue, sender: self)
    }
    
    @IBAction func activityAction(_ sender: Any) {
        performSegue(withIdentifier: Segues.showActivity.rawValue, sender: self)
    }
    
    @IBAction func statusAction(_ sender: Any) {
        performSegue(withIdentifier: Segues.showStatus.rawValue, sender: self)
    }
    
    @IBAction func locationAction(_ sender: Any) {
        guard let current = currentLocation else { return }
        let viewRegion = MKCoordinateRegion.init(center: current.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(viewRegion, animated: true)
    }
    
    
    // MARK: Style
    func style() {
        activityButton.accessibilityLabel = "activity"
        activityButton.accessibilityIdentifier = "activity"
        styleOnMap(button: layersButton)
        styleOnMap(button: toolsButton)
        styleOnMap(button: activityButton)
        styleOnMap(button: statusButton)
        styleOnMap(button: locationButton)
    }
}
