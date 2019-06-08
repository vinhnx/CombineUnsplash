//
//  ImageView.swift
//  CombineUnsplash
//
//  Created by Vinh Nguyen on 8/6/19.
//  Copyright © 2019 Vinh Nguyen. All rights reserved.
//

import SwiftUI

struct MainView: View {

    // MARK: - Binding

    @EnvironmentObject var viewModel: SplashViewModel
    @State var category = ""

    // MARK: - View

    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            HStack {
                TextField($category, placeholder: Text("eg: nature, then press enter")) {
                    self.fetchData()
                }.font(.body)

                VStack {
                    Text(self.category.uppercased())
                        .font(.title)
                    Text("from Unsplash.com")
                        .font(.caption)
                }
            }

            ImageWrapper(data: $viewModel.data)
                .frame(width: 350, height: 197)
                .cornerRadius(10)

            Spacer()
        }.padding()
    }

    // MARK: - Private

    private func fetchData() {
        self.viewModel.fetch(self.category)
    }
}
