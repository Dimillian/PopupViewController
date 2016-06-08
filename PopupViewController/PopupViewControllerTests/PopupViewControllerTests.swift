//
//  PopupViewControllerTests.swift
//  PopupViewControllerTests
//
//  Created by Thomas Ricouard on 08/06/16.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import XCTest
import PopupViewController

class PopupViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBase() {
        let alert = PopupViewController(title: "Test", message: "Test")
        XCTAssertNotNil(alert.title)
        XCTAssertNotNil(alert.message)
    }
    
}
