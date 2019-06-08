//
//  NetworkRequest.swift
//  CombineUnsplash
//
//  Created by Vinh Nguyen on 8/6/19.
//  Copyright © 2019 Vinh Nguyen. All rights reserved.
//

import Foundation

final class NetworkRequest {

    // MARK: - Aliasing

    typealias SplashRequestResult = (Result<Data, SplashError>) -> Void

    // MARK: - Data

    private var dataTask: URLSessionTask?

    // MARK: - Life Cycle

    deinit {
        self.dataTask?.cancel()
    }

    // MARK: - Public

    func fetch(category: String, completion: @escaping SplashRequestResult) {
        let session = URLSession(configuration: .default)
        guard let url = URLBuilder.buildRequestURL(category) else {
            DispatchQueue.main.async {
                completion(.failure(.unableToMapRequestURL))
            }

            return
        }

        let request = URLRequest(url: url)
        self.dataTask = session.dataTask(with: request) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.mappedFromRawError(error)))
                }

                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }

                return
            }

            DispatchQueue.main.async {
                completion(.success(data))
            }
        }

        self.dataTask?.resume()
    }
}
