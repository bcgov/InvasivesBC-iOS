//
//  FieldModelTest.swift
//  InvasivesBCTests
//
//  Created by Pushan  on 2020-04-08.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import XCTest
import UIKit
@testable import InvasivesBC

// Unit test for all FieldViewModel sub classes
class FieldModelTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReadOnlyFieldModel() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let testData = "Hello World"
        let model = ReadOnlyFieldViewModel(header: "H", key: "k", editable: false, data: testData)
        XCTAssertNotNil(model)
        XCTAssert(model.value == testData)
        XCTAssert(model.header == "H")
        XCTAssert(model.key == "k")
    }
    
    func testTextFieldViewModel() {
        let testData = "Hello World"
        let model = TextFieldViewModel(header: "H", key: "k", editable: false, data: testData)
        XCTAssertNotNil(model)
        XCTAssert(model.value == testData)
        XCTAssert(model.header == "H")
        XCTAssert(model.key == "k")
    }
    
    func testTextAreaFieldViewModel() {
        let testData = "Hello World"
        let model = TextAreaFieldViewModel(header: "H", key: "k", editable: false, data: testData)
        XCTAssertNotNil(model)
        XCTAssert(model.value == testData)
        XCTAssert(model.header == "H")
        XCTAssert(model.key == "k")
    }
    
    func testSwitchFielViewModel()  {
        let testData = true
        let model = SwitchFieldViewModel(header: "H", key: "k", editable: false, data: testData)
        XCTAssertNotNil(model)
        XCTAssert(model.value == testData)
        XCTAssert(model.header == "H")
        XCTAssert(model.key == "k")
    }
    
    func testDateFieldViewModel() {
        let testData: Date = Date()
        let model = DateFieldViewModel(header: "H", key: "k", editable: true, data: testData)
        XCTAssertNotNil(model)
        XCTAssert(model.value == testData)
        XCTAssert(model.header == "H")
        XCTAssert(model.key == "k")
        
        let model2 = DateFieldViewModel(header: "H", key: "k", editable: true, data: nil)
        XCTAssertNil(model2.value)
    }
    
    func testTitleFieldViewModel() {
        let testData = "Hello World"
        let model = TitleFieldViewModel(title: testData, width: .Forth)
        XCTAssertNotNil(model)
        XCTAssert(model.value == testData)
        XCTAssert(model.width == .Forth)
    }
    
    func testSpacerFieldViewModel()  {
        let testHeight: CGFloat = 98.0
        let model: SpacerFieldViewModel = SpacerFieldViewModel(width: .Half, height: testHeight)
        XCTAssert(model.width == .Half)
        XCTAssert(model.height == testHeight)
    }

}
