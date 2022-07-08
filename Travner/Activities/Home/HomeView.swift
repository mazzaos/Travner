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

    @StateObject var viewModel: ViewModel

    var guideRows: [GridItem] {
        [GridItem(.fixed(100))]
    }

    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: guideRows) {
                            ForEach(viewModel.guides, content: GuideSummaryView.init)
                        }
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack(alignment: .leading) {
                        PlaceListView(title: "Up next", places: viewModel.upNext)
                        PlaceListView(title: "More to explore", places: viewModel.moreToExplore)
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("My Guides")
        }
    }
}

// .toolbar {
//     Button("Add Data", action: viewModel.addSampleData)
// }

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dataController: .preview)
    }
}
