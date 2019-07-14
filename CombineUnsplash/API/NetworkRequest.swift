//
//  NetworkRequest.swift
//  CombineUnsplash
//
//  Created by Vinh Nguyen on 8/6/19.
//  Copyright © 2019 Vinh Nguyen. All rights reserved.
//

import Combine
import Foundation

final class NetworkRequest {

    typealias SplashPubliser = AnyPublisher<[Splash], SplashError>
    private var dataTask: URLSessionTask?
    private let backgroundQueue = DispatchQueue(label: "NetworkRequest.queue", qos: .background)

    deinit {
        self.dataTask?.cancel()
    }

    // MARK: - Public

    func fetchListSignal() -> SplashPubliser {
        guard let url = URLBuilder.buildListRequestURL() else {
            return Publishers.Empty().eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.addValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        return URLSession.shared
            .dataTaskPublisher(for: request) // 1. Foundation's URLSession now has dataTask `Publisher`

            /*
             process HTTP request's response data
             */
            .map { $0.data } // 2. we retrieve `data` from the Publisher's `Output` tuple
            .mapError(SplashError.mappedFromRawError) // 3. catch and map error that the dataTask `Publisher` emits

            /*
             decode response's data to model
             */
            .decode(type: [Splash].self, decoder: JSONDecoder()) // 4. Decode #3 data into array of `Splash` model
            .mapError(SplashError.jsonDecoderError) // 5. catch and map error from JSONDecoder

            /*
             dispatch completion
             */
            .subscribe(on: self.backgroundQueue) // process on background/private queue
            .receive(on: DispatchQueue.main) // send result on main queue

            /*
             because SplashPubliser type signature is AnyPublisher<[Splash], SplashError>
             and the publisher we received was from URLSession.shared.dataTaskPublisher
             so: URLSession.shared.dataTaskPublisher -> AnyPublisher<[Splash], SplashError>
             -> we use AnyPublisher to hide implementation details to outside, hence "type-erased"
             */
            .eraseToAnyPublisher()
    }
}
