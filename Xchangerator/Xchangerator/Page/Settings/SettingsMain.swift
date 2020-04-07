//
//  SettingsMain.swift
//  Xchangerator
//
//  Created by Wenyue Deng on 2020-03-02.
//  Copyright © 2020 YYES. All rights reserved.
//

import CoreLocation
import FirebaseUI
import Foundation
import SwiftUI

struct SettingItem: Identifiable {
    var id = UUID()
    var image: String
    var text: String
}

struct SettingsMain: View {
    @Binding var selectionFromParent: Int

    var settingItems: [SettingItem] = [
        SettingItem(image: "person", text: "Profile"),
        SettingItem(image: "envelope", text: "Notification"),
        SettingItem(image: "exclamationmark.circle", text: "About"),
    ]
    @EnvironmentObject var stateStore: ReduxRootStateStore

    private func signOut() {
        do {
            try FUIAuth.defaultAuthUI()!.signOut()
        } catch {
            Logger.error(error)
            return
        }
        stateStore.resetRoute()
        selectionFromParent = 0
    }

    var body: some View {
        NavigationView {
            VStack {
                List(settingItems) { settingItem in
                    NavigationLink(destination: SettingDetailView(settingItem: settingItem)) {
                        Image(systemName: settingItem.image).font(.headline)
                            .padding()
                        Text(settingItem.text).font(.headline)
                        Spacer()
                    }
                }

                Spacer()
                Button(action: self.signOut) {
                    HStack {
                        Image(systemName: "escape")
                            .font(.title).padding(.horizontal, 20)
                        Text("Sign Out")
                            .fontWeight(.semibold)
                            .font(.headline)
                    }
                    .frame(minWidth: 0, maxWidth: screenWidth * 0.6)
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(30)
                    .padding(.horizontal, CGFloat(20))

                }.padding()
                Spacer()
            }.navigationBarTitle("Settings")
        }
    }
}

struct SettingDetailView: View {
    var settingItem: SettingItem
    var body: some View {
        VStack {
            if settingItem.text == "Profile" {
                Settings()
            } else if settingItem.text == "Notification" {
                NotificationView()
            } else {
                AboutView()
            }
        }
    }
}

struct SettingsMain_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ReduxRootStateStore())
    }
}
