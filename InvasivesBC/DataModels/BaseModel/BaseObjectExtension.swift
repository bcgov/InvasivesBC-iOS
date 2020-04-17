//
//  BaseObjectExtension.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-04-15.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation

// MARK: BaseObject
// Extending and adding common functionality to Base Object
extension BaseObject {
    
    // MARK: JSON Dictionary
    // Return Json Dict Object of Model
    // TDOD: Find a generic way to create common functionality
    var toDict: [String: Any?] {
        return [:]
    }
    
    // Populating data from Incoming Dict
    // TDOD: Find a generic way to create common functionality
    func from(dict: [String: Any?]) {
        
    }
}
