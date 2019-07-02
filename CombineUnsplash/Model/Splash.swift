//
//  Splash.swift
//  CombineUnsplash
//
//  Created by Vinh Nguyen on 7/2/19.
//  Copyright © 2019 Vinh Nguyen. All rights reserved.
//

import Foundation
import SwiftUI

typealias TopLevel = [Splash]

struct Splash: Codable, Hashable, Identifiable {
    let id, width, height: Int
    let author, url, downloadURL: String

    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id).toInt
        self.width = try container.decode(Int.self, forKey: .width)
        self.height = try container.decode(Int.self, forKey: .height)
        self.author = try container.decode(String.self, forKey: .author)
        self.url = try container.decode(String.self, forKey: .url)
        self.downloadURL = try container.decode(String.self, forKey: .downloadURL)
    }
}

extension String {
    var toInt: Int {
        return Int(self) ?? 0
    }
}

extension Int {
    var toString: String {
        return String(self)
    }
}

// MARK: Convenience initializers

extension Splash {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Splash.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Array where Element == TopLevel.Element {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(TopLevel.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
