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
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @State private var viewState = CGSize(width: 0, height: screenHeight)
    @State private var MainviewState = CGSize.zero

    var body : some View {
        ZStack{
            ZStack {
// Bridge SwiftUI and UIkit
//https://stackoverflow.com/questions/58353243/firebaseui-and-swiftui-loging
                FUIAuthBaseViewControllerWrapper().offset(y: self.MainviewState.height).animation(.spring())
                VStack(alignment: .center, spacing: screenHeight*0.3){
                    Image(colorScheme == .light ? "default-monochrome-black":"default-monochrome").padding(.top, screenHeight*0.3).padding(.horizontal, 10).offset(y:-screenWidth/3)//
                    HStack{
                        Text("Build by Team YYES. with")
                            .fontWeight(.regular)
                            .foregroundColor(Color.blue)
                    Image(systemName:"heart.circle").foregroundColor(Color.pink)

                    }.offset(y:screenWidth*0.15).padding(.bottom,10)
                }
                
            }
            ContentView().offset(y: self.viewState.height).animation(.spring())//environmentObject(DataStore()).
        }

    }

    func status() {
        self.viewState = CGSize(width: 0, height: 0)
        self.MainviewState = CGSize(width: 0, height: screenHeight)
    }
}
//struct LoginView: View {
//    var body: some View {
//        FUIAuthBaseViewControllerWrapper()
//    }
//}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
