//
//  AlertCardView.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-03-03.
//  Copyright © 2020 YYES. All rights reserved.
//

import SwiftUI
struct AlertCardView: View {
    var country1ForShort: String
    var country2ForShort: String
    var operatorAlert: String
    var numBar: Float
    
var body: some View {
    VStack {
        HStack {
            Text(country1ForShort)
                .font(.headline)
                .foregroundColor(.secondary)
            Image(systemName: "arrow.right.arrow.left")
//                .aspectRatio(contentMode: .fit)
            Text(country2ForShort)
                .font(.headline)
                .foregroundColor(.secondary)
        }
        HStack {
            VStack(alignment: .leading) {
                Text(">")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .frame(height:screenHeight*0.2)
                Text("\(numBar)")
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .lineLimit(3)
//                Text("author".uppercased())
//                    .font(.caption)
//                    .foregroundColor(.secondary)
            }.layoutPriority(100)

                Spacer()
            }
            .padding()
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
        )
        .padding([.top, .horizontal])
    }
}
