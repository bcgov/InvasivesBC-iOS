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
    var activityType: String
    var activitySubType: String
    var deviceRequestUID: String
    var date: Date
    var synched: Bool
    var synch_error: Bool
    var synch_error_string: String


}

// SQL generation
extension Activity: TableRecord {
    /// The table columns
    enum Columns {
        static let local_id = Column(CodingKeys.local_id)
        static let activityType = Column(CodingKeys.activityType)
        static let activitySubType = Column(CodingKeys.activitySubType)
        static let deviceRequestUID = Column(CodingKeys.deviceRequestUID)
        static let date = Column(CodingKeys.date)
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
        local_id = rowID
    }
}
