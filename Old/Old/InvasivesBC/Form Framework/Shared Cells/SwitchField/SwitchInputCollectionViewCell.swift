//
//  SwitchInputCollectionViewCell.swift
//  ipad
//
//  Created by Amir Shayegh on 2019-11-01.
//  Copyright © 2019 Amir Shayegh. All rights reserved.
//

import UIKit

class SwitchFieldCollectionViewCell: BaseFieldCell<Bool, SwitchFieldViewModel> {

    // UI
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var switchView: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }
    
    // MARK: Actions
    @IBAction func switchChanged(_ sender: UISwitch) {
        self.value = sender.isOn
    }
    
    
    // MARK: BaseFieldCell
    // Header
    override var header: UILabel? {
        return self.headerLabel
    }
    
    // Update Value
    override func update(value: Bool) {
        self.switchView?.isOn = value
    }
    
    
    // MARK: Style
    private func style() {
        styleFieldHeader(label: headerLabel)
    }
}
