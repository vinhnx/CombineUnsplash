//
//  ImageView.swift
//  CombineUnsplash
//
//  Created by Vinh Nguyen on 8/6/19.
//  Copyright © 2019 Vinh Nguyen. All rights reserved.
//

import SwiftUI

/// Main view
struct MainView: View {

    // MARK: - Binding

    // A `Publisher` view model that taking care of fetching remote API on `TextField` enter key
    // press event emits. It will publish data event for any `Subscriber` to populate data when the
    // network response comes in
    @EnvironmentObject internal var viewModel: SplashViewModel

    // We just want `category` as view state for internal observers
    @State internal var category = ""

    // MARK: - View

    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            HStack {
                TextField($category, placeholder: Text("eg: nature, then press enter")) {
                    self.fetchData()
                }.font(.body)

                VStack {
                    Text($category.value.uppercased())
                        .font(.title)
                    Text("from Unsplash.com")
                        .font(.caption)
                }
            }

            // SwiftUI's `Image` doesn't have `Binding`, so we wrap UIImageView with `UIViewRepresentable`
            // instead, to subscribe (or listen) to any data @Binding event
            ImageWrapper(data: $viewModel.data)
                .frame(width: 350, height: 197)
                .cornerRadius(10)

            Spacer()
        }.padding()
    }

    // MARK: - Private

    private func fetchData() {
        self.viewModel.fetch($category.value)
    }
}
