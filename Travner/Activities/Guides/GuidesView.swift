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
            ForEach(viewModel.guides.wrappedValue) { guide in
                Section(header: GuideHeaderView(guide: guide)) {
                    ForEach(guide.guidePlaces(using: viewModel.sortOrder)) { place in
                        PlaceRowView(guide: guide, place: place)
                    }
                    .onDelete { offsets in
                        viewModel.delete(offsets, from: guide)
                    }

                    if viewModel.showClosedGuides == false {
                        Button {
                            viewModel.addPlace(to: guide)
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
            if viewModel.showClosedGuides == false {
                Button {
                    viewModel.addGuide()
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
                if viewModel.guides.wrappedValue.isEmpty {
                    Text("There's nothing here right now.")
                        .foregroundColor(.secondary)
                } else {
                    guidesList
                }
            }
            .navigationTitle(viewModel.showClosedGuides ? "Closed Guides" : "Open Guides")
            .toolbar {
                addGuideToolbarItem
                sortOrderToolbarItem
            }
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text("Sort places by:"), message: nil, buttons: [
                    .default(Text("Optimized")) { viewModel.sortOrder = .optimized },
                    .default(Text("Date Added")) { viewModel.sortOrder = .dateAdded },
                    .default(Text("Name")) { viewModel.sortOrder = .name },
                    .cancel()
                ])
            }

            SelectSomethingView()
        }
    }

    init(dataController: DataController, showClosedGuides: Bool) {
        let viewModel = ViewModel(dataController: dataController, showClosedGuides: showClosedGuides)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}

struct GuidesView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        GuidesView(dataController: DataController.preview, showClosedGuides: false)
    }
}
