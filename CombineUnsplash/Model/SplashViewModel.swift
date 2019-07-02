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
    typealias ViewModelSubject = PassthroughSubject<SplashViewModel, Never>
    typealias ResponseSubject = PassthroughSubject<[Splash], SplashError>

    // MARK: - Properties

    private lazy var networkRequest = NetworkRequest()

    // MARK: - Binding

    internal let didChange = ViewModelSubject()
    private let responseSubject = ResponseSubject()
    private let errorSubject = ResponseSubject()
    private var cancellables = [AnyCancellable]()

    var state: State = .loading
    enum State {
        case loading
        case completed(response: [Splash])
        case failed(error: String)
    }

    var isLoading = true {
        didSet {
            self.didChange.send(self)
        }
    }

    var errorMessage = "" {
        didSet {
            self.state = .failed(error: self.errorMessage)
            self.didChange.send(self)
        }
    }

    var models: [Splash] = [] {
        didSet {
            guard self.models != oldValue else { return }
            self.state = .completed(response: self.models)
            self.didChange.send(self)
        }
    }

    // MARK: - Public

    func fetchList() {
        let responsePublisher = self.networkRequest.fetchListSignal()

        // map responseStream into AnyCancellable
        let responseStream = responsePublisher
            .share() // return as class instance
            .receive(on: DispatchQueue.main) // specify that we want to receive publisher on main thread scheduler (for UI ops)
            .subscribe(self.responseSubject) // attach to an subject

        // map errorStream into AnyCancellable
        let errorStream = responsePublisher
            .catch { [weak self] error -> Publishers.Empty<[Splash], SplashError> in // catch `self.networkRequest.fetchListSignal()` event error
                self?.isLoading = false
                self?.errorMessage = error.message
                return Publishers.Empty()
            }
            .share() // return as class instance
            .receive(on: DispatchQueue.main) // specify that we want to receive publisher on main thread scheduler (for UI ops)
            .subscribe(self.errorSubject) // attach to `errorSubject`

        // attach `responseSubject` with closure handler, here we process `models` setter
        _ = self.responseSubject
            .sink { [weak self] in
                self?.isLoading = false
                self?.models = $0
            }

        // collect AnyCancellable subjects to discard later when `SplashViewModel` life cycle ended
        self.cancellables += [
            responseStream,
            errorStream
        ]
    }
}
