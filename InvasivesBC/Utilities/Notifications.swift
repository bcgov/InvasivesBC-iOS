//
//  Notifications.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-07-28.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let screenOrientationChanged = Notification.Name("screenOrientationChanged")
    static let InputItemValueChanged = Notification.Name("inputItemValueChanged")
    static let ShouldResizeInputGroup = Notification.Name("ShouldResizeInputGroup")
    static let InputFieldShouldUpdate = Notification.Name("InputFieldShouldUpdate")
}

