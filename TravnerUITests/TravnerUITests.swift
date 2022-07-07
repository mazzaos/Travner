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

    func testEditingGuideUpdatesCorrectly() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        app.buttons["Add Guide"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a guide.")

        app.buttons["Compose"].tap()
        app.textFields["Guide title"].tap()

        app.keys["space"].tap()
        app.keys["more"].tap()
        app.keys["2"].tap()
        app.buttons["Return"].tap()

        app.buttons["Open Guides"].tap()

        XCTAssertTrue(
            app.tables.staticTexts["New Guide 2"].exists,
            "The new guide title should be visible in the list."
        )
    }

    func testEditingPlaceUpdatesCorrectly() {
        // Go to Open Guides and add one guide and one place.
        testAddingPlaceInsertsRows()

        app.buttons["New Place"].tap()
        app.textFields["Place name"].tap()

        app.keys["space"].tap()
        app.keys["more"].tap()
        app.keys["2"].tap()
        app.buttons["Return"].tap()

        app.buttons["Open Guides"].tap()

        XCTAssertTrue(app.buttons["New Place 2"].exists, "The new place name should be visible in the list.")
    }

    func testAllAwardsShowLockedAlert() {
        app.buttons["Awards"].tap()

        for award in app.scrollViews.buttons.allElementsBoundByIndex {
            award.tap()
            XCTAssertTrue(app.alerts["Locked"].exists, "There should be a Locked alert showing for awards.")
            app.buttons["OK"].tap()
        }
    }
}
