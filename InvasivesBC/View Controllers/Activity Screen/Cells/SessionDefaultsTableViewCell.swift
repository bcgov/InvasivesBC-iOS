//
//  SessionDefaultsTableViewCell.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-07-24.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import UIKit

class SessionDefaultsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var delegate: InputDelegate?
    weak var inputGroup: UIView?
    
    func setup(delegate: InputDelegate) {
        inputGroup?.removeFromSuperview()
        self.delegate = delegate
        let inputGroup = InputGroupView()
        self.inputGroup = inputGroup
        inputGroup.initialize(with: getFields(), delegate: delegate, in: container)
        heightConstraint.constant = InputGroupView.estimateContentHeight(for: getFields())
        style()
    }
    
    func style() {
        container.backgroundColor = .clear
        self.backgroundColor = .clear
        layoutIfNeeded()
    }
    
    func getFields() -> [InputItem] {
        var items: [InputItem] = []
        
        let firstName = TextInput(
            key: "firstName",
            header: "First Name",
            editable: true,
            width: .Half
        )
        items.append(firstName)
        
        let lastName = TextInput(
            key: "lastName",
            header: "Last Name",
            editable: true,
            width: .Half
        )
        items.append(lastName)
        
        let jurisdiction = DropdownInput(
            key: "jurisdiction",
            header: "Jurisdiction",
            editable: true,
            width: .Half
        )
        items.append(jurisdiction)
        
        let agency = DropdownInput(
            key: "agency",
            header: "Agency",
            editable: true,
            width: .Half
        )
        items.append(agency)
        
        
        
        return items
    }
}
