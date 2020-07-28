//
//  Validator.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-04-13.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation

// Validation Result Tuple
typealias ValidationResult = (success: Bool, message: String)

// Validator
// Validate any data with type T
protocol Validator {
    associatedtype T
    func validate(data: T?) -> ValidationResult
}

// Generic Base Validator
class BaseValidator<T>: Validator {
    func validate(data: T?) -> ValidationResult {
        return (true, "")
    }
}

// PasswordValidator: Validate password string
class PasswordValidator: BaseValidator<String> {
    let message = "Please enter a valid password"
    override func validate(data: String?) -> ValidationResult {
        guard let value = data else { return  (false, message)}
        return (value.count > 4, message)
    }
}

// EmailValidator: Validate email string
class EmailValidator: BaseValidator<String> {
    let message = "Invalid email"
    override func validate(data: String?) -> ValidationResult {
        guard let value: String = data else {
            return (false, message)
        }
        return (value.isEmail, message)
    }
}
