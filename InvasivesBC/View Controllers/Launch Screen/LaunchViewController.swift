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
}

class LaunchViewController: BaseViewController {
    
    // MARK: Variables
    var tileRenderer: MKOverlayRenderer?
    var locationManager: CLLocationManager = CLLocationManager()
    var locationAuthorizationstatus: CLAuthorizationStatus?
    var currentLocation: CLLocation?
    
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
        styleOnMap(button: layersButton)
        styleOnMap(button: toolsButton)
        styleOnMap(button: activityButton)
        styleOnMap(button: statusButton)
        styleOnMap(button: locationButton)
    }
}
