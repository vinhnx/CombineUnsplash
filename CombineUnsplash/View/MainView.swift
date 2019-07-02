//
//  ImageView.swift
//  CombineUnsplash
//
//  Created by Vinh Nguyen on 8/6/19.
//  Copyright © 2019 Vinh Nguyen. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: SplashViewModel

    var body: some View {
        NavigationView {
            VStack {
                // loading indicator label
                Text(viewModel.isLoading ? "Loading..." : "")

                // error message label
                Text(viewModel.errorMessage)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)

                // make List if viewModel's error is empty
                if viewModel.errorMessage.isEmpty {
                    List(viewModel.models) { model in
                        NavigationButton(
                            destination: DetailView(model: model)
                                .environmentObject(LinkPreviewData())) {
                            Text(model.author)
                        }
                    }
                }
            }

            .navigationBarTitle(
                Text("Unsplash"), displayMode: .large
            )
        }
        .onAppear(perform: fetchData)

    }

    // MARK: - Private

    private func fetchData() {
        self.viewModel.fetchList()
    }
}
