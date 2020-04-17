//
//  TextInputCollectionViewCell.swift
//  ipad
//
//  Created by Amir Shayegh on 2019-11-01.
//  Copyright © 2019 Amir Shayegh. All rights reserved.
//

import UIKit


class TextFieldCollectionViewCell: BaseFieldCell<String, TextFieldViewModel>, UITextFieldDelegate {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
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
    
    override func initialize(model: TextFieldViewModel) {
        super.initialize(model: model)
        self.headerLabel?.text = model.header
    }
    
    // MARK: Style
    private func style() {
        styleInput(field: textField, header: headerLabel, editable: model?.editable ?? false)
    }
    
}
