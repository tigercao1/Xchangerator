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
public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}
struct LoginView : View {
    @EnvironmentObject var stateStore: ReduxRootStateStore
    
    @State private var bottomViewState = CGSize(width: 0, height: screenHeight)
    @State private var mainViewState = CGSize.zero

    var body : some View {
        ZStack{
            ZStack {
// Bridge SwiftUI and UIkit
//https://stackoverflow.com/questions/58353243/firebaseui-and-swiftui-loging
                FUIAuthBaseViewControllerWrapper()
                VStack(alignment: .trailing, spacing: screenHeight*0.2){
                    HStack(alignment: .center){
                        Text("Build by YYES. with")
                            .fontWeight(.regular)
                            .foregroundColor(Color.blue)
                    Image(systemName:"heart.circle").foregroundColor(Color.blue)
                    }.padding(20).frame(width: screenWidth, height: screenHeight*0.85,
                        alignment: .bottom)
                }
                .animation(/*@START_MENU_TOKEN@*/.easeInOut/*@END_MENU_TOKEN@*/)
            }.offset(y: self.stateStore.curRoute == .auth ? self.mainViewState.height:self.bottomViewState.height).animation(.spring())
            ContentView().offset(y: self.stateStore.curRoute != .auth ? self.mainViewState.height:self.bottomViewState.height)//.animation(.spring()) //Anti-Shake, Spring() is too much
        }//.navigate(to: ContentView(), when: $willMoveToNextScreen)

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(ReduxRootStateStore())
    }
}
