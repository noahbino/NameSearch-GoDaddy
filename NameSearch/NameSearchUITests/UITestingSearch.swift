//
//  UITestingSearch.swift
//  NameSearchUITests
//
//  Created by Noah Iarrobino on 5/3/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import XCTest

class UITestingSearch: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_valid_domain_search() {
        let validUsername = "Noah"
        let validPassword = "somepassword"
        let validSearch = "apple"
        
        
        let app = XCUIApplication()
        
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.exists)
        usernameTextField.tap()
        usernameTextField.typeText(validUsername)
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText(validPassword)
        
        app.buttons["Log In"].tap()
        sleep(2)
        let searchField = app.textFields["Enter search terms"]
        XCTAssertTrue(searchField.exists)
        searchField.tap()
        searchField.typeText(validSearch)
        
        XCTAssertNoThrow(app.buttons["Search"].tap())
    }
    
    
    func test_invalid_domain_search() {
        let validUsername = "Noah"
        let validPassword = "somepassword"
        let invalidSearch = ""
        
        
        let app = XCUIApplication()
        
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.exists)
        usernameTextField.tap()
        usernameTextField.typeText(validUsername)
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText(validPassword)
        
        app.buttons["Log In"].tap()
        sleep(2)
        let searchField = app.textFields["Enter search terms"]
        XCTAssertTrue(searchField.exists)
        searchField.tap()
        searchField.typeText(invalidSearch)
        
        app.buttons["Search"].tap()
        
        let alert = app.alerts["Search cannot be empty"]
        XCTAssertTrue(alert.exists)
    }

}
