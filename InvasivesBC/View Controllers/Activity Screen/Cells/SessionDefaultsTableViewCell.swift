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
    
    deinit {
        removeListeners()
    }
    
    func setup(delegate: InputDelegate) {
        addListeners()
        self.delegate = delegate
        let inputGroup = InputGroupView()
        inputGroup.initialize(with: getFields(), delegate: delegate, in: container)
        heightConstraint.constant = InputGroupView.estimateContentHeight(for: getFields())
        style()
    }
    
    private func removeListeners() {
        NotificationCenter.default.removeObserver(self, name: .InputItemValueChanged, object: nil)
    }
    
    private func addListeners() {
        NotificationCenter.default.removeObserver(self, name: .InputItemValueChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.inputItemValueChanged(notification:)), name: .InputItemValueChanged, object: nil)
    }
    
    @objc func inputItemValueChanged(notification: Notification) {
        guard let item: InputItem = notification.object as? InputItem else {return}
        print(item.value.get(type: item.type) as Any)
    }
    
    
    func style() {
        container.backgroundColor = .clear
        self.backgroundColor = .clear
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
