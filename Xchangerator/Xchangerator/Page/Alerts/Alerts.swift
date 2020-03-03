//
//  Alerts.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-02-26.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation
import FirebaseUI
import SwiftUI
import CoreLocation
import MapKit

//get current location
//https://www.raywenderlich.com/5247-core-location-tutorial-for-ios-tracking-visited-locations
struct Alerts: View {
    @State var show = false

    var body: some View {
        NavigationView{
            VStack() {
                     Text("CAN ")
                         .foregroundColor(.white)
                         .fontWeight(.bold)
                         .font(.largeTitle)
                         .padding(.top, show ? 30 : 20)
                         .padding(.bottom, show ? 20 : 0)
                     
                     Text("Animatable cards with Spring, custom frame and some paddings. Also use SFSymbol for icon in the bottom button. Tap to button fo see fill style of this icon.")
                         .foregroundColor(.white)
                         .multilineTextAlignment(.center)
                         .animation(.spring())
                         .cornerRadius(0)
                         .lineLimit(.none)
                     
                     Spacer()
                     
                     Button(action: {
                         self.show.toggle()
                     }) {
                         HStack {
                             Image(systemName: show ? "slash.circle.fill" : "slash.circle")
                                 .foregroundColor(Color(hue: 0.498, saturation: 0.609, brightness: 1.0))
                                 .font(Font.title.weight(.semibold))
                                 .imageScale(.small)
                             Text(show ? "Edit" : "Done")
                                 .foregroundColor(Color(hue: 0.498, saturation: 0.609, brightness: 1.0))
                                 .fontWeight(.bold)
                                 .font(.title)
                                 .cornerRadius(0)
                         }
                     }
                     .padding(.bottom, show ? 20 : 15)
                     
                 }
                 .padding()
                 .padding(.top, 15)
            .frame(width: show ? screenWidth*0.8 : screenWidth*0.7, height: show ? 420 : 260)
                 .background(Color.blue)
                 .cornerRadius(30)
                 .animation(.spring())
             }.navigationBarTitle(Text("Alerts"))//
        
    }
}

#if DEBUG
struct Alerts_Previews : PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ReduxRootStateStore())
    }
}
#endif
