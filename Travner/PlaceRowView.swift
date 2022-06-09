//
//  PlaceRowView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 09/06/22.
//

import SwiftUI

struct PlaceRowView: View {
    @ObservedObject var place: Place

    var body: some View {
        NavigationLink(destination: EditPlaceView(place: place)) {
            Text(place.placeName)
        }
    }
}

struct PlaceRowView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceRowView(place: Place.example)
    }
}
