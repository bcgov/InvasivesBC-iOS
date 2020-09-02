//
//  LocationAndGeometry.swift
//  InvasivesBC
//
//  Created by Micheal Wells on 2020-09-01.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//


import Foundation
import GRDB

struct Geometry: Codable {
    var type: String
    var coordinates_Poly: Array<Array<Double>>?
    var coordinates_Point: Array<Double>?
}

struct LocationAndGeometry: Codable {
    
    var local_id: Int64?
    var local_activity_id: Int64
    var anchorPointY: Double
    var anchorPointX: Double
    var area: Int64
    var geometry: Geometry
}

// SQL generation
extension LocationAndGeometry: TableRecord {
    /// The table columns
    enum Columns {
        static let local_id = Column(CodingKeys.local_id)
        static let local_activity_id = Column(CodingKeys.local_activity_id)
        static let anchorPointY = Column(CodingKeys.anchorPointY)
        static let anchorPointX = Column(CodingKeys.anchorPointX)
        static let area = Column(CodingKeys.area)
        static let geometry = Column(CodingKeys.geometry)
        
       
    }
}

// Fetching methods
extension LocationAndGeometry: FetchableRecord { }


// Persistence methods
extension LocationAndGeometry: MutablePersistableRecord {
    // Update auto-incremented id upon successful insertion
    mutating func didInsert(with rowID: Int64, for column: String?) {
        local_id = rowID
    }
}
