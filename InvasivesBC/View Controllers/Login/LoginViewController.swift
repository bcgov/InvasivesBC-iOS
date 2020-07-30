//
//  LoginViewController.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-07-28.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var container: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
    }
    
    @IBAction func loginWithBCeIDAction(_ sender: Any) {
        AuthenticationService.refreshEnviormentConstants(withIdpHint: "bceid")
        SettingsService.shared.setAuth(type: .BCeID)
        AuthenticationService.authenticate { (success) in
            if (!success) {
                AuthenticationService.logout()
                return
            }
            self.afterLogin()
        }
    }
    
    @IBAction func loginWithIdirAction(_ sender: Any) {
        AuthenticationService.refreshEnviormentConstants(withIdpHint: "idir")
        SettingsService.shared.setAuth(type: .Idir)
        AuthenticationService.authenticate { (success) in
            if (!success) {
                AuthenticationService.logout()
                return
            }
            self.afterLogin()
        }
    }
    
    func afterLogin() {
        SettingsService.shared.setUserAuthId()
        self.dismiss(animated: true, completion: nil)
    }
    
    func style() {
        container.backgroundColor = .white
        container.layer.cornerRadius = 8
        container.clipsToBounds = true
        view.backgroundColor = .gray
    }
}
