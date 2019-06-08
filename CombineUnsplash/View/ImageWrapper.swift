//
//  ImageWrapper.swift
//  CombineUnsplash
//
//  Created by Vinh Nguyen on 8/6/19.
//  Copyright © 2019 Vinh Nguyen. All rights reserved.
//

import Foundation
import SwiftUI

/// SwiftUI's `Image` doesn't have `Binding`, so we wrap UIImageView with `UIViewRepresentable` instead
/// to subscribe (or listen) to any data @Binding event
struct ImageWrapper: UIViewRepresentable {
    @Binding var data: Data?

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> UIImageView {
        UIImageView()
    }

    func updateUIView(_ imageView: UIImageView, context: Context) {
        guard let data = data else { return }
        imageView.image = UIImage(data: data)
    }
}
