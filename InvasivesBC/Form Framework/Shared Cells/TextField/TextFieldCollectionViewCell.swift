//
//  TextInputCollectionViewCell.swift
//  ipad
//
//  Created by Amir Shayegh on 2019-11-01.
//  Copyright © 2019 Amir Shayegh. All rights reserved.
//

import UIKit


class TextFieldCollectionViewCell: BaseFieldCell<String, TextFieldViewModel>, UITextFieldDelegate {
    // UI
    @IBOutlet public weak var headerLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    
    // View
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.value = textField.text ?? ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let _ = self.model else {return false}
        if string.isEmpty {
            return true
        }
        // TODO: ADD Field Base Validation Logic
        return true
    }
    
    
    
    // MARK: BaseFieldCell
    override func update(value: String) {
        self.textField?.text = value
    }
    
    override var header: UILabel? {
        return self.headerLabel
    }
    
    // MARK: Style
    private func style() {
        styleInput(field: textField, header: self.headerLabel, editable: model?.editable ?? false)
    }
    
}
