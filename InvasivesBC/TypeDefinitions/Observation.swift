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
    var negative_observation_ind: Bool
    var aquatic_observation_ind: Bool
    var primary_user_first_name: String
    var primary_user_last_name: String
    var secondary_user_first_name: String
    var secondary_user_last_name: String
    var species: String
    var primary_file_id: String
    var secondary_file_id: String
    var location_comment: String
    var general_observation_comment: String
    var sample_taken_ind: Bool
    var sample_label_number: String
    
    
}

// SQL generation
extension Observation: TableRecord {
    /// The table columns
    enum Columns {
        static let local_id = Column(CodingKeys.local_id)
        static let local_activity_id = Column(CodingKeys.local_activity_id)
        static let negative_observation_ind = Column(CodingKeys.negative_observation_ind)
        static let aquatic_observation_ind = Column(CodingKeys.aquatic_observation_ind)
        static let primary_user_first_name = Column(CodingKeys.primary_user_first_name)
        static let primary_user_last_name = Column(CodingKeys.primary_user_last_name)
        static let secondary_user_first_name = Column(CodingKeys.secondary_user_first_name)
        static let secondary_user_last_name = Column(CodingKeys.secondary_user_last_name)
        static let species = Column(CodingKeys.species)
        static let primary_file_id = Column(CodingKeys.primary_file_id)
        static let secondary_file_id = Column(CodingKeys.secondary_file_id)
        static let location_comment = Column(CodingKeys.location_comment)
        static let general_observation_comment = Column(CodingKeys.general_observation_comment)
        static let sample_taken_ind = Column(CodingKeys.sample_taken_ind)
        static let sample_label_number = Column(CodingKeys.sample_label_number)
        
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
