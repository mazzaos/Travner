//
//  AwardTests.swift
//  TravnerTests
//
//  Created by Lorenzo Lins Mazzarotto on 07/07/22.
//

import CoreData
import XCTest
@testable import Travner

class AwardTests: BaseTestCase {
    let awards = Award.allAwards

    func testAwardIDMatchesName() {
        for award in awards {
            XCTAssertEqual(award.id, award.name, "Award ID should always match its name.")
        }
    }

    func testNoAwards() throws {
        for award in awards {
            XCTAssertFalse(dataController.hasEarned(award: award), "New users should have no earned awards")
        }
    }

    func testPlaceAwards() throws {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]

        for (count, value) in values.enumerated() {
            var places = [Place]()

            for _ in 0..<value {
                let place = Place(context: managedObjectContext)
                places.append(place)
            }

            let matches = awards.filter { award in
                award.criterion == "places" && dataController.hasEarned(award: award)
            }

            XCTAssertEqual(matches.count, count + 1, "Adding \(value) places should unlock \(count + 1) awards.")

            for place in places {
                dataController.delete(place)
            }
        }
    }

    func testCompletedAwards() throws {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]

        for (count, value) in values.enumerated() {
            var places = [Place]()

            for _ in 0..<value {
                let place = Place(context: managedObjectContext)
                place.completed = true
                places.append(place)
            }

            let matches = awards.filter { award in
                award.criterion == "complete" && dataController.hasEarned(award: award)
            }

            XCTAssertEqual(matches.count, count + 1, "Completing \(value) places should unlock \(count + 1) awards.")

            for place in places {
                dataController.delete(place)
            }
        }
    }
}
