//
//  GomometryPickerGestures.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-08-14.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import Foundation
import UIKit
import MapKit

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
        var newPolygonGeometryPoints = polygonGeometryPoints
        newPolygonGeometryPoints.append(location)
        if newPolygonGeometryPoints.count >= 3 && regionArea(locations: newPolygonGeometryPoints) > maxPolygonArea {
            showAlert(with: "Maximum area is \(maxPolygonArea) sq metres", message: "The maximum area has exceeded \(maxPolygonArea) sq metres (1 hectare).")
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
