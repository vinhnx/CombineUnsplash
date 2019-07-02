//
//  URLBuilder.swift
//  CombineUnsplash
//
//  Created by Vinh Nguyen on 8/6/19.
//  Copyright © 2019 Vinh Nguyen. All rights reserved.
//

import Foundation
import UIKit

struct URLBuilder {
    static func build(_ urlString: String) -> URL {
        let https = "https://"
        if urlString.hasPrefix(https) {
            return URL(string: urlString)!
        }

        return URL(string: (https + urlString))!
    }

    static func buildListRequestURL() -> URL? {
        let comp = URLComponents(string: "https://picsum.photos/v2/list")
        return comp?.host == nil ? nil : comp?.url
    }
}
