//
//  GuidesViewModel.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 08/07/22.
//

import CoreData
import Foundation
import SwiftUI

extension GuidesView {
    class ViewModel: ObservableObject {
        let dataController: DataController

        var sortOrder = Place.SortOrder.optimized
        let showClosedGuides: Bool
        let guides: FetchRequest<Guide>

        init(dataController: DataController, showClosedGuides: Bool) {
            self.dataController = dataController
            self.showClosedGuides = showClosedGuides

            guides = FetchRequest<Guide>(entity: Guide.entity(), sortDescriptors: [
                NSSortDescriptor(keyPath: \Guide.creationDate, ascending: false)
            ], predicate: NSPredicate(format: "closed = %d", showClosedGuides))
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
