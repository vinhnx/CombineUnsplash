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

    // A `Publisher` view model that taking care of fetching remote API on `TextField` enter key press event.
    // It will publish data event for any `Subscriber` to populate data when the network response comes in
    @EnvironmentObject private var viewModel: SplashViewModel

    // Define `category` as @State (a Binding) means we can have synthesized storage (getter and setter)
    // because we will use it for both read (#1) and write (#2).
    // IMPORTANT: @State properites should be declared as `private` to prevent other views mutate it.
    @State private var category = ""

    // MARK: - View

    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            HStack {
                // #2 write (mutates) the underlying value of `category`
                TextField($category, placeholder: Text("eg: nature")) {
                    self.fetchData()
                }.font(.body)

                VStack {
                    // #1 read the value of `category`
                    // you can just use `category` to read the underlying value of $category
                    Text($category.value.uppercased())
                        .font(.title)
                    Text("from Unsplash.com")
                        .font(.caption)
                }
            }

            ImageView(data: $viewModel.data)
                .frame(width: 350, height: 197)
                .cornerRadius(10)

            Spacer()
        }.padding()
    }

    // MARK: - Private

    private func fetchData() {
        // like #1 above
        // note: you can just use `self.category` to read the underlying value of $category
        // so we have two ways to read the value of $category's underlying value
        // 1. self.category (getter)
        // 2. $category.value (the value of $category binding)
        self.viewModel.fetch($category.value)
    }
}
