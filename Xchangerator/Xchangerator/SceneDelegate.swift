//
//  SceneDelegate.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-01-21.
//  Copyright © 2020 YYES. All rights reserved.
//

import FirebaseUI
import SwiftUI
import UIKit
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        let stateStore = ReduxRootStateStore() // state store init
        print("test isLogin", Auth.auth().currentUser != nil)

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            stateStore.isLandscape = (windowScene.interfaceOrientation.isLandscape == true)
            let window = UIWindow(windowScene: windowScene)

            // if user is logged in
            if let user = Auth.auth().currentUser {
                stateStore.curRoute = .content

                let userProfile = User_Profile(email: user.email ?? "New_\(user.uid)@Xchangerator.com", photoURL: user.photoURL, deviceTokens: [], name: user.displayName ?? "Loyal User")
                let userDoc = User_DBDoc(profile: userProfile)
                stateStore.setDoc(userDoc: userDoc)
            }

            stateStore.setCountries(countries: ApiCall())

            window.rootViewController = UIHostingController(rootView: LoginView().environmentObject(stateStore))
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    // added this function to register when the device is rotated
    func windowScene(_ windowScene: UIWindowScene, didUpdate previousCoordinateSpace: UICoordinateSpace, interfaceOrientation previousInterfaceOrientation: UIInterfaceOrientation, traitCollection previousTraitCollection: UITraitCollection) {
//        stateStore.isLandscape.toggle()
//        Logger.debug("stateStore.isLandscape:\(stateStore.isLandscape)")
    }
}
