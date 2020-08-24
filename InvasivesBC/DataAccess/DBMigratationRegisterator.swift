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
        migrator.registerMigration("createLibrary") { db in
             try Row.fetchAll(db, "SELECT * FROM persons")
        }
        
        
        
        
        
    }
    
}
