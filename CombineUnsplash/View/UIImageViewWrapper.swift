//
//  UIImageViewWrapper.swift
//  CombineUnsplash
//
//  Created by Vinh Nguyen on 8/6/19.
//  Copyright © 2019 Vinh Nguyen. All rights reserved.
//

import Foundation
import SwiftUI

/// (Earlier I was not yet knew how to bind @Binding with SwiftUI's `Image`, turns out we just need
/// to create an instance of `View` and return `Image` inside its body -- see ImageView.swift)
///
/// -- So this part is now obsolete, as we should use SwiftUI as much for possible for low UIKit
/// overhead, I keep these an example for how to use UIKit component in SwiftUI binding system
/// wrap UIImageView with `UIViewRepresentable` instead
/// to subscribe (or listen) to any data @Binding event
/// --
struct UIImageViewWrapper: UIViewRepresentable {
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
