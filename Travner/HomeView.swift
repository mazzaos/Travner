//
//  HomeView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 09/06/22.
//

import CoreData
import SwiftUI

struct HomeView: View {
    static let tag: String? = "Guides"
    
    @EnvironmentObject var dataController: DataController

    @FetchRequest(entity: Guide.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Guide.title, ascending: true)], predicate: NSPredicate(format: "closed = false")) var guides: FetchedResults<Guide>
    let places: FetchRequest<Place>

    var guideRows: [GridItem] {
        [GridItem(.fixed(100))]
    }

    init() {
        let request: NSFetchRequest<Place> = Place.fetchRequest()

        let completedPredicate = NSPredicate(format: "completed = false")
        let openPredicate = NSPredicate(format: "guide.closed = false")
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])

        request.predicate = compoundPredicate

        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Place.priority, ascending: false)
        ]

        request.fetchLimit = 10
        places = FetchRequest(fetchRequest: request)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: guideRows) {
                            ForEach(guides) { guide in
                                VStack(alignment: .leading) {
                                    Text("\(guide.guidePlaces.count) places")
                                        .font(.caption)
                                        .foregroundColor(.secondary)

                                    Text(guide.guideTitle)
                                        .font(.title2)

                                    ProgressView(value: guide.completionAmount)
                                        .accentColor(Color(guide.guideColor))
                                }
                                .padding()
                                .background(Color.secondarySystemGroupedBackground)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.2), radius: 5)
                            }
                        }
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack(alignment: .leading) {
                        list("Up next", for: places.wrappedValue.prefix(3))
                        list("More to explore", for: places.wrappedValue.dropFirst(3))
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("My Guides")
        }
    }

    @ViewBuilder func list(_ title: LocalizedStringKey, for places: FetchedResults<Place>.SubSequence) -> some View {
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

//Button("Add Data") {
//    dataController.deleteAll()
//    try? dataController.createSampleData()
//}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
