//
//  Place-CoreDataHelpers.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 09/06/22.
//

import Foundation

extension Place {
    enum SortOrder {
        case optimized, name, dateAdded
    }

    var placeName: String {
        name ?? "New Place"
    }

    var placeDetail: String {
        detail ?? ""
    }

    var placeDateAdded: Date {
        dateAdded ?? Date()
    }

    static var example: Place {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let place = Place(context: viewContext)
        place.name = "Example Place"
        place.detail = "This is an example place"
        place.priority = 3
        place.dateAdded = Date()
        return place
    }
}
