//
//  AboutView.swift
//  Xchangerator
//
//  Created by Wenyue Deng on 2020-03-02.
//  Copyright © 2020 YYES. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            CardView(image: "cover", description: Constant.xDesc, title: "Xchangerator", version: "Exchange rate reminder - version 1.0")
            Spacer()

            HStack {
                Spacer(minLength: screenWidth * 0.1)
                Button(action: {
                    let url = URL(string: Constant.xLinkedIn)!
                    UIApplication.shared.open(url)
                         }) {
                    Text("LinkedIn").font(.headline)

                }.padding()
                Spacer(minLength: screenWidth * 0.1)
            }
            Spacer()
            HStack(alignment: .center) {
                Text("Built by YYES. with")
                    .fontWeight(.regular)
                    .foregroundColor(Color.blue)
                Image(systemName: "heart.circle").foregroundColor(Color.blue)
            }.padding(.bottom, 20)
            Spacer()

        }.navigationBarTitle(Text("About"), displayMode: .inline)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ConstantDevices.iPhoneSE, ConstantDevices.iPhone8], id: \.self) { deviceName in AboutView().environmentObject(ReduxRootStateStore()).previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
    }
}
