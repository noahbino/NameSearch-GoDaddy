//
//  UITestingLogin.swift
//  NameSearchUITests
//
//  Created by Noah Iarrobino on 5/3/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import XCTest

class UITestingLogin: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func test_valid_login(){
        
        let validUsername = "Noah"
        let validPassword = "somepassword"
        
        let app = XCUIApplication()
        
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.exists)
        usernameTextField.tap()
        usernameTextField.typeText(validUsername)
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText(validPassword)
        
        
        XCTAssertNoThrow(app.buttons["Log In"].tap())
    }
    
    func test_invalid_login_username_too_short(){
        let invalidUsername = "No"
        let validPassword = "somepassword"
        
        let app = XCUIApplication()
        
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.exists)
        usernameTextField.tap()
        usernameTextField.typeText(invalidUsername)
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText(validPassword)
        
        app.buttons["Log In"].tap()
        
        let alert = app.alerts["Username should be more than 3 characters"]
        XCTAssertTrue(alert.exists)
        
    }
    
    

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
 

}
