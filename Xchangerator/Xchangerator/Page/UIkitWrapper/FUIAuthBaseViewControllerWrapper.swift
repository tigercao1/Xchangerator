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

struct FUIAuthBaseViewControllerWrapper: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIViewController

    func makeUIViewController(context: UIViewControllerRepresentableContext<FUIAuthBaseViewControllerWrapper>) -> UIViewController {
        guard let authUI = FUIAuth.defaultAuthUI() else {
            Logger.error("FUIAuth init failed ")
            return UIViewController()
        }
                 // You need to adopt a FUIAuthDelegate protocol to receive callback
        let providers: [FUIAuthProvider] = [
            FUIEmailAuth(),
            FUIGoogleAuth()
        ]
        authUI.providers = providers

        let authViewController = authUI.authViewController()
        authUI.delegate = authViewController as? FUIAuthDelegate
        
        return authViewController
    }
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
//        if let _ = error {
//            let alert = Alert(title: Text("Sign in failed"), message: Text("\(error)"), dismissButton: .default(Text("Got it!")))
//            self.present(alert, animated: true, completion: nil)
//
//        }
//        Logger.debug(user? 'xxxx' )
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<FUIAuthBaseViewControllerWrapper>) {
        
    }
}
