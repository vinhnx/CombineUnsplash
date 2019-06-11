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
    static func buildRequestURL(_ category: String) -> URL? {
        // https://source.unsplash.com/{width}x{height}/?{urlString}
        var components = URLComponents(string: "https://source.unsplash.com/500x500/")
        components?.query = category
        return components?.url
    }
}
