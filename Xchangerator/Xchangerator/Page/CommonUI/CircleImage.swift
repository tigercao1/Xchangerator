//
//  CircleImage.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-02-26.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation
import SwiftUI

struct CircleImage: View {
    var image: Image

    var body: some View {  //.scaledToFit()
        image.resizable().aspectRatio(1, contentMode: .fill)
        .frame(width: 200, height: 200)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
    }
}

struct CircleImage_Preview: PreviewProvider {
    static var previews: some View {
        CircleImage(image:Image("cover"))
    }
}

