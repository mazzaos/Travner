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
                        ForEach(guide.guidePlaces) { place in
                            PlaceRowView(place: place)
                        }
                        .onDelete { offsets in
                            let allPlaces = guide.guidePlaces

                            for offset in offsets {
                                let place = allPlaces[offset]
                                dataController.delete(place)
                            }

                            dataController.save()
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(showClosedGuides ? "Closed Guides" : "Open Guides")
            .toolbar {
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
