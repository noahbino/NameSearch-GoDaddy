//
//  ValidationService.swift
//  NameSearch
//
//  Created by Noah Iarrobino on 4/30/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

struct AuthenticationValidation {
    func validateUsername(_ username: String?) throws -> String {
        guard let username = username else {throw AuthenticationError.invalid}
        guard username.count > 3 else {throw AuthenticationError.userNameTooShort}
        guard username.count < 20 else {throw AuthenticationError.userNameTooLong}
        return username
    }
    
    func validatePassword(_ password: String?) throws -> String {
        guard let password = password else {throw AuthenticationError.invalid}
        guard password.count > 6 else {throw AuthenticationError.passwordTooShort}
        guard password.count < 20 else {throw AuthenticationError.passwordTooLong}
        if password.contains(" ") {
            throw AuthenticationError.passwordContainsSpace
        }
        return password
    }
}

    enum AuthenticationError: LocalizedError {
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
