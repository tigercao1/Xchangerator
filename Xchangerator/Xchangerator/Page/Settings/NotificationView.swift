//
//  NotificationView.swift
//  Xchangerator
//
//  Created by Wenyue Deng on 2020-03-02.
//  Copyright © 2020 YYES. All rights reserved.
//

import SwiftUI

struct NotificationView: View {
    @State private var turnOnNotification: Bool = false
    @State private var turnOnSound: Bool = false
    @State private var turnOnIconBadge: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: self.$turnOnNotification) {
                HStack {
                    Text("Turn on notification")
                        .padding()
                }
            }.padding()
            Toggle(isOn: self.$turnOnSound) {
                HStack {
                    Text("Enable notification sound")
                        .padding()
                }
            }.padding()
            Toggle(isOn: self.$turnOnIconBadge) {
                HStack {
                    Text("Display red dot in top right of the icon")
                        .padding()
                }
            }.padding()
        }.navigationBarTitle(Text("Notification"), displayMode: .automatic).edgesIgnoringSafeArea(.top)
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
