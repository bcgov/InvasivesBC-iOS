//
//  FormSectionHeader.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-08-11.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import UIKit

class FormSectionHeader: UIView {
    
    var completion: (()->Void)?
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    @IBAction func buttonAction(_ sender: Any) {
        guard let callback = completion else {return}
        callback()
    }
    func setup(text: String, isOpen: Bool, onToggle: @escaping()->Void) {
        self.completion = onToggle
        label.text = text
        if isOpen {
            button.setImage(UIImage(systemName: "arrow.down.right.and.arrow.up.left"), for: .normal)
        } else {
            button.setImage(UIImage(systemName: "arrow.up.left.and.arrow.down.right"), for: .normal)
        }
        style()
    }
    
    func style() {
        label.font = UIFont.semibold(size: 25)
    }
}
