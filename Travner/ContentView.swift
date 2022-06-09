//
//  ContentView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 29/05/22.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("selectedView") var selectedView: String?

    var body: some View {
        TabView(selection: $selectedView) {
            HomeView()
                .tag(HomeView.tag)
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Guides")
                }

            GuidesView(showClosedGuides: false)
                .tag(GuidesView.openTag)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Open")
                }

            GuidesView(showClosedGuides: true)
                .tag(GuidesView.closedTag)
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("Closed")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
