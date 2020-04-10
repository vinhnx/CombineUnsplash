//
//  LinkPreviewMetadata.swift
//  CombineUnsplash
//
//  Created by Vinh Nguyen on 4/10/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import Foundation
import Combine
import LinkPresentation

final class DetailViewModel: ObservableObject {
    // NOTE: @Published is a wrapper for `.objectWillChange`, and with it, we don't need to call
    // `self.objectWillChange.send()` manually on property's willSet/didSet
    // reference: https://twitter.com/luka_bernardi/status/1155944329363349504
    @Published var metadata: LPLinkMetadata?

    typealias FetchLinkMetadataCompletion = (Result<LPLinkMetadata, SplashError>) -> Void
    private var cancellables = Set<AnyCancellable>()
    private var urlString: String

    init(urlString: String) {
        self.urlString = urlString
    }

    func fetch(completion: @escaping FetchLinkMetadataCompletion) {
        let url = URLBuilder.build(self.urlString)
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url) { metadata, error in
            if let error = error {
                completion(.failure(.mappedFromRawError(error)))
                return
            }

            guard let metadata = metadata else {
                completion(.failure(.invalidMetadata))
                return
            }

            completion(.success(metadata))
        }
    }

    func handleFetchSignal() {
        // handle and wrap fetch completion with `Future` to create a Publisher
        // https://www.vadimbulavin.com/asynchronous-programming-with-future-and-promise-in-swift-with-combine-framework/
        let future = Future<LPLinkMetadata, SplashError> { [weak self] promise in
            self?.fetch { (result) in
                switch result {
                case .failure(let error):
                    promise(.failure(error))
                case .success(let response):
                    promise(.success(response))
                }
            }
        }.eraseToAnyPublisher()

        future
            .receive(on: DispatchQueue.main) // IMPORTANT: dispatch values on main thread
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error): print(error)
                case .finished: break
                }
            }, receiveValue: { metadata in
                self.metadata = metadata
            })
            .store(in: &self.cancellables)
    }
}
