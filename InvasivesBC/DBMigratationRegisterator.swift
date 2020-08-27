//
//  DBMigratationRegisterator.swift
//  InvasivesBC
//
//  Created by Anissa Agahchen on 2020-08-24.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import Foundation
import GRDB



class DBMigrationRegistrator
{
    var migrator: DatabaseMigrator
    
    init(dbMigration: DatabaseMigrator)
    {
        self.migrator = dbMigration
    }
    
    // TODO: maybe move these into individual files when this gets big
    func registerMigrations()
    {
        // check out InvasivesBC\DataAccess\TypeDefinitions\Activity.swift
        // these can be converted to pure SQL and kept as a string in another file also
        migrator.registerMigration("v1") { db in
            try db.create(table: "Activity") { t in
                t.autoIncrementedPrimaryKey("local_id")
                t.column("activity_type", .text).notNull()
                t.column("activity_sub_type", .text).notNull()
                t.column("date", .date).notNull()
                t.column("deviceRequestUID", .text).notNull()
                t.column("synched", .boolean).notNull().defaults(to: false)
                t.column("synch_error", .boolean).notNull().defaults(to: false)
                t.column("synch_error_string", .text).notNull()
            }
        }
            
            
            
        migrator.registerMigration("v2") { db in
                try db.create(table: "Observation") { t in
                    t.autoIncrementedPrimaryKey("local_id")
                    t.column("local_activity_id", .integer).notNull()
                    t.column("negative_observation_ind", .boolean).defaults(to: false)
                    t.column("aquatic_observation_ind", .boolean).defaults(to: false)
                    t.column("primary_user_first_name", .text).check { length($0) <= 50}
                    t.column("primary_user_last_name", .text).check { length($0) <= 50}
                    t.column("secondary_user_first_name", .text).check { length($0) <= 50}
                    t.column("secondary_user_last_name", .text).check { length($0) <= 50}
                    t.column("species", .text).notNull().defaults(to: false)
                    t.column("primary_file_id", .text).check{ length($0) <= 50}
                    t.column("secondary_file_id", .text).check{ length($0) <= 50}
                    t.column("location_comment", .text).check{ length($0) <= 300}
                    t.column("general_observation_comment", .text).check{ length($0) <= 300}
                    t.column("sample_taken_ind", .boolean).defaults(to: false)
                    t.column("sample_label_number", .text).check{ length($0) <= 50}
                }
            
            try db.create(table: "TerrestrialPlant") { t in
                t.autoIncrementedPrimaryKey("local_id")
                t.column("local_observation_id", .integer).notNull()
                t.column("species", .text)
                t.column("distribution", .text)
                t.column("density", .text)
                t.column("soil_texture", .text)
                t.column("slope", .text)
                t.column("aspect", .text)
                t.column("flowering", .boolean)
                t.column("specific_use", .text)
                t.column("proposed_action", .text)
                t.column("seed_stage", .text)
                t.column("plant_health", .text)
                t.column("plant_life_stage", .text)
                t.column("early_detection", .boolean)
                t.column("research", .boolean)
                t.column("well_on_site_ind", .boolean)
                t.column("biological_care_ind", .boolean)
                t.column("special_care_ind", .boolean)
                t.column("legacy_site_ind", .boolean)
                t.column("range_unit", .text).check{ length($0) <= 20}
                
              
            }
            
        }
        
        
        
    }
    
}
