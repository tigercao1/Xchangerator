//
//  ImageLoader.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-02-26.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation
import SwiftUI
//https://dev.to/gualtierofr/remote-images-in-swiftui-49jp
class ImageLoader: ObservableObject {
    @Published var dataIsValid = false
    var data:Data?
    
    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
    init(urlObj:URL) {
        let task = URLSession.shared.dataTask(with: urlObj) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}
func imageFromData(_ data:Data) -> UIImage {
    UIImage(data: data) ?? UIImage()
}
struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
//    @State var image:Image = Image(systemName: "centsign.circle")
    @State var withCircle:Bool = false



    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
//        withCircle = isCircle
    }

    init(withURL url:URL) {
        imageLoader = ImageLoader(urlObj:url)
//        withCircle = isCircle
    }
    var body: some View {
        Image(uiImage: imageLoader.dataIsValid ? imageFromData(imageLoader.data!) : UIImage()).resizable().aspectRatio(contentMode: .fit)
    }
}


