//
//  PaymentValidationTests.swift
//  NameSearchTests
//
//  Created by Noah Iarrobino on 5/2/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

@testable import NameSearch
import XCTest

class PaymentValidationTests: XCTestCase {

    var validation: PaymentValidation!
    
    override func setUp() {
        super.setUp()
        validation = PaymentValidation()
    }
    
    override func tearDown() {
        validation = nil
        super.tearDown()
    }
    
    func test_is_valid_payment_request() throws {
        let dict: [String: String] = [
            "auth": "e67fddf4-11f0-4959-8440-1175735408dd",
            "token": "e20042be-a84f-43ba-a2d8-068e8deff5a4"
        ]
        
        var request = URLRequest(url: URL(string: "https://gd.proxied.io/payments/process")!)
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)
        
        XCTAssertNoThrow(try validation.validatePurchaseRequest(request: request))
    }
    
    func test_is_not_post_request() throws {
        let expectedError = PurchaseError.invalidMethod
        var error: PurchaseError?
        
        let dict: [String: String] = [
            "auth": "e67fddf4-11f0-4959-8440-1175735408dd",
            "token": "e20042be-a84f-43ba-a2d8-068e8deff5a4"
        ]
        
        var request = URLRequest(url: URL(string: "https://gd.proxied.io/payments/process")!)
        request.httpMethod = "GET"
        request.httpBody = try! JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)
        
        
        XCTAssertThrowsError(try validation.validatePurchaseRequest(request: request)) { thrownError in
            error = thrownError as? PurchaseError
        }
        
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    func test_is_not_valid_auth_token() throws {
        let expectedError = PurchaseError.invalidAuthToken
        var error: PurchaseError?
        
        let dict: [String: String ] = [
            "auth": "",
            "token": "e20042be-a84f-43ba-a2d8-068e8deff5a4"
        ]
        
        var request = URLRequest(url: URL(string: "https://gd.proxied.io/payments/process")!)
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)
        
        XCTAssertTrue(request.httpMethod == "POST")
        
        XCTAssertThrowsError(try validation.validatePurchaseRequest(request: request)) { thrownError in
            error = thrownError as? PurchaseError
        }
        
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    
    func test_is_not_valid_payment_token() throws {
        let expectedError = PurchaseError.invalidPaymentToken
        var error: PurchaseError?
        
        let dict: [String: String ] = [
            "auth": "e67fddf4-11f0-4959-8440-1175735408dd",
            "token": ""
        ]
        
        var request = URLRequest(url: URL(string: "https://gd.proxied.io/payments/process")!)
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)
        
        
        XCTAssertTrue(request.httpMethod == "POST")
        
        XCTAssertThrowsError(try validation.validatePurchaseRequest(request: request)) { thrownError in
            error = thrownError as? PurchaseError
        }
        
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    

}
