//
//  Validator.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-04-13.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation

typealias ValidationResult = (success: Bool, message: String)

protocol Validator {
    associatedtype T
    func validate(data: T?) -> ValidationResult
}

class BaseValidator<T>: Validator {
    func validate(data: T?) -> ValidationResult {
        return (true, "")
    }
}


class PasswordValidator: BaseValidator<String> {
    let message = "Please enter a valid password"
    override func validate(data: String?) -> ValidationResult {
        guard let value = data else { return  (false, message)}
        return (value.count > 4, message)
    }
}

class EmailValidator: BaseValidator<String> {
    let message = "Invalid email"
    override func validate(data: String?) -> ValidationResult {
        guard let value: String = data else {
            return (false, message)
        }
        return (value.isEmail, message)
    }
}
