//
//  GuideTests.swift
//  TravnerTests
//
//  Created by Lorenzo Lins Mazzarotto on 07/07/22.
//

import CoreData
import XCTest
@testable import Travner

class GuideTests: BaseTestCase {
    func testCreatingGuidesAndPlaces() {
        let targetCount = 10

        for _ in 0..<targetCount {
            let guide = Guide(context: managedObjectContext)

            for _ in 0..<targetCount {
                let place = Place(context: managedObjectContext)
                place.guide = guide
            }
        }

        XCTAssertEqual(dataController.count(for: Guide.fetchRequest()), targetCount)
        XCTAssertEqual(dataController.count(for: Place.fetchRequest()), targetCount * targetCount)
    }

    func testDeletingGuideCascadeDeletesPlaces() throws {
        try dataController.createSampleData()

        let request = NSFetchRequest<Guide>(entityName: "Guide")
        let guides = try managedObjectContext.fetch(request)

        dataController.delete(guides[0])

        XCTAssertEqual(dataController.count(for: Guide.fetchRequest()), 4)
        XCTAssertEqual(dataController.count(for: Place.fetchRequest()), 40)
    }
}
