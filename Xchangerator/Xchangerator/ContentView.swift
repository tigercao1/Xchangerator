//
//  ContentView.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-01-21.
//  Copyright © 2020 YYES. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            Text("Home View")
                .font(.title)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .padding()
                .tabItem {
                    VStack {
                        Image("first")
                        .resizable()
                        .frame(width: 100,
                               height: 100,
                               alignment: .center)
                        Text("Home")
                            .font(.title)
                    }
                }
                .tag(0)
            Text("Favorite View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Favorite")
                        .font(.title)
                    }
                }
                .tag(1)
            Text("Notification View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("first")
                        Text("Notification")
                    }
                }
                .tag(2)
            Text("Settings View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("second")
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
