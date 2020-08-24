//
//  Activity.swift
//  InvasivesBC
//
//  Created by Anissa Agahchen on 2020-08-24.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import Foundation
import GRDB

struct Activity: Codable {
    var id: Int64?
    var activity_type: String
    var activity_sub_type: String
    var isFavorite: Bool
    var latitude: Double
    var longitude: Double

}

// SQL generation
extension Activity: TableRecord {
    /// The table columns
    enum Columns {
        static let id = Column(CodingKeys.id)
        static let activityType = Column(CodingKeys.activity_type)
        static let activitySubType = Column(CodingKeys.activity_sub_type)
        static let isFavorite = Column(CodingKeys.isFavorite)
        static let latitude = Column(CodingKeys.latitude)
        static let longitude = Column(CodingKeys.longitude)
    }
}

// Fetching methods
extension Activity: FetchableRecord { }

// Persistence methods
extension Activity: MutablePersistableRecord {
    // Update auto-incremented id upon successful insertion
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}
