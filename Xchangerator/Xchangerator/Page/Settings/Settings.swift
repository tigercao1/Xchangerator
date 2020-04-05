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
import URLImage

struct Settings: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var stateStore: ReduxRootStateStore

    
 //https://developer.apple.com/tutorials/swiftui/building-lists-and-navigation
    var body: some View {
        VStack {
            Spacer().frame(height: screenHeight*0.01)
            Spacer()
            
            SettingsAvt(url:stateStore.user.profile.photoURL)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
                .padding(.vertical, screenHeight*0.15)
                .frame(width: 200, height: screenHeight/4).edgesIgnoringSafeArea(.top)
                    
            VStack {
                Text(stateStore.user.profile.name)
                    .font(.title)
                Spacer().frame(height: screenHeight*0.02)
                
                Text(stateStore.user.profile.email)
                    .font(.subheadline).padding(.top)
                
            }
            .padding()
            
            Spacer()
            
        }.navigationBarTitle(Text("Profile"), displayMode: .automatic)
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ReduxRootStateStore())
    }
}
extension Color {
    static let themeBlueGreenMixed =  LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .leading, endPoint: .trailing)
}


struct SettingsAvt: View {
    var url:URL?
    var body: some View {
        guard let photoURL = url else {
            return
                AnyView(Image(systemName:"person")
                .font(.title)
                .frame(width:100, height:100))
        }
        return AnyView(
                URLImage(photoURL) { proxy in
                    proxy.image
                    .resizable()                     // Make image resizable
                    .aspectRatio(contentMode: .fill) // Fill the frame
                    .clipped()
                    
                }.frame(width:150, height:150)
                // Clip overlaping parts
                
            )
        
            
    }

}
