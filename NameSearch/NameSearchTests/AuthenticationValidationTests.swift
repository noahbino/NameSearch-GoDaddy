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

    var validation: AuthenticationValidation!
    
    override func setUp() {
        super.setUp()
        validation = AuthenticationValidation()
    }
    
    override func tearDown() {
        validation = nil
        super.tearDown()
    }
    
    func test_is_valid_username() throws {
        XCTAssertNoThrow(try validation.validateUsername("Noah Iarrobino"))
    }
    
    func test_username_is_nil() throws {
        let expectedError = AuthenticationError.invalid
        var error: AuthenticationError?
        XCTAssertThrowsError(try validation.validateUsername(nil)) { thrownError in
            error = thrownError as? AuthenticationError
        }
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    func test_username_too_short() throws {
        let expectedError = AuthenticationError.userNameTooShort
        var error: AuthenticationError?
        XCTAssertThrowsError(try validation.validateUsername("you")) { thrownError in
            error = thrownError as? AuthenticationError
        }
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    func test_username_too_long() throws {
        let expectedError = AuthenticationError.userNameTooLong
        var error: AuthenticationError?
        let username = "Hello Go Daddy Employees"
        
        XCTAssertTrue(username.count >= 20)
        
        XCTAssertThrowsError(try validation.validateUsername(username)) { thrownError in
            error = thrownError as? AuthenticationError
        }
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    
    
    
    func test_is_valid_password() throws {
        XCTAssertNoThrow(try validation.validatePassword("password"))
    }
    
    func test_password_is_nil() throws {
        let expectedError = AuthenticationError.invalid
        var error: AuthenticationError?
        XCTAssertThrowsError(try validation.validateUsername(nil)) { thrownError in
            error = thrownError as? AuthenticationError
        }
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    func test_password_too_short() throws {
        let expectedError = AuthenticationError.passwordTooShort
        var error: AuthenticationError?
        XCTAssertThrowsError(try validation.validatePassword("you")) { thrownError in
            error = thrownError as? AuthenticationError
        }
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    func test_password_too_long() throws {
        let expectedError = AuthenticationError.passwordTooLong
        var error: AuthenticationError?
        let password = "thisisareallylongpasswordfornogoodreason"
        
        XCTAssertTrue(password.count >= 20)
        
        XCTAssertThrowsError(try validation.validatePassword(password)) { thrownError in
            error = thrownError as? AuthenticationError
        }
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    func test_password_contains_space() throws {
        let expectedError = AuthenticationError.passwordContainsSpace
        var error: AuthenticationError?
        let password = "a password"
        
        XCTAssertThrowsError(try validation.validatePassword(password)) { thrownError in
            error = thrownError as? AuthenticationError
        }
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    

}
