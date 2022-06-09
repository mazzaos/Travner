//
//  EditPlaceView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 09/06/22.
//

import SwiftUI

struct EditPlaceView: View {
    let place: Place

    @EnvironmentObject var dataController: DataController

    @State private var name: String
    @State private var detail: String
    @State private var priority: Int
    @State private var completed: Bool

    init(place: Place) {
        self.place = place

        _name = State(wrappedValue: place.placeName)
        _detail = State(wrappedValue: place.placeDetail)
        _priority = State(wrappedValue: Int(place.priority))
        _completed = State(wrappedValue: place.completed)
    }

    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                TextField("Place name", text: $name)
                TextField("Description", text: $detail)
            }

            Section(header: Text("Priority")) {
                Picker("Priority", selection: $priority) {
                    Text("Low").tag(1)
                    Text("Medium").tag(2)
                    Text("High").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section {
                Toggle("Mark Completed", isOn: $completed)
            }
        }
        .navigationTitle("Edit Place")
        .onChange(of: name) { _ in update() }
        .onChange(of: detail) { _ in update() }
        .onChange(of: priority) { _ in update() }
        .onChange(of: completed) { _ in update() }
    }

    func update() {
        place.guide?.objectWillChange.send()

        place.name = name
        place.detail = detail
        place.priority = Int16(priority)
        place.completed = completed
    }
}

struct EditPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        EditPlaceView(place: Place.example)
    }
}
