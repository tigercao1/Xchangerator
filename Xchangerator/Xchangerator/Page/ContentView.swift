//
//  ContentView.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-01-21.
//  Copyright © 2020 YYES. All rights reserved.
//  Authors: Yizhang Cao

import SwiftUI

struct ContentView: View {
    @State var selection = 0
    var body: some View {
        TabView(selection: $selection){
            HomeView()
                .tabItem {
                    VStack {
                        Image(systemName:"house")
                        Text("Home")
                            .font(.title)
                    }
                }
                .tag(0)
            FavoriteView()
                .tabItem {
                    VStack {
                        Image(systemName:"heart.circle")
                        Text("Favorite")
                        .font(.title)
                    }
                }
                .tag(1)
            Alerts()
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName:"exclamationmark.bubble")
                        Text("Alerts")
                    }
                }
                .tag(2)
            SettingsMain(selectionFromParent: $selection)
                .tabItem {
                    VStack {
                        Image(systemName:"gear")
                        Text("Settings")
                    }
                }
                .tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
