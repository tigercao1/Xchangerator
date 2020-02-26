//
//  Settings.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-02-26.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation
import FirebaseUI
import SwiftUI
import CoreLocation

struct Settings: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var stateStore: ReduxRootStateStore

//    @State private var user: User_Profile


//    let uid = user.uid
//    let email = user.email
    // providerID
    //displayName
    //photoURL
    //phonenumber
    
    private func signOut() {
        do {
            try FUIAuth.defaultAuthUI()!.signOut()
        } catch {
            Logger.error(error)
            return
        }
        self.stateStore.curRoute = .auth
    }
    
 //https://developer.apple.com/tutorials/swiftui/building-lists-and-navigation
    var body: some View {
             VStack{
//
//                        MapView(coordinate: CLLocationCoordinate2D(
//                                          latitude: -116.166868,
//                                          longitude: 34.011286))        .edgesIgnoringSafeArea(.top)
//                            .frame(height: 300)
                Spacer()
                ImageView(withURL:stateStore.user.profile.photoURL! )
                    .frame(width:100, height:100).clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                    .padding(.vertical, screenHeight*0.15)
                    .frame(width: 200, height: screenHeight/4).edgesIgnoringSafeArea(.top)
                    
                Spacer()
                VStack(alignment: .leading) {
                    Text(stateStore.user.profile.name)
                        .font(.title)

                    HStack(alignment: .top) {
                        Text(stateStore.user.profile.email)
                            .font(.subheadline)
                        Spacer()
                    Text(String(describing:stateStore.user.profile.photoURL!))
                        .font(.subheadline)
                    }.onAppear {
                        Logger.debug( String(describing:self.stateStore.user.profile.photoURL!)
                        )
                    }
                }
                .padding()
                
                Spacer()
                Button(action: self.signOut){
                    HStack {
                        Image(systemName: "escape")
                            .font(.title).padding(.horizontal,20)
                        Text("SignOut")
                            .fontWeight(.semibold)
                            .font(.headline)
                    }
                    .frame(minWidth: 0, maxWidth: screenWidth*0.6)
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(30)
                    .padding(.horizontal, CGFloat(20))
                }.padding()

                        
         }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
