//
//  UserExtension.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-04-15.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation

// MARK: User
// Adding functionality to  User Model
extension User {
    // Display name
    var displayName: String {
        return "\(firstName) \(lastName)"
    }
}
