//
//  GuideHeaderView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 09/06/22.
//

import SwiftUI

struct GuideHeaderView: View {
    @ObservedObject var guide: Guide

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(guide.guideTitle)

                ProgressView(value: guide.completionAmount)
            }

            Spacer()

            NavigationLink(destination: EmptyView()) {
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
            }
        }
        .padding(.bottom, 10)
    }
}

struct GuideHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        GuideHeaderView(guide: Guide.example)
    }
}
