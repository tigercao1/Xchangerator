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
    @EnvironmentObject var stateStore: ReduxRootStateStore
    @Binding var selectionFromParent: Int

    var settingItems: [SettingItem] = [
        SettingItem(image: "person", text: "Profile"),
//    SettingItem(image: "envelope", text: "Notification"), //todo: recover it later
        SettingItem(image: "exclamationmark.circle", text: "About"),
    ]

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
                }.frame(height: 120)

                Spacer()
                VStack {
                    Button(action: self.signOut) {
                        HStack {
                            Image(systemName: "escape")
                                .font(.headline)
                                .padding(.trailing, 5)
                            Text("Sign Out")
                                .fontWeight(.semibold)
                                .font(.subheadline)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 18)
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(UIColor(0x448AFF)), Color(UIColor(0x4A75EA))]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(20)
                    }
                }.padding(.bottom, 30)
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
        ForEach(["iPhone SE", "iPhone 8"], id: \.self) { deviceName in ContentView(selection: 3).environmentObject(ReduxRootStateStore()).previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
    }
}
