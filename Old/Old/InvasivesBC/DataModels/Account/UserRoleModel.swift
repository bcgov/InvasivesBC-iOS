//
//  UserRoleModel.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-04-21.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation

struct UserRoleModel {
    var role: String
    var code: String
    var roleCode: Int
    
    init(role: String, code: String, roleCode: Int) {
        self.role = role
        self.code = code
        self.roleCode = roleCode
    }
}
