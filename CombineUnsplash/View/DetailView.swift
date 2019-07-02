//
//  DetailView.swift
//  CombineUnsplash
//
//  Created by Vinh Nguyen on 7/2/19.
//  Copyright © 2019 Vinh Nguyen. All rights reserved.
//

import Foundation
import SwiftUI

struct DetailView: View {
    @EnvironmentObject var preview: LinkPreviewData

    var model: Splash

    var body: some View {
        NavigationView {
            VStack {
                LinkView(data: $preview.metadata)
            }.padding()
        }
        .navigationBarTitle(Text(model.author),
                            displayMode: .inline)
        .onAppear {
            self.preview.fetch(self.model.url)
        }
    }
}
