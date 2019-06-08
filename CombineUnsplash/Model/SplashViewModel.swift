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

final class SplashViewModel: BindableObject {

    // MARK: - Properties

    private lazy var networkRequest = NetworkRequest()

    // MARK: - Binding

    let didChange = PassthroughSubject<SplashViewModel, Never>()
    var data: Data? {
        didSet {
            guard self.data?.isEmpty == false else { return }
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }

    // MARK: - Public

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
