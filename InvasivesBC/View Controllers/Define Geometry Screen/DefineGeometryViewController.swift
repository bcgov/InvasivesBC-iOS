//
//  DefineGeometryViewController.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-08-10.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import UIKit

class DefineGeometryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    func style() {
        self.title = "Define Geometry"
    }

}
