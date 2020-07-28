//
//  UserModelTest.swift
//  InvasivesBCTests
//
//  Created by Pushan  on 2020-04-15.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import XCTest
@testable import InvasivesBC
class UserModelTest: XCTestCase {

    // Testing displayName computed prop of User Model
    func testDisplayName() throws {
        let testFirstName = "Test"
        let testLastName = "InvasivesBC"
        let testDisplayName = "\(testFirstName) \(testLastName)"
        let user: User = User()
        user.firstName = testFirstName
        user.lastName = testLastName
        XCTAssert(user.displayName == testDisplayName, "Display name should match")
    }

}
