//
//  StatusViewController.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-08-10.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import UIKit

class StatusViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var divider: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func style() {
        view.backgroundColor = UIColor(red: 242, green: 242, blue: 242, alpha: 1)
        styleNavigation(title: titleLabel, divider: divider, buttons: [closeButton])
    }
    
}
