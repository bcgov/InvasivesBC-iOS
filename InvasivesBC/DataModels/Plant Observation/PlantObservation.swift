//
//  Observation.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-08-12.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import Foundation
import Realm
import RealmSwift


import MapKit
class GeoJSONCoordinate: BaseObject {
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    
    func toDictionary() -> [Double] {
        return [longitude, latitude]
    }
}

class GeoJSONGeometry: BaseObject {
    @objc dynamic var type: String = ""
    var coordinates: List<GeoJSONCoordinate> = List<GeoJSONCoordinate>()
    
    func toDictionary() -> [String: Any] {
        var coordinatesDict: [[Double]] = [[Double]]()
        for coordinate in coordinates {
            coordinatesDict.append(coordinate.toDictionary())
        }
        let geometry: [String: Any] = [
            "type": "Polygon",
            "coordinates": coordinatesDict
        ]
        return [
            "type": "Feature",
            "properties": {},
            "geometry": geometry
        ]
    }
}
// MARK: Add a geometry
class GeoJSON: BaseObject {
    var geometries: List<GeoJSONGeometry> = List<GeoJSONGeometry>()
    
    func addGeometry(with coordinates: [CLLocation], type: DefineGeometryType) {
        var geometryType = ""
        switch type {
        case .Point:
            // TODO: GEOJSON does not support circle
            geometryType = "Point"
        case .TwoPoint:
            geometryType = "Line"
        case .WayPoint:
            geometryType = "Polygon"
        case .Polygon:
            geometryType = "Polygon"
        }
        let geoCoordinates: List<GeoJSONCoordinate> = List<GeoJSONCoordinate>()
        // Create array of GeoJSONCoordinate
        for coordinate in coordinates {
            let geoCoordinate = GeoJSONCoordinate()
            do {
                let realm = try Realm()
                try realm.write {
                    geoCoordinate.latitude = coordinate.coordinate.latitude
                    geoCoordinate.longitude = coordinate.coordinate.longitude
                }
            } catch let error as NSError {
                print("** REALM ERROR")
                print(error)
            }
            geoCoordinates.append(geoCoordinate)
        }
        ///
        // Write Geometry Data
        let geoJSONGeometry = GeoJSONGeometry()
        do {
            let realm = try Realm()
            try realm.write {
                geoJSONGeometry.type = geometryType
                geoJSONGeometry.coordinates = geoCoordinates
                self.geometries.append(geoJSONGeometry)
            }
        } catch let error as NSError {
            print("** REALM ERROR")
            print(error)
        }
    }
    
    func toDictionary() -> [String: Any] {
        var features: [[String: Any]] = [[String: Any]]()
        for geometry in geometries {
            features.append(geometry.toDictionary())
        }
        return [
              "type": "FeatureCollection",
              "features": features
        ]
    }
}

class PlantObservationModel: BaseObject {
    
    @objc dynamic var userId: String = ""
    
    @objc dynamic var status: String = "Draft"
    
    let drodownKeys: [String] = [
        "observationGeometryCode",
        "species",
        "observationTypeCode",
        "speciesAgencyCode",
        "jurisdictionCode",
        "speciesDensityCode",
        "soilTextureCode",
        "slopeCode",
        "aspectCode",
        "specificUseCode",
        "proposedActionCode",
        "lifeStageCode",
        "speciesDistributionCode"
    ]
    
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    @objc dynamic var observationGeometryCode: String = ""
    @objc dynamic var area: Double = 0
    @objc dynamic var wellDistance: Double = 0
    
    @objc dynamic var wellTagId: Double = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var time: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var species: String = ""
    @objc dynamic var observationTypeCode: String = ""
    @objc dynamic var speciesAgencyCode: String = ""
    @objc dynamic var jurisdictionCode: String = ""
    @objc dynamic var speciesDensityCode: String = ""
    @objc dynamic var soilTextureCode: String = ""
    @objc dynamic var speciesDistributionCode: String = ""
    
    @objc dynamic var slopeCode: String = ""
    @objc dynamic var aspectCode: String = ""
    // TODO: Code table doesnt exist + should be added to drodownKeys when it does
    @objc dynamic var flowering: String = ""
    //
    @objc dynamic var specificUseCode: String = ""
    @objc dynamic var proposedActionCode: String = ""
    // TODO: Code table doesnt exist + should be added to drodownKeys when it does
    @objc dynamic var seedStage: String = ""
    //
    // TODO: Code table doesnt exist + should be added to drodownKeys when it does
    @objc dynamic var plantHealth: String = ""
    //
    @objc dynamic var lifeStageCode: String = ""
    
    @objc dynamic var earlyDetection: Bool = false
    @objc dynamic var research: Bool = false
    @objc dynamic var wellOnSite: Bool = false
    @objc dynamic var specialCare: Bool = false
    @objc dynamic var biologicalCare: Bool = false
    @objc dynamic var legacySite: Bool = false
    
    @objc dynamic var primaryFileId: String = ""
    @objc dynamic var secondaryFileId: String = ""
    @objc dynamic var rangeUnit: String = ""
    @objc dynamic var locationComments: String = ""
    @objc dynamic var generalComments: String = ""
    
    @objc dynamic var photoTaken: Bool = false
    @objc dynamic var sampleTaken: Bool = false
    @objc dynamic var sampleNumber: String = ""
    
    @objc dynamic var negativeObservation: Bool = false
    @objc dynamic var aquaticObservation: Bool = false
    
    var geoJSON: List<GeoJSON> = List<GeoJSON>()
    
    // MARK: Setters
//    func set(value: Any, for key: String) {
//        if self[key] == nil {
//            print("\(key) is nil")
//            return
//        }
//        do {
//            let realm = try Realm()
//            try realm.write {
//                self[key] = value
//            }
//        } catch let error as NSError {
//            print("** REALM ERROR")
//            print(error)
//        }
//    }
    
    func set(shouldSync should: Bool) {
        do {
            let realm = try Realm()
            try realm.write {
                self.sync = should
                self.status = should ? "Pending Sync" : "Draft"
            }
        } catch let error as NSError {
            print("** REALM ERROR")
            print(error)
        }
    }
    
    func add(geoJSON model: GeoJSON) {
        do {
            let realm = try Realm()
            try realm.write {
                self.geoJSON.removeAll()
                self.geoJSON.append(model)
            }
        } catch let error as NSError {
            print("** REALM ERROR")
            print(error)
        }
    }
    
    func addGeometry(with coordinates: [CLLocation], type: DefineGeometryType) {
        let geoJSONModel = GeoJSON()
        geoJSONModel.addGeometry(with: coordinates, type: type)
        do {
            let realm = try Realm()
            try realm.write {
                self.geoJSON.removeAll()
                self.geoJSON.append(geoJSONModel)
            }
        } catch let error as NSError {
            print("** REALM ERROR")
            print(error)
        }
    }
    
    func add(latitude: Double, longitude: Double, area: Double) {
        do {
            let realm = try Realm()
            try realm.write {
                self.latitude = latitude
                self.longitude = longitude
                self.area = area
            }
        } catch let error as NSError {
            print("** REALM ERROR")
            print(error)
        }
    }
    
    func add(firstName: String) {
        do {
            let realm = try Realm()
            try realm.write {
                self.firstName = firstName
            }
        } catch let error as NSError {
            print("** REALM ERROR")
            print(error)
        }
    }
}
