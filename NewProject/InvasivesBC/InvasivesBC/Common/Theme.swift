//
//  Theme.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-07-23.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import Foundation
import UIKit

protocol Theme {}
extension Theme {
    func styleOnMap(button: UIButton) {
        button.setTitleColor(.primary, for: .normal)
        button.backgroundColor = .primaryContrast
        button.tintColor = .primary
        button.layer.cornerRadius = 8
        guard let titleLabel = button.titleLabel else { return }
        titleLabel.font = .semibold(size: 17)
        titleLabel.adjustsFontSizeToFitWidth = true
    }
}

