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
    var local_activity_id: Int64
    var species: String
    var distribution: String
    var density: String
    var soil_texture: String
    var slope: String
    var aspect: String
    var flowering: String
    var specific_use: String
    var proposed_action: String
    var seed_stage: String
    var plant_health: String
    var plant_life_stage: String
    var early_detection: Bool
    var research: Bool
    var well_on_site_ind: Bool
    var special_care_ind: Bool
    var biological_care_ind: Bool
    var legacy_site_ind: Bool
    var range_unit: String

}

// SQL generation
extension TerrestrialPlant: TableRecord {
    /// The table columns
    enum Columns {
        static let local_id = Column(CodingKeys.local_id)
        static let local_activity_id = Column(CodingKeys.local_activity_id)
        static let species = Column(CodingKeys.species)
        static let distribution = Column(CodingKeys.distribution)
        static let density = Column(CodingKeys.density)
        static let soil_texture = Column(CodingKeys.soil_texture)
        static let slope = Column(CodingKeys.slope)
        static let aspect = Column(CodingKeys.aspect)
        static let flowering = Column(CodingKeys.flowering)
        static let specific_use = Column(CodingKeys.specific_use)
        static let proposed_action = Column(CodingKeys.proposed_action)
        static let seed_stage = Column(CodingKeys.seed_stage)
        static let plant_health = Column(CodingKeys.plant_health)
        static let plant_life_stage = Column(CodingKeys.plant_life_stage)
        static let early_detection = Column(CodingKeys.early_detection)
        static let research = Column(CodingKeys.research)
        static let well_on_site_ind = Column(CodingKeys.well_on_site_ind)
        static let special_care_ind = Column(CodingKeys.special_care_ind)
        static let biological_care_ind = Column(CodingKeys.biological_care_ind)
        static let legacy_site_ind = Column(CodingKeys.legacy_site_ind)
        static let range_unit = Column(CodingKeys.range_unit)

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
