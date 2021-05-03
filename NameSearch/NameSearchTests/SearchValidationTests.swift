//
//  SearchValidationTests.swift
//  NameSearchTests
//
//  Created by Noah Iarrobino on 5/2/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

@testable import NameSearch
import XCTest

class SearchValidationTests: XCTestCase {

    var validation: SearchValidation!

    override func setUp() {
        super.setUp()
        validation = SearchValidation()
    }
    
    override func tearDown() {
        validation = nil
        super.tearDown()
    }
    
    func test_is_valid_search() throws {
        let search = "apple"
        XCTAssertNoThrow(try validation.validateSearchRequest(search: search))
    }
    
    func test_is_empty_search() throws {
        let expectedError = SearchError.emptySearch
        var error: SearchError?
        let search = ""
        
        XCTAssertThrowsError(try validation.validateSearchRequest(search: search)) { thrownError in
            error = thrownError as? SearchError
        }
        
        XCTAssertEqual(expectedError, error)
        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }
    
    
}
