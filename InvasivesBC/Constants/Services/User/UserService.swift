//
//  UserService.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-04-20.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserService {
    public static let shared = UserService()
    private init() {}
    
    
    /// Get user information from backend
    /// - Parameter completion: UserModel
    public func getUser(completion: @escaping (UserModel?) -> Void) {
        fetchUserData { (result) in
            guard let userDictionary = result else {return completion(nil)}
            guard let roles = userDictionary["roles"]?.arrayValue else {
                return completion(nil)
            }
            var roleModels: [UserRoleModel] = []
            for role in roles {
                let roleName = role["role"].stringValue
                let roleCodeName = role["code"].stringValue
                let roleCode = role["role_code_id"].intValue
                roleModels.append(UserRoleModel(role: roleName, code: roleCodeName, roleCode: roleCode))
            }
            var lastName: String = ""
            var firstName: String = ""
            var email: String = ""
            var preferredUsername: String = ""
            if let last = userDictionary["lastName"]?.string {
                lastName = last
            }
            if let first = userDictionary["firstName"]?.string {
                firstName = first
            }
            
            if let mail = userDictionary["email"]?.string {
                email = mail
            }
            if let preferredName = userDictionary["preferredUsername"]?.string {
                preferredUsername = preferredName
            }
            return completion(UserModel(firstName: firstName, lastName: lastName, email: email, preferredUsername: preferredUsername, roles: roleModels))
            
        }
    }
    
    /// Fetch json data for current user
    /// - Parameter then: call back with dictionary result
    fileprivate func fetchUserData(then: @escaping([String: JSON]?)->Void) {
        guard let url = URL(string: APIURL.user) else {return then(nil)}
        APIService.get(endpoint: url) { (_response) in
            guard let response = _response as? JSON else {return then(nil)}
            let data = response["data"].dictionaryValue
            return then(data)
        }
    }
}
