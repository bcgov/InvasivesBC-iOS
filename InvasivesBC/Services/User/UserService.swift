//
//  UserService.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-04-20.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation

class UserService {
    public static let shared = UserService()
    private init() {}
    
    
    /// Get user information from backend
    /// - Parameter completion: UserModel
    public func getUser(completion: @escaping (UserModel?) -> Void) {
        fetchUserData { (result) in
            guard let userDictionary = result else {return completion(nil)}
            guard let roles = userDictionary["roles"] as? [[String: Any]] else {
                return completion(nil)
            }
            var roleModels: [UserRoleModel] = []
            for role in roles {
                guard
                    let roleName = role["role"] as? String,
                    let roleCodeName = role["code"] as? String,
                    let roleCode = role["role_code_id"] as? Int else {
                        return completion(nil)
                }
                roleModels.append(UserRoleModel(role: roleName, code: roleCodeName, roleCode: roleCode))
            }
            var lastName: String = ""
            var firstName: String = ""
            var email: String = ""
            var preferredUsername: String = ""
            if let last = userDictionary["lastName"] as? String {
                lastName = last
            }
            if let first = userDictionary["firstName"] as? String {
                firstName = first
            }
            
            if let mail = userDictionary["email"] as? String {
                email = mail
            }
            if let preferredName = userDictionary["preferredUsername"] as? String {
                preferredUsername = preferredName
            }
            return completion(UserModel(firstName: firstName, lastName: lastName, email: email, preferredUsername: preferredUsername, roles: roleModels))
            
        }
    }
    
    /// Fetch json data for current user
    /// - Parameter then: call back with dictionary result
    fileprivate func fetchUserData(then: @escaping([String: Any]?)->Void) {
        guard let url = URL(string: APIURL.user) else {return then(nil)}
        APIService.get(endpoint: url) { (_response) in
            guard let response = _response as? [String: Any] else {return then(nil)}
            guard let data = response["data"] as? [String: Any] else {return then(nil)}
            return then(data)
        }
    }
}
