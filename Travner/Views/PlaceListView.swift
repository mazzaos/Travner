//
//  PlaceListView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 25/06/22.
//

import SwiftUI

struct PlaceListView: View {
    let title: LocalizedStringKey
    let places: FetchedResults<Place>.SubSequence

    var body: some View {
        if places.isEmpty {
            EmptyView()
        } else {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)

            ForEach(places) { place in
                NavigationLink(destination: EditPlaceView(place: place)) {
                    HStack(spacing: 20) {
                        Circle()
                            .stroke(Color(place.guide?.guideColor ?? "Light Blue"), lineWidth: 3)
                            .frame(width: 44, height: 44)

                        VStack(alignment: .leading) {
                            Text(place.placeName)
                                .font(.title2)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            if place.placeDetail.isEmpty == false {
                                Text(place.placeDetail)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color.secondarySystemGroupedBackground)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5)
                }
            }
        }
    }
}
