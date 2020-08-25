//
//  TerrestrialPlant.swift
//  InvasivesBC
//
//  Created by Anissa Agahchen on 2020-08-25.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//


import Foundation
import GRDB

struct TerrestrialPlant: Codable {
    
    var local_id: Int64?
    var local_observation_id: Int64
}

// SQL generation
extension TerrestrialPlant: TableRecord {
    /// The table columns
    enum Columns {
        static let local_id = Column(CodingKeys.local_id)
        static let local_observation_id = Column(CodingKeys.local_observation_id)
        // other new terrestrial plant columns go here
    }
}

// Fetching methods
extension TerrestrialPlant: FetchableRecord { }

// Persistence methods
extension TerrestrialPlant: MutablePersistableRecord {
    // Update auto-incremented id upon successful insertion
    mutating func didInsert(with rowID: Int64, for column: String?) {
        local_id = rowID
    }
}
