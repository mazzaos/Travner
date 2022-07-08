//
//  HomeViewModel.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 08/07/22.
//

import CoreData
import Foundation

extension HomeView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let guidesController: NSFetchedResultsController<Guide>
        private let placesController: NSFetchedResultsController<Place>

        @Published var guides = [Guide]()
        @Published var places = [Place]()

        var dataController: DataController

        var upNext: ArraySlice<Place> {
            places.prefix(3)
        }

        var moreToExplore: ArraySlice<Place> {
            places.dropFirst(3)
        }

        init(dataController: DataController) {
            self.dataController = dataController

            // Construct a fetch request to show all open guides.
            let guideRequest: NSFetchRequest<Guide> = Guide.fetchRequest()
            guideRequest.predicate = NSPredicate(format: "closed = false")
            guideRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Guide.title, ascending: true)]

            guidesController = NSFetchedResultsController(
                fetchRequest: guideRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            // Construct a fetch request to show the 10 highest-priority,
            // incomplete places from open guides.
            let placeRequest: NSFetchRequest<Place> = Place.fetchRequest()

            let completedPredicate = NSPredicate(format: "completed = false")
            let openPredicate = NSPredicate(format: "guide.closed = false")
            placeRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
            placeRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Place.priority, ascending: false)]
            placeRequest.fetchLimit = 10

            placesController = NSFetchedResultsController(
                fetchRequest: placeRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            super.init()

            guidesController.delegate = self
            placesController.delegate = self

            do {
                try guidesController.performFetch()
                try placesController.performFetch()
                guides = guidesController.fetchedObjects ?? []
                places = placesController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch initial data.")
            }
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newPlaces = controller.fetchedObjects as? [Place] {
                places = newPlaces
            } else if let newGuides = controller.fetchedObjects as? [Guide] {
                guides = newGuides
            }
        }

        func addSampleData() {
            dataController.deleteAll()
            try? dataController.createSampleData()
        }
    }
}
