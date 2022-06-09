//
//  PlaceRowView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 09/06/22.
//

import SwiftUI

struct PlaceRowView: View {
    @ObservedObject var guide: Guide
    @ObservedObject var place: Place

    var icon: some View {
        if place.completed {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(Color(guide.guideColor))
        } else if place.priority == 3 {
            return Image(systemName: "exclamationmark.triangle")
                .foregroundColor(Color(guide.guideColor))
        } else {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(.clear)
        }
    }

    var body: some View {
        NavigationLink(destination: EditPlaceView(place: place)) {
            Label {
                Text(place.placeName)
            } icon: {
                icon
            }
        }
    }
}

struct PlaceRowView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceRowView(guide: Guide.example, place: Place.example)
    }
}
