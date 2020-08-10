//
//  InvasivesBCUITests.swift
//  InvasivesBCUITests
//
//  Created by Amir Shayegh on 2020-07-23.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import XCTest

class InvasivesBCUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        
    }
    
    
    /// Testing Activity Screen
    /// NOTE: We are not testing the login here! this test assumes user is authenticated
    /// - Throws:
    func testActivity() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        
        // Screen reference to click out of text fields
        let sessionDefaultTable = app/*@START_MENU_TOKEN@*/.tables.containing(.other, identifier:"Session Default").element/*[[".tables.containing(.staticText, identifier:\"Animal\").element",".tables.containing(.staticText, identifier:\"Invasive\/Terrestrial\").element",".tables.containing(.staticText, identifier:\"Plant\").element",".tables.containing(.other, identifier:\"Animal\").element",".tables.containing(.other, identifier:\"Plant\").element",".tables.containing(.other, identifier:\"Session Default\").element"],[[[-1,5],[-1,4],[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        // Open Activity
        app.buttons["activity"].tap()
        let tablesQuery = app.tables
        
        
        // Type First Name
        let firstNameField = tablesQuery/*@START_MENU_TOKEN@*/.textFields["First Name"]/*[[".cells.textFields[\"First Name\"]",".textFields[\"First Name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        firstNameField.tap()
        firstNameField.typeText("test")
        sessionDefaultTable.tap()
        
        // Type Last Name
        let lastNameField = tablesQuery/*@START_MENU_TOKEN@*/.textFields["Last Name"]/*[[".cells.textFields[\"Last Name\"]",".textFields[\"Last Name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        lastNameField.tap()
        lastNameField.typeText("test")
        
        sessionDefaultTable.tap()
        
        // Dropdowns
        let dropdown = app.popovers.tables
        // Agency
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["agency"]/*[[".cells.textFields[\"agency\"]",".textFields[\"agency\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        dropdown/*@START_MENU_TOKEN@*/.staticTexts["Department of National Defense"]/*[[".cells.staticTexts[\"Department of National Defense\"]",".staticTexts[\"Department of National Defense\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        // Jurisdiction
        tablesQuery.textFields["jurisdiction"].tap()
        dropdown/*@START_MENU_TOKEN@*/.staticTexts["Provincial Parks"]/*[[".cells.staticTexts[\"Provincial Parks\"]",".staticTexts[\"Provincial Parks\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        // Close
        app.buttons["xmark.circle"].tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
