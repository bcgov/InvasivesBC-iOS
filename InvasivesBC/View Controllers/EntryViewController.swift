//
//  EntryViewController.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-07-28.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import UIKit
import Reachability

class EntryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        AuthenticationService.logout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentNext()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
    }

    /// Show Login - Do not use directly.
    /// Should be only used by showHomePage() after verification
    internal func segueToLoginPage() {
        performSegue(withIdentifier: "performLogin", sender: nil)
    }
    
    internal func segueToApp() {
        performSegue(withIdentifier: "enterApp", sender: nil)
    }
    
    /// Determines  if login or home page should be presented
    internal func presentNext() {
        if (!isAuthenticated()) {
            segueToLoginPage()
            return
        }
        
        AccessService.shared.hasAccess { [weak self] (hasAccess) in
            guard let strongSelf = self else {return}
            if hasAccess {
                strongSelf.showHomePage()
            } else {
                strongSelf.showPendingAccess()
            }
        }
    }
    
    /// Show Access Pending view
    private func showPendingAccess() {
        let awaitingAccessResponseView: AwaitingAccessResponse = UIView.fromNib()
        awaitingAccessResponseView.show(in: self.view, onRefresh: { [weak self] in
            guard let _self = self else {return}
            awaitingAccessResponseView.removeFromSuperview()
            _self.presentNext()
        })
    }
    
    /// Show Home page & perform initial sync if necessary
    /// If initial sync is necessary and is failed,
    /// onFailedLogin() will be called
    private func showHomePage() {
        if !SyncService.shared.shouldPerformInitialSync() {
            segueToApp()
            return
        }
        SyncService.shared.performInitialSync { [weak self] (success) in
            guard let _self = self else {return}
            if !success {
                _self.onFailedLogin()
            } else {
                _self.segueToApp()
            }
        }
    }
    
    /// Handle Authentication failure
    private func onFailedLogin() {
        showAlert(with: "Can't continue", message: "On your first login, we need to download some information.\nMake sure you have a stable connection")
        AuthenticationService.logout()
    }
    
    /// Check if user is Authenticated
    ///  A user is NOT authenticated if
    ///  1- has never loggged in  before
    ///  2- We have not store the user's Authentication id in app settings
    ///  Otherwise a user is Authenticated if
    ///  1- Device is offline (3.1)
    ///   OR
    ///  2- User's token is not expeired (3.2)
    /// - Returns: Boolean indicating if user is Authenticated
    internal func isAuthenticated() -> Bool {
        // 1) User has logged in
        if !AuthenticationService.isLoggedIn() {
            return false
        }
        
        // 2) We have stored user's Id
        guard let storedUserId = SettingsService.shared.getUserAuthId() else {
            AuthenticationService.logout()
            return false
        }
        
        if storedUserId.isEmpty {
            AuthenticationService.logout()
            return false
        }
        
        // 3) Connection
        do {
            let reacahbility = try Reachability()
            
            if (reacahbility.connection == .unavailable) {
                // 3.1) User is offline
                return true
            } else {
                // 3.2) User is Online and User's token is not expired
                return AuthenticationService.isAuthenticated()
            }
        } catch  let error as NSError {
            print("** Reachability ERROR")
            print(error)
            return false
        }
    }
}
