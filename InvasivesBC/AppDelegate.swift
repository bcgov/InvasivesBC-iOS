//
//  AppDelegate.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-07-23.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import IQKeyboardManagerSwift
import GRDB

struct Activity: Codable {
    var id: Int64?
    var activity_type: String
    var activity_sub_type: String
    var isFavorite: Bool
    var latitude: Double
    var longitude: Double

}

// SQL generation
extension Activity: TableRecord {
    /// The table columns
    enum Columns {
        static let id = Column(CodingKeys.id)
        static let activityType = Column(CodingKeys.activity_type)
        static let activitySubType = Column(CodingKeys.activity_sub_type)
        static let isFavorite = Column(CodingKeys.isFavorite)
        static let latitude = Column(CodingKeys.latitude)
        static let longitude = Column(CodingKeys.longitude)
    }
}

// Fetching methods
extension Activity: FetchableRecord { }

// Persistence methods
extension Activity: MutablePersistableRecord {
    // Update auto-incremented id upon successful insertion
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var dbQueue: DatabaseQueue
    var dbMigrator: DatabaseMigrator
    
    override init(){
        self.dbQueue = DatabaseQueue()
        self.dbMigrator = DatabaseMigrator()
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        migrateRealm()
        setupDB()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
//        SyncService.shared.endListener()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
//        SyncService.shared.beginListener()
    }
    
    func checkIfFirstLaunch() -> Bool    {
        //retrieve value from local store, if value doesn't exist then false is returned
        let hasAlreadyLaunched: Bool = UserDefaults.standard.bool(forKey: "hasAlreadyLaunched")
        
        	
        //check first launched
        return hasAlreadyLaunched
    }
    
    func setHasAlreadyLaunched()
    {
        UserDefaults.standard.set(true, forKey: "hasAlreadyLaunched")
    }

    
    func setupDB(){
        let databaseURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("db.sqlite")
        self.dbQueue = try! DatabaseQueue(path: databaseURL.path)
        
        
        if(checkIfFirstLaunch())
        {
            // dont run migrations
        }
        else
        {
            // run migrations here
            var dbMigrationRegistrator: DBMigrationRegistrator = DBMigrationRegistrator(dbMigration: self.dbMigrator)
            dbMigrationRegistrator.registerMigrations()
            
            setHasAlreadyLaunched()
        }
        
        
        

        
        try! dbQueue.write { db in

            try db.execute(sql: """
                drop table Activity;
                """)

            try db.create(table: "Activity") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("activity_type", .text).notNull()
                t.column("activity_sub_type", .text).notNull()
                t.column("isFavorite", .boolean).notNull().defaults(to: false)
                t.column("longitude", .double).notNull()
                t.column("latitude", .double).notNull()
            }
        }
        
        let _: String = "banana"
        try! dbQueue.read { db in
        // Fetch database rows
            let rows = try Row.fetchCursor(db, sql: "SELECT * FROM Activity")
        }
        
        //test insert
        //let activity = Activity(activityType: "Observation", activitySubType: "Invasive Terrestrial Plant Observatin")
        //try activity.insert(db)

        
    }
    
    /// https://realm.io/docs/swift/latest/#migrations
    func migrateRealm() {
        guard let generatedSchemaVersion = generateAppIntegerVersion() else {
            return
        }
        
        let config = Realm.Configuration(schemaVersion: UInt64(generatedSchemaVersion),
                                         migrationBlock: { migration, oldSchemaVersion in
                                            // check oldSchemaVersion here, if we're newer call
                                            // a method(s) specifically designed to migrate to
                                            // the desired schema. ie `self.migrateSchemaV0toV1(migration)`
                                            if (oldSchemaVersion < 4) {
                                                // Nothing to do. Realm will automatically remove and add fields
                                            }
        },
                                         shouldCompactOnLaunch: { totalBytes, usedBytes in
                                            // totalBytes refers to the size of the file on disk in bytes (data + free space)
                                            // usedBytes refers to the number of bytes used by data in the file
                                            
                                            // Compact if the file is over 100MB in size and less than 50% 'used'
                                            let oneHundredMB = 100 * 1024 * 1024
                                            return (totalBytes > oneHundredMB) && (Double(usedBytes) / Double(totalBytes)) < 0.5
        })
        
        Realm.Configuration.defaultConfiguration = config
    }
    
    /// App ingeget version is same as local db version in appdelegate's migrateRealm()
    /// (Version * 10) + build
    ///
    /// - Returns: Integer representing application and local database version
    func generateAppIntegerVersion() -> Int? {
        // We get version and build numbers of app
        guard let infoDict = Bundle.main.infoDictionary, let version = infoDict["CFBundleShortVersionString"] as? String, let build = infoDict["CFBundleVersion"] as? String  else {
            return nil
        }
        
        // comvert tp integer
        let versionAsString = "\(version)".removeWhitespaces().replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range:nil)
        guard let intVersion = Int(versionAsString), let intBuild = Int(build.removeWhitespaces())  else {
            return nil
        }
        
        return intVersion * 10 + intBuild
    }


}

