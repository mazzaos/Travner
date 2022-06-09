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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct EditGuideView_Previews: PreviewProvider {
    static var previews: some View {
        EditGuideView(guide: Guide.example)
    }
}
