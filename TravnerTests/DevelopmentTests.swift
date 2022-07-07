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
}
