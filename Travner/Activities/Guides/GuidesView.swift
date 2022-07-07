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

    @StateObject var viewModel: ViewModel
    @State private var showingSortOrder = false

    var guidesList: some View {
        List {
            ForEach(guides.wrappedValue) { guide in
                Section(header: GuideHeaderView(guide: guide)) {
                    ForEach(guide.guidePlaces(using: sortOrder)) { place in
                        PlaceRowView(guide: guide, place: place)
                    }
                    .onDelete { offsets in
                        delete(offsets, from: guide)
                    }

                    if showClosedGuides == false {
                        Button {
                            addPlace(to: guide)
                        } label: {
                            Label("Add New Place", systemImage: "plus")
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }

    var addGuideToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if showClosedGuides == false {
                Button {
                    addGuide()
                } label: {
                    Label("Add Guide", systemImage: "plus")
                }
            }
        }
    }

    var sortOrderToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                showingSortOrder.toggle()
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if guides.wrappedValue.isEmpty {
                    Text("There's nothing here right now.")
                        .foregroundColor(.secondary)
                } else {
                    guidesList
                }
            }
            .navigationTitle(showClosedGuides ? "Closed Guides" : "Open Guides")
            .toolbar {
                addGuideToolbarItem
                sortOrderToolbarItem
            }
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text("Sort places by:"), message: nil, buttons: [
                    .default(Text("Optimized")) { sortOrder = .optimized },
                    .default(Text("Date Added")) { sortOrder = .dateAdded },
                    .default(Text("Name")) { sortOrder = .name },
                    .cancel()
                ])
            }

            SelectSomethingView()
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
