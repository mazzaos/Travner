//
//  GuidesView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 09/06/22.
//

import SwiftUI

struct GuidesView: View {
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
                    Section(header: Text(guide.title ?? "")) {
                        ForEach(guide.places?.allObjects as? [Place] ?? []) { place in
                            Text(place.name ?? "")
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(showClosedGuides ? "Closed Guides" : "Open Guides")
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
