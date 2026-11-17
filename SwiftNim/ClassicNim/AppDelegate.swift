//
//  AppDelegate.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/3/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        true
    }

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default", sessionRole: connectingSceneSession.role)
    }
}

/// iOS 27 requires the UIScene lifecycle. The window and root view controller
/// come from Main.storyboard via the scene manifest in Info.plist.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
}
