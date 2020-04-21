//
//  SyncService.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-04-21.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
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
        return true
    }
    
    // MARK: Initial Sync
    
    /// Execute initial sync
    /// - Parameter completion: Boolean indidication if initial sync was successful
    public func performInitialSync(completion: @escaping(_ success: Bool) -> Void) {
        // TODO: -
        return completion(true)
    }
}
