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
    @ObservedObject var viewModel: SplashViewModel

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
                        NavigationLink(
                            destination: DetailView(
                                preview: LinkPreviewData(),
                                model: model)
                        ) {
                            Text(model.author)
                        }
                    }
                }
            }

            .navigationBarTitle(
                Text("Unsplash"), displayMode: .large
            )
        }
        .onAppear(perform: fetchData) // fetch data when this `MainView` instance appears on scene
    }

    // MARK: - Private

    private func fetchData() {
        self.viewModel.fetchList()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: SplashViewModel())
    }
}
