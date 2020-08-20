//
//  MapExtension.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-07-23.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import Foundation
import MapKit

extension LaunchViewController: MKMapViewDelegate {
    
    func setupMap() {
        setupTileRenderer()
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        // TODO: Set lat long to Center of BC and change latitudinalMeters & longitudinalMeters appropriately
        var noLocation = CLLocationCoordinate2D()
        noLocation.latitude = 48.424251
        print("noLocation.Latitude is \(noLocation.latitude)")
        noLocation.longitude = -123.365729
        
      
        let viewRegion = MKCoordinateRegion.init(center: noLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(viewRegion, animated: true)
        
        setupLocation()
        
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
