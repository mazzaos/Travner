//
//  TravnerUITests.swift
//  TravnerUITests
//
//  Created by Lorenzo Lins Mazzarotto on 07/07/22.
//

import XCTest

class TravnerUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

    func testExample() throws {
        XCTAssertEqual(app.tabBars.buttons.count, 4, "There should be 4 tabs in the app.")
    }

    func testOpenTabAddsGuides() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        for tapCount in 1...5 {
            app.buttons["Add Guide"].tap()
            XCTAssertEqual(app.tables.cells.count, tapCount, "There should be \(tapCount) rows(s) in the list.")
        }
    }

    func testAddingPlaceInsertsRows() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        app.buttons["Add Guide"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a guide.")

        app.buttons["Add New Place"].tap()
        XCTAssertEqual(app.tables.cells.count, 2, "There should be 2 list rows after adding a place.")
    }
}
