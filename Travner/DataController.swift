//
//  DataController.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 09/06/22.
//

import CoreData
import SwiftUI

/// An environment singleton responsible for managing our Core Data stack, including handling saving,
/// counting fetch requests, tracking awards, and dealing with sample data.
class DataController: ObservableObject {
    /// The lone CloudKit container used to store all our data.
    let container: NSPersistentCloudKitContainer

    /// Initializes a data controller, either in memory (for temporary use such as testing and previewing),
    /// or on permanent storage (for use in regular app runs.)
    ///
    /// Defaults to permanent storage.
    /// - Parameter inMemory: Whether to store this data in temporary memory or not.
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")

        // For testing and previewing purposes, we create a
        // temporary, in-memory database by writing to /dev/null
        // so our data is destroyed after the app finishes running.
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }

            self.container.viewContext.automaticallyMergesChangesFromParent = true
        }
    }

    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext

        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }

        return dataController
    }()

    /// Creates example guides and places to make manual testing easier.
    /// - Throws: An NSError sent from calling save() on the NSManagedObjectContext.
    func createSampleData() throws {
        let viewContext = container.viewContext

        for guideCounter in 1...5 {
            let guide = Guide(context: viewContext)
            guide.title = "Guide \(guideCounter)"
            guide.places = []
            guide.creationDate = Date()
            guide.closed = Bool.random()

            for placeCounter in 1...10 {
                let place = Place(context: viewContext)
                place.name = "Place \(placeCounter)"
                place.dateAdded = Date()
                place.completed = Bool.random()
                place.guide = guide
                place.priority = Int16.random(in: 1...3)
            }
        }

        try viewContext.save()
    }

    /// Saves our Core Data context iff there are changes. This silently ignores
    /// any errors caused by saving, but this should be fine because all our attributes are optional.
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }

    func deleteAll() {
        let fetchRequestPlaces: NSFetchRequest<NSFetchRequestResult> = Place.fetchRequest()
        let batchDeleteRequestPlaces = NSBatchDeleteRequest(fetchRequest: fetchRequestPlaces)
        _ = try? container.viewContext.execute(batchDeleteRequestPlaces)

        let fetchRequestGuides: NSFetchRequest<NSFetchRequestResult> = Guide.fetchRequest()
        let batchDeleteRequestGuides = NSBatchDeleteRequest(fetchRequest: fetchRequestGuides)
        _ = try? container.viewContext.execute(batchDeleteRequestGuides)
    }

    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "places":
            // returns true if they added a certain number of places
            let fetchRequest: NSFetchRequest<Place> = NSFetchRequest(entityName: "Place")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        case "complete":
            // returns true if they completed a certain number of places
            let fetchRequest: NSFetchRequest<Place> = NSFetchRequest(entityName: "Place")
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        default:
            // an unknown award criterion; this should never be allowed
            // fatalError("Unknown award criterion \(award.criterion).")
            return false
        }
    }
}
