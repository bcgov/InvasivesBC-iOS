//
//  CustomHeader.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-07-28.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import UIKit

class CustomHeader: UIView {
    @IBOutlet weak var leftField: UILabel!
    @IBOutlet weak var rightField: UILabel!
    
    func setup(left: String, right: String, color: UIColor) {
        leftField.text = left
        rightField.text = right
        rightField.font = UIFont.bold(size: 14)
        leftField.font = UIFont.regular(size: 14)
        self.backgroundColor = color
        rightField.isHidden = right.isEmpty
    }

}
