//
//  FieldCellTests.swift
//  InvasivesBCTests
//
//  Created by Pushan  on 2020-04-09.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import XCTest
@testable import InvasivesBC
class FieldCellTests: XCTestCase {

    

    func testTextFieldCell() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let cell: TextFieldCollectionViewCell = TextFieldCollectionViewCell.fromNib()
        XCTAssertNotNil(cell)
        XCTAssertNotNil(cell.headerLabel)
        XCTAssertNotNil(cell.textField)
        let model = TextFieldViewModel(header: "Test", key: "k", editable: true, width: .Fill, data: "Laba")
        cell.initialize(model: model)
        // Test Initial value
        XCTAssert(cell.headerLabel?.text == "Test")
        XCTAssert(cell.textField?.text == "Laba")
        // Test Value chnage
        model.value = "New Laba"
        XCTAssert(cell.textField?.text == "New Laba")
        cell.value = "New Value"
        XCTAssert(model.value == "New Value")
    }
    
    func testTextAreaField() throws {
        let cell: TextAreaFieldCollectionViewCell = TextAreaFieldCollectionViewCell.fromNib()
        XCTAssertNotNil(cell)
        XCTAssertNotNil(cell.fieldHeader)
        XCTAssertNotNil(cell.textArea)
        let model = TextAreaFieldViewModel(header: "Test", key: "k", editable: true, width: .Fill, data: "Laba")
        cell.initialize(model: model)
        // Test Initial value
        XCTAssert(cell.fieldHeader?.text == "Test")
        XCTAssert(cell.textArea?.text == "Laba")
        // Test Value chnage
        model.value = "New Laba"
        XCTAssert(cell.textArea?.text == "New Laba")
    }
    
    func testSwitchField() throws {
        let testHeader = "Header"
        let key = "k"
        let testValue = true
        let model = SwitchFieldViewModel(header: testHeader, key: key, editable: true, width: .Half, data: testValue)
        let cell: SwitchFieldCollectionViewCell = SwitchFieldCollectionViewCell.fromNib()
        cell.initialize(model: model)
        XCTAssertNotNil(cell.headerLabel)
        XCTAssertNotNil(cell.switchView)
        XCTAssert(cell.headerLabel?.text == testHeader)
        XCTAssert(cell.switchView?.isOn == testValue)
        
        // Change value
        let newValue = false
        model.value = newValue
        XCTAssert(cell.switchView?.isOn == newValue)
        
        // Change cell value
        cell.value = true
        XCTAssert(model.value == true)
    }
    
    func testDateField() throws {
        let testHeader = "Header"
        let key = "k"
        let testValue = Date(timeIntervalSinceNow: -1000.0)
        let model = DateFieldViewModel(header: testHeader, key: key, editable: true, width: .Fill, data: testValue)
        let cell: DateFieldCollectionViewCell = DateFieldCollectionViewCell.fromNib()
        cell.initialize(model: model)
        XCTAssertNotNil(cell.headerLabel)
        XCTAssertNotNil(cell.textField)
        XCTAssert(cell.headerLabel?.text == testHeader)
        XCTAssert(cell.textField?.text == testValue.string())
        
        // Change value
        let newValue = Date()
        model.value = newValue
        XCTAssert(cell.textField?.text == newValue.string())
        
        // Change cell value
        let updateValue = Date(timeIntervalSinceNow: -2000.0)
        cell.value = updateValue
        XCTAssert(model.value?.timeIntervalSince1970 == updateValue.timeIntervalSince1970)
    }

}
