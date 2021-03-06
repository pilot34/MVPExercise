//
//  MVPUITests.swift
//  MVPUITests
//
//  Created by Gleb Tarasov on 10/7/18.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import XCTest

class MVPUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    private let app = XCUIApplication()

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTapOnCellOpensDetailsScreen() {
        let cell = app.cells.firstMatch
        // wait while data is loading
        wait(forElement: cell)
        // tap on the first cell
        cell.tap()

        // check that we see details screen
        let text = app.textViews.firstMatch
        XCTAssert(text.exists)
        XCTAssert(text.stringValue.contains("Name:"))
    }
}
