//
//  GuidesViewModel.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 08/07/22.
//

import CoreData
import Foundation

extension GuidesView {
    class ViewModel: ObservableObject {
        @State private var sortOrder = Place.SortOrder.optimized

        let showClosedGuides: Bool
        
        let guides: FetchRequest<Guide>

        init(showClosedGuides: Bool) {
            self.showClosedGuides = showClosedGuides

            guides = FetchRequest<Guide>(entity: Guide.entity(), sortDescriptors: [
                NSSortDescriptor(keyPath: \Guide.creationDate, ascending: false)
            ], predicate: NSPredicate(format: "closed = %d", showClosedGuides))
        }
        
        func addGuide() {
            withAnimation {
                let guide = Guide(context: managedObjectContext)
                guide.closed = false
                guide.creationDate = Date()
                dataController.save()
            }
        }

        func addPlace(to guide: Guide) {
            withAnimation {
                let place = Place(context: managedObjectContext)
                place.guide = guide
                place.priority = 2
                place.completed = false
                place.dateAdded = Date()
                dataController.save()
            }
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
