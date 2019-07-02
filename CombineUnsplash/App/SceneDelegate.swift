//
//  SceneDelegate.swift
//  CombineUnsplash
//
//  Created by Vinh Nguyen on 8/6/19.
//  Copyright © 2019 Vinh Nguyen. All rights reserved.
//

import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let window = UIWindow(frame: UIScreen.main.bounds)

        let view = MainView()
        let viewModel = SplashViewModel()

        // NOTE: https://github.com/vinhnx/notes/issues/270
        // + use @EnvironmentObject if you want to pass data to another view hierarchy directly
        // + use @ObjectBinding to pass data from superview to nearest child view

        // NOTE: .environementObject() is required to supply a `BindableObject` (SplashViewModel)
        // to our `MainView`
        let rootView = view.environmentObject(viewModel)
        window.rootViewController = UIHostingController(rootView: rootView)
        
        self.window = window
        window.makeKeyAndVisible()
    }
}
