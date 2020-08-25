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

struct Observation: Codable {
    
    var local_id: Int64?
    var local_activity_id: Int64
}

// SQL generation
extension Observation: TableRecord {
    /// The table columns
    enum Columns {
        static let local_id = Column(CodingKeys.local_id)
        static let local_activity_id = Column(CodingKeys.local_activity_id)
        // other new observation columns go here
    }
}

// Fetching methods
extension Observation: FetchableRecord { }

// Persistence methods
extension Observation: MutablePersistableRecord {
    // Update auto-incremented id upon successful insertion
    mutating func didInsert(with rowID: Int64, for column: String?) {
        local_id = rowID
    }
}
