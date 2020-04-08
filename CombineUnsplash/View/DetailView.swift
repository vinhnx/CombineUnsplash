//
//  DetailView.swift
//  CombineUnsplash
//
//  Created by Vinh Nguyen on 7/2/19.
//  Copyright © 2019 Vinh Nguyen. All rights reserved.
//

import Foundation
import SwiftUI
import LinkPresentation

struct DetailView: View {
    @ObservedObject var preview: LinkPreviewData
    @State var response: LPLinkMetadata?
    var model: Splash

    var body: some View {
        NavigationView { makeView() }
            .navigationBarTitle(Text(model.author), displayMode: .inline)
            .onAppear {
                self.preview.fetch(self.model.url)
            }
            .onReceive(preview.didChange) { (response) in
                self.response = response
            }
    }

    private func makeView() -> some View {
        // NOTE: AnyView: "erase" LinkView -> AnyView, because SwiftUI View is opaque
        if let response = self.response {
            return AnyView(
                LinkView(data: response).padding()
            )
        } else {
            return AnyView(
                Text("loading...")
            )
        }
    }
}
