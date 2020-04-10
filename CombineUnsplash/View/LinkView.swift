//
//  LinkView.swift
//  CombineUnsplash
//
//  Created by Vinh Nguyen on 7/2/19.
//  Copyright © 2019 Vinh Nguyen. All rights reserved.
//

import Combine
import UIKit
import SwiftUI
import LinkPresentation

struct LinkView: UIViewRepresentable {
    var data: LPLinkMetadata

    func makeUIView(context: Context) -> LPLinkView {
        LPLinkView(metadata: self.data)
    }

    func updateUIView(_ view: LPLinkView, context: Context) {
        view.metadata = self.data
    }
}
