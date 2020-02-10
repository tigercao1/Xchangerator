//
//  LoginViewController.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-02-10.
//  Copyright © 2020 YYES. All rights reserved.
//
import Foundation
import SwiftUI
//import FirebaseCore
//import FirebaseFirestore
//import FirebaseFirestoreSwift
import FirebaseUI


struct LoginView: View {
    var body: some View {
        FUIAuthBaseViewControllerWrapper()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
