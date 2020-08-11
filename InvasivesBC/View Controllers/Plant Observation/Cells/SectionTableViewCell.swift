//
//  SectionTableViewCell.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-08-11.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import UIKit

class SectionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var container: UIView!
    
    weak var inputGroup: InputGroupView?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(fields: [InputItem], delegagte: InputDelegate) {
        let group = InputGroupView()
        if let current = inputGroup {
            current.removeFromSuperview()
             inputGroup = nil
        }
        self.inputGroup = group
        self.inputGroup?.initialize(with: fields, delegate: delegagte, in: container)
        containerHeightConstraint.constant = InputGroupView.estimateContentHeight(for: fields)
        style()
    }
    
    func style() {
        container.backgroundColor = .clear
    }
}
