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
                t.column("isFavorite", .boolean).notNull().defaults(to: false)
                t.column("longitude", .double).notNull()
                t.column("latitude", .double).notNull()
                t.column("synched", .boolean).notNull().defaults(to: false)
                t.column("synch_error", .boolean).notNull().defaults(to: false)
                t.column("synch_error_string", .text).notNull()
                t.column("first_name", .text).notNull()
            }
        }
            
            
            
        migrator.registerMigration("v2") { db in
                try db.create(table: "Observation") { t in
                    t.autoIncrementedPrimaryKey("local_id")
                    t.column("local_activity_id", .integer).notNull()
                    t.column("negative_observation_ind", .boolean)
                    t.column("aquatic_observation_ind", .boolean)
                    t.column("primary_user_first_name", .text)
                    t.column("primary_user_last_name", .text)
                    t.column("secondary_user_first_name", .text)
                    t.column("secondary_user_last_name", .text)
                    t.column("species", .text)
                    t.column("primary_file_id", .text)
                    
                    
                    t.column("secondary_file_id", .text)
                    t.column("location_comment", .text)
                    t.column("general_observation_comment", .text)
                    t.column("sample_taken_ind", .text)
                    t.column("sample_label_number", .text)
                  
                }
            
            try db.create(table: "TerrestrialPlant") { t in
                t.autoIncrementedPrimaryKey("local_id")
                 t.column("local_observation_id", .integer).notNull()
              
            }
            
        }
        
        
        
    }
    
}
