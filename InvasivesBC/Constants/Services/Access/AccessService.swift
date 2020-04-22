//
//  AccessService.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-04-20.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation
import Reachability

class AccessService {
    // Superuser
    private static let SuperUserRoleId = 4
    // Data Editor
    private static let DataEditorRoleId = 3
    // System Admin
    private static let AdminRoleID = 1
    // Array of roles that can access this app
    private static let allowedRoleIds = [AdminRoleID, SuperUserRoleId, DataEditorRoleId]
    // Singleton
    public static let shared = AccessService()
    
    // Prop: Status to store access
    public var hasAppAccess: Bool = false
    
    // Network reachability
    private let reachability =  try! Reachability()
    
    
    /// User access is re-verified for each session
    /// when user is online
    private init() {
        beginReachabilityNotification()
        setAccess()
    }
    
    /// Add listener for when recahbility status changes
    private func beginReachabilityNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
    
    
    /// When device is online, check user's access
    /// - Parameter note: notification
    @objc func reachabilityChanged(note: Notification) {
        guard let reachability = note.object as? Reachability else {return}
        switch reachability.connection {
        case .wifi:
            setAccess()
        case .cellular:
            setAccess()
        case .none:
            return
        case .unavailable:
            return
        }
    }
    
    private func setAccess() {
    }
    
    /// Check if a role id can access this app
    /// - Parameter id: Role id
    /// - Returns: Boolean
    private func canAccessWith(role id: Int) -> Bool {
        return AccessService.allowedRoleIds.contains(id)
    }

    
    /// Check if the current user has a role that can access this application.
    /// - Parameter completion: Boolean indicating if access is allowed
    public func hasAccess(completion: @escaping(Bool) -> Void) {
        if reachability.connection == .unavailable {
            return completion(SettingsService.shared.userHasAppAccess())
        }
        UserService.shared.getUser(completion: { (result) in
            guard let user = result else {
                return completion(SettingsService.shared.userHasAppAccess())
            }
            if user.roles.contains(where: { (role) -> Bool in
                return self.canAccessWith(role: role.roleCode)
            }) {
                return completion(true)
            } else {
                return completion(false)
            }
        })
    }
    
    
    /// Send a request for elevated access (Data Editor)
    /// - Parameter completion: Boolean indicating if request was created successfully
    public func sendAccessRequest(completion: ((Bool)->Void)? = nil) {
//        APIService.post(endpoint: <#T##URL#>, params: <#T##[String : Any]#>, completion: <#T##(Any?) -> Void#>)
    }
    
}
