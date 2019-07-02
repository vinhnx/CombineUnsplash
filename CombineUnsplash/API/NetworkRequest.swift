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
            .dataTaskPublisher(for: request)
            .map { $0.data }
            .mapError(SplashError.mappedFromRawError)
            .decode(type: [Splash].self, decoder: JSONDecoder())
            .mapError(SplashError.jsonDecoderError)
            .subscribe(on: self.backgroundQueue) // process on background/private queue
            .receive(on: DispatchQueue.main) // send result on main queue
            .eraseToAnyPublisher() // IMPORTANT
    }
}
