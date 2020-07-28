//
//  UserModel.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-04-21.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation

// Struct used to handle API responce when fetching user data
struct UserModel {
    var firstName: String
    var lastName: String
    var email: String
    var preferredUsername: String
    var roles: [UserRoleModel]
}
