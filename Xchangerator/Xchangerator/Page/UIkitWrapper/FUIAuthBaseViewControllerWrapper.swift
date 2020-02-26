//
//  FUIAuthBaseViewControllerWrapper.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-02-10.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation
import FirebaseUI
import SwiftUI
import SwiftyJSON


// Bridge SwiftUI and UIkit
//https://stackoverflow.com/questions/58353243/firebaseui-and-swiftui-loging
struct FUIAuthBaseViewControllerWrapper: UIViewControllerRepresentable {
    func makeCoordinator() -> FUIAuthBaseViewControllerWrapper.Coordinator {
        Coordinator(self)
    }

//    typealias UIViewControllerType = UIViewController
    
    func dismiss(_ authDataResult: AuthDataResult?, _ error : Error? ) -> Void {
        guard let _ = error else {
            Logger.error("Err: Failed to sign in with user. User:\(String(describing: authDataResult));Error:\(String(describing: error)) " )
            return
        }

        guard let userJSONData = authDataResult else {
            Logger.warning("Failed to sign in with user.User: \(String(describing: authDataResult)) " )
            return
        }
        Logger.debug(userJSONData)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let authUI = FUIAuth.defaultAuthUI()

                 // You need to adopt a FUIAuthDelegate protocol to receive callback
        let providers: [FUIAuthProvider] = [
            FUIEmailAuth(),
            FUIGoogleAuth()
        ]
        authUI?.providers = providers
        authUI?.delegate = context.coordinator
        //Todo: Terms of Services
//        let xFirebaseTermsOfService = URL(string: "https://firebase.google.com/terms/")!
//        authUI?.tosurl = xFirebaseTermsOfService
//        let xFirebasePrivacyPolicy = URL(string: "https://policies.google.com/privacy")!
//        authUI?.privacyPolicyURL = xFirebasePrivacyPolicy

        let authViewController = authUI?.authViewController()
//        authUI.delegate = authViewController as? FUIAuthDelegate
        return authViewController!
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }

   //coordinator
    class Coordinator : NSObject, FUIAuthDelegate {
        var parent : FUIAuthBaseViewControllerWrapper

        init(_ customLoginViewController : FUIAuthBaseViewControllerWrapper) {
            self.parent = customLoginViewController
        }

        // MARK: FUIAuthDelegate
        func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?)
        {
//            parent.dismiss(authDataResult, error)
            guard error == nil else {
                Logger.error("Err: Failed to sign in with user. User:\(String(describing: authDataResult));Error:\(String(describing: error)) " )
                return
            }

            guard let userJSONData = authDataResult else {
                Logger.warning("User data corruption: \(String(describing: authDataResult)) " )
                return
            }
/*  Properties of  authDataResult.user  https://firebase.google.com/docs/reference/ios/firebaseauth/api/reference/Classes/FIRUser#providerdata
             anonymous:BOOL
             emailVerified:BOOL
             refreshToken:NSString
             providerData:NSArray https://firebase.google.com/docs/reference/ios/firebaseauth/api/reference/Protocols/FIRUserInfo.html
             FIRUserMetadata:metadata
 */
            Logger.debug("UserData: \(userJSONData.user.isEmailVerified) \(String(describing: userJSONData.additionalUserInfo))")
        }

        func authUI(_ authUI: FUIAuth, didFinish operation: FUIAccountSettingsOperationType, error: Error?)
        {
            Logger.debug("Finish\(operation)")
        }
//        // Todo: customize the login page
//        func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
//          return CustomAuthPickerViewController(authUI: authUI)
//        }
    }
}

