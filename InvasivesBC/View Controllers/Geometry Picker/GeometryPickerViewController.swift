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
    
    // polygon gemoetry variables
    var polygonGeometryPoints: [CLLocationCoordinate2D] = []
    var polygonCache: MKPolygon?
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
            // TODO:
            // Here we would set gemotry(selected in this component) for the form (destination)
            let newPlantObservation = PlantObservationModel()
            if let userId =  SettingsService.shared.getUserAuthId() {
                newPlantObservation.userId = userId
            }
            destination.setup(editable: true, model: newPlantObservation)
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
            instructionLabel.text = "Click on the approximate centre of your area and extend the radius feature to capture an area up to 100 sq meters."
        case .TwoPoint:
            instructionLabel.text = "Define 2 or more points along the center of a path then specify a buffer width value."
        case .WayPoint:
            instructionLabel.text = "Click on the approximate centre of your area then specify a height length and width value."
        case .Polygon:
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
}

extension GeometryPickerViewController: MKMapViewDelegate {
    
    func setupMap() {
        setupTileRenderer()
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        // TODO: Set lat long to Center of BC and change latitudinalMeters & longitudinalMeters appropriately
        var noLocation = CLLocationCoordinate2D()
        noLocation.latitude = 48.424251
        noLocation.longitude = -123.365729
        let viewRegion = MKCoordinateRegion.init(center: noLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(viewRegion, animated: true)
        
//        setupLocation()
        
        // TODO: Set map's Zoom limit to match what BC Gov has
    }
    
    func setupTileRenderer() {
        let overlay = CustomMapOverlay()
        overlay.canReplaceMapContent = true
        mapView.addOverlay(overlay, level: .aboveLabels)
        tileRenderer = MKTileOverlayRenderer(tileOverlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("map moved")
    }
    
    // Customize Polygons, polylines and Tiles
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(overlay: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.3)
            renderer.strokeColor = UIColor.black
            renderer.lineWidth = 2
            return renderer
        } else if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.black
            renderer.lineWidth = 2
            return renderer
        }
        guard let custom = tileRenderer else {
            return MKOverlayRenderer()
        }
        return custom
    }
    
    // Customize annotion look
    /*
     func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
     }
     */
    
}

// MARK: Gestures
extension GeometryPickerViewController {
    func addMapGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        guard let type = geometryType else {return}
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        switch type {
        case .Point:
            handleTapForPoint(at: coordinate)
        case .TwoPoint:
            handleTapForTwoPoint(at: coordinate)
        case .WayPoint:
            handleTapForWayPoint(at: coordinate)
        case .Polygon:
            handleTapForPolygon(at: coordinate)
        }
    }
    
    func handleTapForPoint(at location: CLLocationCoordinate2D) {
        showAlert(with: "Geometry type not supported", message: "")
    }
    
    func handleTapForTwoPoint(at location: CLLocationCoordinate2D) {
        showAlert(with: "Geometry type not supported", message: "")
    }
    
    func handleTapForWayPoint(at location: CLLocationCoordinate2D) {
        showAlert(with: "Geometry type not supported", message: "")
    }
    
    func handleTapForPolygon(at location: CLLocationCoordinate2D) {
        guard canAddPolygonNode(at: location) else {return}
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        
        polygonGeometryPoints.append(location)
        
        if polygonGeometryPoints.count >= 3 {
            nextButton.isHidden = false
            let polygon = MKPolygon(coordinates: polygonGeometryPoints, count: polygonGeometryPoints.count)
            if let existing = polygonCache {
                mapView.removeOverlay(existing)
            }
            polygonCache = polygon
            mapView.addOverlay(polygon)
        }
        styleButtons()
    }
    
    func canAddPolygonNode(at location: CLLocationCoordinate2D) -> Bool {
        // - Max 20 points
        if polygonGeometryPoints.count >= 20 {
            showAlert(with: "Too many vertices", message: "The number of vertices used to record and draw the polygon is capped at 20 points")
            return false
        }
        // - Distance between points must be more than 1 meter
        if let last = polygonGeometryPoints.last {
            let lastLocation = CLLocation(latitude: last.latitude, longitude: last.longitude)
            let newLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            if lastLocation.distance(from: newLocation) < 1 {
                showAlert(with: "Too close", message: "The minimum vertex distance is to be 1.0 meters.")
                return false
            }
        }
        
        // - Computed area must be less than 20000
        if polygonGeometryPoints.count >= 3 && regionArea(locations: polygonGeometryPoints) > 20000 {
            showAlert(with: "Maximum area is 20000", message: "The maximum of 2000 sq meters.")
            return false
        }
        
        return true
    }
    
    func regionArea(locations: [CLLocationCoordinate2D]) -> Double {
        guard locations.count > 2 else { return 0 }
        var area = 0.0
        let kEarthRadius = 6378137.0
        for i in 0..<locations.count {
            let p1 = locations[i > 0 ? i - 1 : locations.count - 1]
            let p2 = locations[i]

            area += radians(degrees: p2.longitude - p1.longitude) * (2 + sin(radians(degrees: p1.latitude)) + sin(radians(degrees: p2.latitude)) )
        }
        area = -(area * kEarthRadius * kEarthRadius / 2)
        return max(area, -area) // In order not to worry about is polygon clockwise or counterclockwise defined.
    }
    
    func radians(degrees: Double) -> Double {
        return degrees * .pi / 180
    }
}
