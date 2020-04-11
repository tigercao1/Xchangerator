//
//  CardView.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-03-02.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation
import SwiftUI
struct CardView: View {
    var image: String
    var description: String
    var title: String
    var version: String

    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)

            HStack {
                VStack {
                    Text(description)
                        .font(.headline)
                        .fontWeight(.regular)
                        .foregroundColor(.secondary)
                        .frame(height: screenWidth * 0.35).padding(.bottom, 20)

                    Text(title)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                    Text(version.uppercased())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(8)
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150 / 255, green: 150 / 255, blue: 150 / 255, opacity: 0.1), lineWidth: 1)
        )
        .padding([.top, .horizontal])
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ConstantDevices.iPhoneSE, ConstantDevices.iPhone8], id: \.self) { deviceName in CardView(image: "cover", description: Constant.xDesc, title: "Xchangerator", version: "Exchange rate reminder - version 1.0")
        }
    }
}
