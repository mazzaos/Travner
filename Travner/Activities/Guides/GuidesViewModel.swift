//
//  GuidesViewModel.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 08/07/22.
//

import CoreData
import Foundation

extension GuidesView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        let dataController: DataController

        var sortOrder = Place.SortOrder.optimized
        let showClosedGuides: Bool

        private let guidesController: NSFetchedResultsController<Guide>
        @Published var guides = [Guide]()

        init(dataController: DataController, showClosedGuides: Bool) {
            self.dataController = dataController
            self.showClosedGuides = showClosedGuides

            let request: NSFetchRequest<Guide> = Guide.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Guide.creationDate, ascending: false)]
            request.predicate = NSPredicate(format: "closed = %d", showClosedGuides)

            guidesController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            super.init()
            guidesController.delegate = self

            do {
                try guidesController.performFetch()
                guides = guidesController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch guides")
            }
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newGuides = controller.fetchedObjects as? [Guide] {
                guides = newGuides
            }
        }

        func addGuide() {
            let guide = Guide(context: dataController.container.viewContext)
            guide.closed = false
            guide.creationDate = Date()
            dataController.save()
        }

        func addPlace(to guide: Guide) {
            let place = Place(context: dataController.container.viewContext)
            place.guide = guide
            place.priority = 2
            place.completed = false
            place.dateAdded = Date()
            dataController.save()
        }

        func delete(_ offsets: IndexSet, from guide: Guide) {
            let allPlaces = guide.guidePlaces(using: sortOrder)

            for offset in offsets {
                let place = allPlaces[offset]
                dataController.delete(place)
            }

            dataController.save()
        }
    }
}
