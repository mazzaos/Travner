//
//  DataController.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 09/06/22.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { storeDescription, error in
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

    func createSampleData() throws {
        let viewContext = container.viewContext

        for i in 1...5 {
            let guide = Guide(context: viewContext)
            guide.title = "Guide \(i)"
            guide.places = []
            guide.creationDate = Date()
            guide.closed = Bool.random()

            for j in 1...10 {
                let place = Place(context: viewContext)
                place.name = "Place \(j)"
                place.dateAdded = Date()
                place.completed = Bool.random()
                place.guide = guide
                place.priority = Int16.random(in: 1...3)
            }
        }

        try viewContext.save()
    }

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
            let fetchRequest: NSFetchRequest<Place> = NSFetchRequest(entityName: "Place")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
            
        case "complete":
            let fetchRequest: NSFetchRequest<Place> = NSFetchRequest(entityName: "Place")
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        default:
            // fatalError("Unknown award criterion \(award.criterion).")
            return false
        }
    }
}
