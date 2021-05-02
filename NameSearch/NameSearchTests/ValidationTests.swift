//
//  ValidationTests.swift
//  NameSearchTests
//
//  Created by Noah Iarrobino on 5/2/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

@testable import NameSearch
import XCTest


class ValidationTests: XCTestCase {

    var validation: Validation!
    
    override func setUp() {
        super.setUp()
        validation = Validation()
    }
    
    override func tearDown() {
        validation = nil
        super.tearDown()
    }
    
    func test_is_valid_username() throws {
        XCTAssertNoThrow(try validation.validateUsername("Noah Iarrobino"))
    }
    
    func test_username_is_nil() throws {
        let expectedError = ValidationError.invalid
        var error: ValidationError?
        XCTAssertThrowsError(try validation.validateUsername(nil)) { thrownError in
            error = thrownError as? ValidationError
        }
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    func test_username_too_short() throws {
        let expectedError = ValidationError.userNameTooShort
        var error: ValidationError?
        XCTAssertThrowsError(try validation.validateUsername("you")) { thrownError in
            error = thrownError as? ValidationError
        }
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    func test_username_too_long() throws {
        let expectedError = ValidationError.userNameTooLong
        var error: ValidationError?
        let username = "Hello Go Daddy Employees"
        
        XCTAssertTrue(username.count >= 20)
        
        XCTAssertThrowsError(try validation.validateUsername(username)) { thrownError in
            error = thrownError as? ValidationError
        }
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    
    
    
    func test_is_valid_password() throws {
        XCTAssertNoThrow(try validation.validateUsername(""))
    }
    
    func test_password_is_nil() throws {
        let expectedError = ValidationError.invalid
        var error: ValidationError?
        XCTAssertThrowsError(try validation.validateUsername(nil)) { thrownError in
            error = thrownError as? ValidationError
        }
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    func test_password_too_short() throws {
        let expectedError = ValidationError.passwordTooShort
        var error: ValidationError?
        XCTAssertThrowsError(try validation.validatePassword("you")) { thrownError in
            error = thrownError as? ValidationError
        }
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    func test_password_too_long() throws {
        let expectedError = ValidationError.passwordTooLong
        var error: ValidationError?
        let password = "thisisareallylongpasswordfornogoodreason"
        
        XCTAssertTrue(password.count >= 20)
        
        XCTAssertThrowsError(try validation.validatePassword(password)) { thrownError in
            error = thrownError as? ValidationError
        }
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    func test_password_contains_space() throws {
        let expectedError = ValidationError.passwordContainsSpace
        var error: ValidationError?
        let password = "a password"
        
        XCTAssertTrue(password.count >= 20)
        
        XCTAssertThrowsError(try validation.validatePassword(password)) { thrownError in
            error = thrownError as? ValidationError
        }
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    

}
