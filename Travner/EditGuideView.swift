//
//  EditGuideView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 09/06/22.
//

import SwiftUI

struct EditGuideView: View {
    let guide: Guide

    @EnvironmentObject var dataController: DataController

    @State private var title: String
    @State private var detail: String
    @State private var color: String

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
                    ForEach(Guide.colors, id: \.self) { item in
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
                    }
                }
                .padding(.vertical)
            }

            Section(footer: Text("Closing a guide moves it from the Open to Closed tab; deleting it removes the guide completely.")) {
                Button(guide.closed ? "Reopen this guide" : "Close this guide") {
                    guide.closed.toggle()
                    update()
                }

                Button("Delete this guide") {
                    // delete the guide
                }
                .accentColor(.red)
            }
        }
        .navigationTitle("Edit Guide")
    }

    func update() {
        guide.title = title
        guide.detail = detail
        guide.color = color
    }
}

struct EditGuideView_Previews: PreviewProvider {
    static var previews: some View {
        EditGuideView(guide: Guide.example)
    }
}
