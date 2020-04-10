//
//  SplashViewModel.swift
//  CombineUnsplash
//
//  Created by Vinh Nguyen on 8/6/19.
//  Copyright © 2019 Vinh Nguyen. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

final class MainViewViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private var networkRequest = NetworkRequest()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Binding

    // NOTE: @Published is a wrapper for `.objectWillChange`, and with it, we don't need to call
    // `self.objectWillChange.send()` manually on property's willSet/didSet
    // reference: https://twitter.com/luka_bernardi/status/1155944329363349504
    @Published var isLoading = true
    @Published var errorMessage = ""
    @Published var models = [Splash]()

    // MARK: - Public
    
    func fetchList() {
        self.networkRequest.fetchListSignal()

            .receive(on: DispatchQueue.main) // specify that we want to receive publisher on main thread scheduler (for UI ops)

            .mapError { SplashError.mappedFromRawError($0) } // map any error signal from `fetchListSignal` Publisher

            .sink(receiveCompletion: { [weak self] (completion) in // completion will be trigger eventually (at the end of signal chain)
                defer { self?.isLoading = false } // finalize `isLoading` state
                
                switch completion {
                case .failure(let error):
                    // map error message value to `errorMessage` that will trigger `objectWillChange` signal
                    let errorMessage = error.message
                    self?.errorMessage = errorMessage
                    print(errorMessage)
                case .finished:
                    break
                }
                
            }, receiveValue: { [weak self] items in
                // map response value to `models` that will trigger `objectWillChange` signal
                self?.models = items
            })

            // `Stores this type-erasing cancellable instance in the specified collection.` that we will
            // cancel later on `deinit`
            // reference: https://www.apeth.com/UnderstandingCombine/start/startpublishandsubscribe.html
            .store(in: &self.cancellables)
    }
}
