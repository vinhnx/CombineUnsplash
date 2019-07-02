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
        window.rootViewController = UIHostingController(
            // NOTE: https://github.com/vinhnx/notes/issues/270
            // + use @EnvironmentObject if you want to pass data to another view hierarchy directly
            // + use @ObjectBinding to pass data from superview to nearest child view
            // here, because `SplashViewModel` is declared as @EnvironmentObject as we want to pass to it directly
            rootView: MainView().environmentObject(SplashViewModel())
        )

        self.window = window
        window.makeKeyAndVisible()
    }
}
