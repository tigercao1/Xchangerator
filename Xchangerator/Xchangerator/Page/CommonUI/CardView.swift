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
    var category: String
    var heading: String
    var author: String
    
var body: some View {
    VStack {
        Image(image)
            .resizable()
            .aspectRatio(contentMode: .fit)

        HStack {
            VStack(alignment: .leading) {
                Text(category)
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .frame(height:screenHeight*0.2)
                Text(heading)
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .lineLimit(3)
                Text(author.uppercased())
                    .font(.caption)
                    .foregroundColor(.secondary)
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
