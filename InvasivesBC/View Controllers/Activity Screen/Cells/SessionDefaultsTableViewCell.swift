//
//  SessionDefaultsTableViewCell.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-07-24.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import UIKit

class SessionDefaultsTableViewCell: UITableViewCell {
    
    
    func setup() {
        let inputGroup = InputGroupView()
//        inputGroup.initialize(with: getFields(), delegate: <#T##InputDelegate#>, in: <#T##UIView#>)
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
