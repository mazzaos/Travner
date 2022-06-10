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

    init() {
        let request: NSFetchRequest<Place> = Place.fetchRequest()
        request.predicate = NSPredicate(format: "completed = false")

        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Place.priority, ascending: false)
        ]

        request.fetchLimit = 10
        places = FetchRequest(fetchRequest: request)
    }

    var guideRows: [GridItem] {
        [GridItem(.fixed(100))]
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
                    }
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("My Guides")
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
