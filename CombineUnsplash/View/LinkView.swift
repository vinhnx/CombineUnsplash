//
//  LinkView.swift
//  CombineUnsplash
//
//  Created by Vinh Nguyen on 7/2/19.
//  Copyright © 2019 Vinh Nguyen. All rights reserved.
//

import Combine
import Foundation
import LinkPresentation
import SwiftUI

struct LinkView: UIViewRepresentable {
    var data: LPLinkMetadata

    func makeUIView(context: Context) -> LPLinkView {
        LPLinkView(metadata: self.data)
    }

    func updateUIView(_ view: LPLinkView, context: Context) {
        view.metadata = self.data
    }
}

final class LinkPreviewData: ObservableObject {
    let didChange = PassthroughSubject<LPLinkMetadata, Never>()
    var metadata = LPLinkMetadata() {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self.metadata)
            }
        }
    }

    func fetch(_ urlString: String) {
        let url = URLBuilder.build(urlString)
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url) { metadata, error in
            guard error == nil else { return }
            guard let metadata = metadata else { return }
            self.metadata = metadata
        }
    }
}
