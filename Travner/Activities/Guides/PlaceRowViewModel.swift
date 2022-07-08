//
//  PlaceRowViewModel.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 08/07/22.
//

import Foundation

extension PlaceRowView {
    class ViewModel: ObservableObject {
        let guide: Guide
        let place: Place

        var name: String {
            place.placeName
        }

        var icon: String {
            if place.completed {
                return "checkmark.circle"
            } else if place.priority == 3 {
                return "exclamationmark.triangle"
            } else {
                return "checkmark.circle"
            }
        }

        var color: String? {
            if place.completed {
                return guide.guideColor
            } else if place.priority == 3 {
                return guide.guideColor
            } else {
                return nil
            }
        }

        var label: String {
            if place.completed {
                return "\(place.placeName), completed."
            } else if place.priority == 3 {
                return "\(place.placeName), high priority."
            } else {
                return place.placeName
            }
        }

        init(guide: Guide, place: Place) {
            self.guide = guide
            self.place = place
        }
    }
}
