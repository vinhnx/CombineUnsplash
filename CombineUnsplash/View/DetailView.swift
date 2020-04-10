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
    @ObservedObject var viewModel: DetailViewModel
    @State var response: LPLinkMetadata?
    var model: Splash

    var body: some View {
        NavigationView { makeView() }
            .navigationBarTitle(Text(self.model.author), displayMode: .inline)
            .onAppear {
                self.viewModel.handleFetchSignal()
            }
            .onReceive(viewModel.$metadata) { (response) in
                self.response = response
            }
    }

    private func makeView() -> some View {
        // NOTE: AnyView: "erase" LinkView -> AnyView, because SwiftUI View is opaque ("some")
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
