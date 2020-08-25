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
                  
                }
            
            try db.create(table: "TerrestrialPlant") { t in
                t.autoIncrementedPrimaryKey("local_id")
                 t.column("local_observation_id", .integer).notNull()
              
            }
            
            
            
            
        }
        
        
        
        
        
    }
    
}
