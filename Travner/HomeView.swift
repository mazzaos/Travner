//
//  HomeView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 09/06/22.
//

import SwiftUI

struct HomeView: View {
    static let tag: String? = "Guides"
    
    @EnvironmentObject var dataController: DataController

    var body: some View {
        NavigationView {
            ScrollView {

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
