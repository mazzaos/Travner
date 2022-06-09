//
//  GuidesView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 09/06/22.
//

import SwiftUI

struct GuidesView: View {
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var showingSortOrder = false
    @State private var sortOrder = Place.SortOrder.optimized
    
    let showClosedGuides: Bool
    let guides: FetchRequest<Guide>

    init(showClosedGuides: Bool) {
        self.showClosedGuides = showClosedGuides

        guides = FetchRequest<Guide>(entity: Guide.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Guide.creationDate, ascending: false)
        ], predicate: NSPredicate(format: "closed = %d", showClosedGuides))
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(guides.wrappedValue) { guide in
                    Section(header: GuideHeaderView(guide: guide)) {
                        ForEach(guide.guidePlaces(using: sortOrder)) { place in
                            PlaceRowView(guide: guide, place: place)
                        }
                        .onDelete { offsets in
                            let allPlaces = guide.guidePlaces

                            for offset in offsets {
                                let place = allPlaces[offset]
                                dataController.delete(place)
                            }

                            dataController.save()
                        }

                        if showClosedGuides == false {
                            Button {
                                withAnimation {
                                    let place = Place(context: managedObjectContext)
                                    place.guide = guide
                                    place.dateAdded = Date()
                                    dataController.save()
                                }
                            } label: {
                                Label("Add New Place", systemImage: "plus")
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(showClosedGuides ? "Closed Guides" : "Open Guides")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if showClosedGuides == false {
                        Button {
                            withAnimation {
                                let guide = Guide(context: managedObjectContext)
                                guide.closed = false
                                guide.creationDate = Date()
                                dataController.save()
                            }
                        } label: {
                            Label("Add Guide", systemImage: "plus")
                        }
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSortOrder.toggle()
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text("Sort places"), message: nil, buttons: [
                    .default(Text("Optimized")) { sortOrder = .optimized },
                    .default(Text("Date Added")) { sortOrder = .dateAdded },
                    .default(Text("Name")) { sortOrder = .name }
                ])
            }
        }
    }
}

struct GuidesView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        GuidesView(showClosedGuides: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
