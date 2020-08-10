//
//  SyncService.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-07-28.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import Foundation
import Realm
import Reachability
import RealmSwift

class SyncService {
    internal static let shared = SyncService()
    
    private var isEnabled: Bool = true
    private var isAutoSyncEnabled: Bool = true
    private var realmNotificationToken: NotificationToken?
    private var isSynchronizing: Bool = false
    private var manualSyncRequiredShown = false
    
    // private let syncView: SyncView = UIView.fromNib()
    
    // MARK: Criteria
    
    /// Used for checking critieria for initial sync
    /// - Returns: Boolean indidication if initial sync should be performed
    public func shouldPerformInitialSync() -> Bool {
        // Is Online
        do {
            let reachability = try Reachability()
            if reachability.connection == .unavailable {
                return false
            }
        } catch let error as NSError {
            print("** Reachability ERROR")
            print(error)
            return false
        }
        // TODO: - Define initial sync criteria
        var should: Bool = false
        // 1) If code tables are empty, initial sync is needed
        if CodeTableService.shared.getAll().isEmpty {
            should = true
        }
        // 2) // Other criteria
        
        
        // Finally return
        return should
    }
    
    // MARK: Initial Sync
    
    /// Execute initial sync
    /// - Parameter completion: Boolean indidication if initial sync was successful
    public func performInitialSync(completion: @escaping(_ success: Bool) -> Void) {
        // TODO: -
        var hadErrors: Bool = false
        print("Performing initial sync...")
        DispatchQueue.global(qos: .background).async {

            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            print("Downloading code tables")
            CodeTableService.shared.download { (success) in
                print("Downloaded code tables")
                if !success {
                    hadErrors = true
                }
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                print("Initial Sync Executed.")
                return completion(!hadErrors)
            }
        }
    }
}
