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

    @FetchRequest(
        entity: Guide.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Guide.title, ascending: true)],
        predicate: NSPredicate(format: "closed = false")
    ) var guides: FetchedResults<Guide>

    let places: FetchRequest<Place>

    var guideRows: [GridItem] {
        [GridItem(.fixed(100))]
    }

    init() {
        // Construct a fetch request to show the 10 highest-priority, incomplete places from open guides.
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
                            ForEach(guides, content: GuideSummaryView.init)
                        }
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack(alignment: .leading) {
                        PlaceListView(title: "Up next", places: places.wrappedValue.prefix(3))
                        PlaceListView(title: "More to explore", places: places.wrappedValue.dropFirst(3))
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("My Guides")
        }
    }
}

// Button("Add Data") {
//    dataController.deleteAll()
//    try? dataController.createSampleData()
// }

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
