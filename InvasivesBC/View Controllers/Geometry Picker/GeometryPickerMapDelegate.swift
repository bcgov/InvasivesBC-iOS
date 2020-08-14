//
//  GeometryPickerMapDelegate.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-08-14.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import Foundation
import MapKit

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
