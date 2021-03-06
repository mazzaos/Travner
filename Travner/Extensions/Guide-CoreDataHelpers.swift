//
//  Guide-CoreDataHelpers.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 09/06/22.
//

import SwiftUI

extension Guide {
    static let colors = [
        "Pink",
        "Purple",
        "Red",
        "Orange",
        "Gold",
        "Green",
        "Teal",
        "Light Blue",
        "Dark Blue",
        "Midnight",
        "Dark Gray",
        "Gray"
    ]

    var guideTitle: String {
        title ?? NSLocalizedString("New Guide", comment: "Create a new guide")
    }

    var guideDetail: String {
        detail ?? ""
    }

    var guideColor: String {
        color ?? "Light Blue"
    }

    var guidePlaces: [Place] {
        places?.allObjects as? [Place] ?? []
    }

    var guidePlacesDefaultSorted: [Place] {
        guidePlaces.sorted { first, second in
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

    var label: LocalizedStringKey {
        // swiftlint:disable:next line_length
        LocalizedStringKey("\(guideTitle), \(guidePlaces.count) places, \(completionAmount * 100, specifier: "%g")% complete.")
    }

    static var example: Guide {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext

        let guide = Guide(context: viewContext)
        guide.title = "Example Guide"
        guide.detail = "This is an example guide"
        guide.closed = true
        guide.creationDate = Date()
        return guide
    }

    func guidePlaces(using sortOrder: Place.SortOrder) -> [Place] {
        switch sortOrder {
        case .name:
            return guidePlaces.sorted(by: \Place.placeName)
        case .dateAdded:
            return guidePlaces.sorted(by: \Place.placeDateAdded)
        case .optimized:
            return guidePlacesDefaultSorted
        }
    }
}
