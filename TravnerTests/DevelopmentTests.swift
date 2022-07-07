//
//  DevelopmentTests.swift
//  TravnerTests
//
//  Created by Lorenzo Lins Mazzarotto on 07/07/22.
//

import CoreData
import XCTest
@testable import Travner

class DevelopmentTests: BaseTestCase {
    func testSampleDataCreationWorks() throws {
        try dataController.createSampleData()

        XCTAssertEqual(dataController.count(for: Guide.fetchRequest()), 5, "There should be 5 sample guides.")
        XCTAssertEqual(dataController.count(for: Place.fetchRequest()), 50, "There should be 50 sample places.")
    }

    func testDeleteAllClearsEverything() throws {
        try dataController.createSampleData()
        dataController.deleteAll()

        XCTAssertEqual(dataController.count(for: Guide.fetchRequest()), 0, "deleteAll() should leave 0 guides.")
        XCTAssertEqual(dataController.count(for: Place.fetchRequest()), 0, "deleteAll() should leave 0 places.")
    }

    func testExampleGuideIsClosed() {
        let guide = Guide.example
        XCTAssertTrue(guide.closed, "The example guide should be closed.")
    }

    func testExamplePlaceIsHighPriority() {
        let place = Place.example
        XCTAssertEqual(place.priority, 3, "The example place should be high priority.")
    }
}
