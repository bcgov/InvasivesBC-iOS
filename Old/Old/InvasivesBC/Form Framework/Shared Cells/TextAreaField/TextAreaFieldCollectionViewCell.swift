//
//  TextAreaInputCollectionViewCell.swift
//  ipad
//
//  Created by Amir Shayegh on 2019-11-04.
//  Copyright © 2019 Amir Shayegh. All rights reserved.
//

import UIKit

class TextAreaFieldCollectionViewCell: BaseFieldCell<String, TextAreaFieldViewModel>, UITextViewDelegate {
    
    @IBOutlet weak var fieldHeader: UILabel!
    @IBOutlet weak var textArea: UITextView!
    
    // MARK: Delegate functions
    func textViewDidChange(_ textView: UITextView) {
        self.value = textView.text ?? ""
    }
    
    // MARK: BaseFieldCell
    // Header
    override var header: UILabel? {
        return self.fieldHeader
    }
    
    // Update
    override func update(value: String) {
        self.textArea?.text = value
    }
    
    
    // MARK: Style
    private func style() {
        styleFieldInput(textField: textArea)
        styleFieldHeader(label: fieldHeader)
    }
    
    
}
