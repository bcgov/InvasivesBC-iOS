//
//  Activity.swift
//  InvasivesBC
//
//  Created by Anissa Agahchen on 2020-08-24.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//
// HOW TO QUERY FROM DEBUGGER po try Row.fetchAll(db, sql: "select * from activity")


import Foundation
import GRDB

struct Activity: Codable {
    
    var local_id: Int64?
    var activity_type: String
    var activity_sub_type: String
    var isFavorite: Bool
    var latitude: Double
    var longitude: Double
    var synched: Bool
    var synch_error: Bool
    var synch_error_string: String
    var first_name: String

}

// SQL generation
extension Activity: TableRecord {
    /// The table columns
    enum Columns {
        static let local_id = Column(CodingKeys.local_id)
        static let activity_type = Column(CodingKeys.activity_type)
        static let activity_sub_type = Column(CodingKeys.activity_sub_type)
        static let isFavorite = Column(CodingKeys.isFavorite)
        static let latitude = Column(CodingKeys.latitude)
        static let longitude = Column(CodingKeys.longitude)
        static let synched = Column(CodingKeys.synched)
        static let synch_error = Column(CodingKeys.synch_error)
        static let synch_error_string = Column(CodingKeys.synch_error_string)
        static let first_name = Column(CodingKeys.first_name)
    }
}

// Fetching methods
extension Activity: FetchableRecord { }

// Persistence methods
extension Activity: MutablePersistableRecord {
    // Update auto-incremented id upon successful insertion
    mutating func didInsert(with rowID: Int64, for column: String?) {
        local_id = rowID
    }
}
