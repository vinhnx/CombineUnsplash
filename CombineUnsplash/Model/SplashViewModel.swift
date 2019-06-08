//
//  SplashViewModel.swift
//  CombineUnsplash
//
//  Created by Vinh Nguyen on 8/6/19.
//  Copyright © 2019 Vinh Nguyen. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

/// A `Publisher` view model that taking care of fetching remote API on `TextField` enter key
/// press event emits. It will publish data event for any `Subscriber` to populate data when the
/// network response comes in
final class SplashViewModel: BindableObject {

    // MARK: - Properties

    /// A lazy initialize NetworkRequest instance
    private lazy var networkRequest = NetworkRequest()

    // MARK: - Binding

    /// A subject that passes along values and completion.
    internal let didChange = PassthroughSubject<SplashViewModel, Never>()

    /// Public model that we want to send to `Subscriber`s
    var data: Data? {
        didSet {
            guard self.data?.isEmpty == false else { return }
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }

    // MARK: - Public

    /// Fetch an image from Unsplash with a category
    /// - Parameter category: any category
    func fetch(_ category: String) {
        self.networkRequest.fetch(category: category) { [weak self] result in
            switch result {
            case .success(let response):
                self?.data = response
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
