//
//  ValidationService.swift
//  NameSearch
//
//  Created by Noah Iarrobino on 4/30/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

struct Validation {
    func validateUsername(_ username: String?) throws -> String {
        guard let username = username else {throw ValidationError.invalid}
        guard username.count > 3 else {throw ValidationError.userNameTooShort}
        guard username.count < 20 else {throw ValidationError.userNameTooLong}
        return username
    }
    
    func validatePassword(_ password: String?) throws -> String {
        guard let password = password else {throw ValidationError.invalid}
        guard password.count > 6 else {throw ValidationError.passwordTooShort}
        guard password.count < 20 else {throw ValidationError.passwordTooLong}
        if password.contains(" ") {
            throw ValidationError.passwordContainsSpace
        }
        return password
    }
}

    enum ValidationError: LocalizedError {
        case invalid
        case userNameTooShort
        case passwordTooShort
        case passwordTooLong
        case userNameTooLong
        case passwordContainsSpace
        
        var errorDescription: String? {
            switch self {
            case .userNameTooShort:
                return "Username should be more than 3 characters"
            case .passwordTooShort:
                return "Password should be more than 6 characters"
            case .passwordTooLong:
                return "Password should be less than 20 characters"
            case .userNameTooLong:
                return "Username should be less than 20 characters"
            case .passwordContainsSpace:
                return "Password cannot contain spaces"
            case .invalid:
                return "Invalid value"
            }
        }
    }
