//
//  Guide-CoreDataHelpers.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 09/06/22.
//

import Foundation

extension Guide {
    var guideTitle: String {
        title ?? "New Guide"
    }

    var guideDetail: String {
        detail ?? ""
    }

    var guideColor: String {
        color ?? "Light Blue"
    }

    var guidePlaces: [Place] {
        let placesArray = places?.allObjects as? [Place] ?? []

        return placesArray.sorted { first, second in
            if first.completed == false {
                if second.completed == true {
                    return true
                }
            } else if first.completed == true {
                if second.completed == false {
                    return false
                }
            }

            if first.priority > second.priority {
                return true
            } else if first.priority < second.priority {
                return false
            }

            return first.placeDateAdded < second.placeDateAdded
        }
    }

    var completionAmount: Double {
        let originalPlaces = places?.allObjects as? [Place] ?? []
        guard originalPlaces.isEmpty == false else { return 0 }

        let completedPlaces = originalPlaces.filter(\.completed)
        return Double(completedPlaces.count) / Double(originalPlaces.count)
    }

    static var example: Guide {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let guide = Guide(context: viewContext)
        guide.title = "Example Guide"
        guide.detail = "This is an example guide"
        guide.closed = true
        guide.creationDate = Date()
        return guide
    }
}
