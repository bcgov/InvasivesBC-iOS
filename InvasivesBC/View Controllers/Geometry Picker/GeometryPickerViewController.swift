//
//  GeometryPickerViewController.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-08-11.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import UIKit
import MapKit

private enum Segues: String {
    case PlantObservation = "showPlantObservationForm"
    case PlantMonitoring = "PlantMonitoring"
    case PlantTreatment = "PlantTreatment"
}

class GeometryPickerViewController: BaseViewController, UIGestureRecognizerDelegate {
    
    // Custom tile renderer
    var tileRenderer: MKOverlayRenderer?
    
    var formType: ActivityFormType?
    var geometryType: DefineGeometryType?
    
    // point gemoetry variables
    var point: CLLocationCoordinate2D?
    var pointCache: MKAnnotation?
    ///
    
    // polygon gemoetry variables
    var polygonGeometryPoints: [CLLocationCoordinate2D] = []
    var polygonCache: MKPolygon?
    let maxPolygonArea: Double = 10000
    ///
    
    // waypoint geometry variables
    var wayPointGeometryPoints: [CLLocationCoordinate2D] = []
    var wayPointPolygonCache: MKPolygon?
    ///
    
    // 2 point geometry variables
    var twoPointGeometryPoints: [CLLocationCoordinate2D] = []
    var twoPointLineCache: MKPolyline?
    ///
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var instructionContainer: UIView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addMapGestureRecognizer()
        setupMap()
        style()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    
    func setup(form type: ActivityFormType, geometry: DefineGeometryType) {
        formType = type
        geometryType = geometry
        styleForGeometryType()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier, let segueId = Segues(rawValue: id) else {return}
        switch segueId {
        case .PlantObservation:
            guard let destination = segue.destination as? PlantObservationViewController else {return}
            
            // REALM:
            let newPlantObservation = PlantObservationModel()
            // Add User id - So when user logs out and different user logs in, we can differentiate the data
            if let userId = SettingsService.shared.getUserAuthId() {
                newPlantObservation.userId = userId
            }
            // Add GeoJSON
            if let geoJSON = getGeoJSON() {
                newPlantObservation.add(geoJSON: geoJSON)
            }
            // Add lat, long and area
            if let first = polygonGeometryPoints.first {
                newPlantObservation.add(latitude: first.latitude, longitude: first.longitude, area: regionArea(locations: polygonGeometryPoints))
                
                            
            }
            print("first.latitude is \(newPlantObservation.latitude)")
            print("first.longitude is \(newPlantObservation.longitude)")
            print("first.area is \(newPlantObservation.area)")
            
            
            let GRDBFriendlyCoordinates = polygonGeometryPoints.map { [$0.longitude, $0.latitude]}
            // GRDB
            let locationAndGeometryRecord = LocationAndGeometry(local_activity_id: 0, anchorPointY: polygonGeometryPoints[0].latitude, anchorPointX: polygonGeometryPoints[0].longitude, area: 0, geometry: Geometry(type: "Polygon", coordinates_Poly: GRDBFriendlyCoordinates))
            
            // Pass values to view controller
            destination.setup(editable: true, model: newPlantObservation)
            destination.setup(locationAndGeometryRecord: locationAndGeometryRecord)
            
        case .PlantMonitoring:
            return
        case .PlantTreatment:
            return
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        guard let type = formType, validates() else {return}
        
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
    
    @IBAction func clearAction(_ sender: Any) {
        guard let type = geometryType else {return}
        switch type {
        case .Point:
            // TODO:
            return
        case .TwoPoint:
            // TODO:
            return
        case .WayPoint:
            // TODO:
            return
        case .Polygon:
            polygonGeometryPoints.removeAll()
            if let polygon = polygonCache {
                mapView.removeOverlay(polygon)
                polygonCache = nil
            }
            mapView.removeAnnotations(mapView.annotations)
            styleButtons()
        }
    }
    
    func validates() -> Bool {
        guard let type = geometryType else {
            return false
        }
        
        switch type {
        case .Point:
            return true
        case .TwoPoint:
            return true
        case .WayPoint:
            return true
        case .Polygon:
            return regionArea(locations: polygonGeometryPoints) > 1
        }
    }
    
    func style() {
        instructionLabel.font = UIFont.semibold(size: 18)
        styleForGeometryType()
        styleButtons()
    }
    
    func styleForGeometryType() {
        guard instructionContainer != nil else {return}
        guard let type = geometryType else {
            instructionContainer.alpha = 0
            return
        }
        instructionContainer.alpha = 1
        switch type {
        case .Point:
            // TODO: Set page title here (appears in nav bar)
            title = "Define Point geometry"
            instructionLabel.text = "Click on the approximate centre of your area and extend the radius feature to capture an area up to 100 sq meters."
        case .TwoPoint:
            // TODO: Set page title here (appears in nav bar)
            title = "Define 2 Point geometry"
            instructionLabel.text = "Define 2 or more points along the center of a path then specify a buffer width value."
        case .WayPoint:
            // TODO: Set page title here (appears in nav bar)
            title = "Define Waypoint"
            instructionLabel.text = "Click on the approximate centre of your area then specify a height length and width value."
        case .Polygon:
            // TODO: Set page title here (appears in nav bar)
            title = "Define Polygon"
            instructionLabel.text = "Define 3 or more points along the boundary edge then return to your start point to close the polygon."
        }
    }
    
    func styleButtons() {
        guard let type = geometryType else {
            return
        }
        nextButton.backgroundColor = UIColor.primaryContrast
        nextButton.setTitleColor(UIColor.primary, for: .normal)
        nextButton.layer.cornerRadius = 8
        clearButton.backgroundColor = UIColor.primaryContrast
        clearButton.setTitleColor(UIColor.primary, for: .normal)
        clearButton.layer.cornerRadius = 8
        switch type {
        case .Point:
            // TODO:
            clearButton.isHidden = true
            nextButton.isHidden = true
            return
        case .TwoPoint:
            // TODO:
            clearButton.isHidden = true
            nextButton.isHidden = true
            return
        case .WayPoint:
            // TODO:
            clearButton.isHidden = true
            nextButton.isHidden = true
            return
        case .Polygon:
            clearButton.isHidden = polygonGeometryPoints.isEmpty
            nextButton.isHidden = polygonCache == nil
        }
    }
    
    func getGeoJSON() -> GeoJSON? {
        guard let type = geometryType else {return nil}
        let geoJSON = GeoJSON()
        switch type {
        case .Point:
            guard let p = point else {return nil}
            let location = CLLocation(latitude: p.latitude, longitude: p.longitude)
            geoJSON.addGeometry(with: [location], type: type)
            return geoJSON
        case .TwoPoint:
            let locations = twoPointGeometryPoints.map({CLLocation(latitude: $0.latitude, longitude: $0.longitude)})
            geoJSON.addGeometry(with: locations, type: type)
            return geoJSON
        case .WayPoint:
            let locations = wayPointGeometryPoints.map({CLLocation(latitude: $0.latitude, longitude: $0.longitude)})
            geoJSON.addGeometry(with: locations, type: type)
            return geoJSON
        case .Polygon:
            let locations = polygonGeometryPoints.map({CLLocation(latitude: $0.latitude, longitude: $0.longitude)})
            geoJSON.addGeometry(with: locations, type: type)
            return geoJSON
        }
    }
}
