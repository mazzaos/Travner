//
//  EditGuideView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 09/06/22.
//

import SwiftUI

struct EditGuideView: View {
    @ObservedObject var guide: Guide

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var showingDeleteConfirm = false

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(guide: Guide) {
        self.guide = guide

        _title = State(wrappedValue: guide.guideTitle)
        _detail = State(wrappedValue: guide.guideDetail)
        _color = State(wrappedValue: guide.guideColor)
    }

    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                TextField("Guide name", text: $title.onChange(update))
                TextField("Description of this guide", text: $detail.onChange(update))
            }

            Section(header: Text("Custom guide color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Guide.colors, id: \.self, content: colorButton)
                }
                .padding(.vertical)
            }

            // swiftlint:disable:next line_length
            Section(footer: Text("Closing a guide moves it from the Open to Closed tab; deleting it removes the guide completely.")) {
                Button(guide.closed ? "Reopen this guide" : "Close this guide") {
                    guide.closed.toggle()
                    update()
                }

                Button("Delete this guide") {
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
            }
        }
        .navigationTitle("Edit Guide")
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(
                title: Text("Delete guide?"),
                message: Text("Are you sure you want to delete this guide? You will also delete all the places it contains."), // swiftlint:disable:this line_length
                primaryButton: .default(Text("Delete"), action: delete),
                secondaryButton: .cancel()
            )
        }
    }

    func update() {
        guide.title = title
        guide.detail = detail
        guide.color = color
    }

    func delete() {
        dataController.delete(guide)
        presentationMode.wrappedValue.dismiss()
    }

    func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)

            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = item
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            item == color
                ? [.isButton, .isSelected]
                : .isButton
        )
        .accessibilityLabel(LocalizedStringKey(item))
    }
}

struct EditGuideView_Previews: PreviewProvider {
    static var previews: some View {
        EditGuideView(guide: Guide.example)
    }
}
