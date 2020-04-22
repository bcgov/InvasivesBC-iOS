//
//  ViewController.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-04-03.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import UIKit
import Reachability

class ViewController: UIViewController, Theme {
    
    // MARK: ViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        self.view.isUserInteractionEnabled = false
        if (!isAuthenticated()) {
            segueToLoginPage()
            self.view.isUserInteractionEnabled = true
            return
        }
        self.view.isUserInteractionEnabled = true
    }
   
}
