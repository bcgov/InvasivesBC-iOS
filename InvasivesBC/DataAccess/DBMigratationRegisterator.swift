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
    
    
    func registerMigrations()
    {
        migrator.registerMigration("v1") { db in
            try db.create(table: "Activity") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("activity_type", .text).notNull()
                t.column("activity_sub_type", .text).notNull()
                t.column("isFavorite", .boolean).notNull().defaults(to: false)
                t.column("longitude", .double).notNull()
                t.column("latitude", .double).notNull()
            }
        }
        
        
        
        
        
    }
    
}
