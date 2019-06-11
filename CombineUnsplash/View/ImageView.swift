//
//  ImageView.swift
//  CombineUnsplash
//
//  Created by Vinh Nguyen on 9/6/19.
//  Copyright © 2019 Vinh Nguyen. All rights reserved.
//

import Foundation
import SwiftUI

/// Custom ImageView instance with binding for incoming data
struct ImageView: View {
    @Binding var data: Data?
    @State private var zoom: Bool = false

    var body: some View {
        // TODO: make this prettier
        Image(uiImage: UIImage(data: $data.value ?? Data()) ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: zoom ? .fill : .fit)
            .tapAction {
                withAnimation {
                    self.zoom.toggle()
                }
            }
    }
}
