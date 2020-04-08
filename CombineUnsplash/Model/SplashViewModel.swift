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

final class SplashViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private var networkRequest = NetworkRequest()
    
    // MARK: - Binding
    
    internal let objectWillChange = ObservableObjectPublisher()
    private var cancellables = [AnyCancellable]()
    
    var state: State = .loading
    enum State {
        case loading
        case completed(response: [Splash])
        case failed(error: String)
    }
    
    var isLoading = true {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    var errorMessage = "" {
        didSet {
            self.state = .failed(error: self.errorMessage)
            self.objectWillChange.send()
        }
    }
    
    var models: [Splash] = [] {
        didSet {
            guard self.models != oldValue else { return }
            self.state = .completed(response: self.models)
            self.objectWillChange.send()
        }
    }
    
    deinit {
        self.cancellables.forEach { $0.cancel() } // cancel any ongoing signal chain (if any) on deinit
    }
    
    // MARK: - Public
    
    func fetchList() {
        self.networkRequest.fetchListSignal()
            .receive(on: DispatchQueue.main) // specify that we want to receive publisher on main thread scheduler (for UI ops)
            .mapError { SplashError.mappedFromRawError($0) } // map error signal
            .sink(receiveCompletion: { [weak self] (completion) in // completion will be trigger eventually (at the end of signal chain)
                defer { self?.isLoading = false } // finalize `isLoading` state
                
                switch completion {
                case .failure(let error):
                    // map error message value to `errorMessage` that will trigger `objectWillChange` signal
                    self?.errorMessage = error.message
                case .finished:
                    break
                }
                }, receiveValue: { [weak self] items in
                    // map response value to `models` that will trigger `objectWillChange` signal
                    self?.models = items
            })
            // `Stores this type-erasing cancellable instance in the specified collection.` that we will
            // cancel later on `deinit`
            .store(in: &self.cancellables)
    }
}
