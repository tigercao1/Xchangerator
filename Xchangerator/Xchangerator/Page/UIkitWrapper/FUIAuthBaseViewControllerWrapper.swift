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
              let authUI = FUIAuth.defaultAuthUI()
                 // You need to adopt a FUIAuthDelegate protocol to receive callback
                 let providers: [FUIAuthProvider] = [
                     FUIEmailAuth(),
                     FUIGoogleAuth()
                 ]
                 authUI!.providers = providers
         //        let authViewController = authUI?.authViewController()

        let authViewController = (authUI?.authViewController())!
        authUI?.delegate = authViewController as? FUIAuthDelegate
        return authViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<FUIAuthBaseViewControllerWrapper>) {
        
    }
}
