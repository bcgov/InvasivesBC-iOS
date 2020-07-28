//
//  DateInputCollectionViewCell.swift
//  ipad
//
//  Created by Amir Shayegh on 2019-11-01.
//  Copyright © 2019 Amir Shayegh. All rights reserved.
//

import UIKit

class DateFieldCollectionViewCell: BaseFieldCell<Date?, DateFieldViewModel>, UITextFieldDelegate {
    
    // UI
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    // UIView
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false;
    }
    
    
    // MARK: Actions
    @objc func onClick(sender : UITapGestureRecognizer) {
        // Present DatePicker
        guard let model = self.model, model.editable else { return }
        presenter?.showDatePicker(on: textField, initialDate: model.value, maxDate: nil, minDate: nil, { [weak self] selectedDate in
            // Handling new selected date
            self?.value = selectedDate
            // Updating text field value
            self?.textField?.text = selectedDate.string()
        })
    }
    
    // MARK: BaseFieldCell
    override func update(value: Date?) {
        self.textField?.text = value?.string()
    }
    
    override var header: UILabel? {
        return self.headerLabel
    }
    
    // MARK: Style
    private func style() {
        styleInput(field: textField, header: headerLabel, editable: model?.editable ?? false)
    }
    
}
