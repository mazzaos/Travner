//
//  PlaceRowView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 09/06/22.
//

import SwiftUI

struct PlaceRowView: View {
    @StateObject var viewModel: ViewModel
    @ObservedObject var place: Place

    init(guide: Guide, place: Place) {
        let viewModel = ViewModel(guide: guide, place: place)
        _viewModel = StateObject(wrappedValue: viewModel)

        self.place = place
    }

    var body: some View {
        NavigationLink(destination: EditPlaceView(place: place)) {
            Label {
                Text(viewModel.name)
            } icon: {
                Image(systemName: viewModel.icon)
                    .foregroundColor(viewModel.color.map { Color($0) } ?? .clear)
            }
        }
        .accessibilityLabel(viewModel.label)
    }
}

struct PlaceRowView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceRowView(guide: Guide.example, place: Place.example)
    }
}
