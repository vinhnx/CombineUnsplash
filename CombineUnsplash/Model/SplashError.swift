//
//  Splash.swift
//  CombineUnsplash
//
//  Created by Vinh Nguyen on 8/6/19.
//  Copyright © 2019 Vinh Nguyen. All rights reserved.
//

import Foundation
import SwiftUI

enum SplashError: Error {
    case invalidRequestURL
    case invalidResponse
    case invalidData
    case invalidMetadata
    case unableToRetriveImageLocation
    case unableToMapRequestURL
    case mappedFromRawError(Error)
    case jsonDecoderError(Error)
}

extension SplashError {
    var message: String {
        switch self {
        case .invalidMetadata:
            return "Invalid metadata"
        case .invalidRequestURL:
            return "Invalid request URL"
        case .invalidData:
            return "Invalid data"
        case .unableToMapRequestURL:
            return "Unable to map request URL"
        case .invalidResponse:
            return "Invalid response"
        case .unableToRetriveImageLocation:
            return "Unable to retrive image location"
        case .mappedFromRawError(let error),
             .jsonDecoderError(let error):
            return error.localizedDescription
        }
    }
}

extension SplashError: LocalizedError {
    var localizedDescription: String {
        return "[ERROR] \(self.message)"
    }
}
