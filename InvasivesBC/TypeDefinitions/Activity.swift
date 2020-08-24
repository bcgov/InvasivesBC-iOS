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
    var synched: Bool
    var synch_error: Bool
    var synch_error_string: String

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
        static let synched = Column(CodingKeys.synched)
        static let synch_error = Column(CodingKeys.synch_error)
        static let synch_error_string = Column(CodingKeys.synch_error_string)
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
