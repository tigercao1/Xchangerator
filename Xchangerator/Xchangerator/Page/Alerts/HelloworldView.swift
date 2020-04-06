//
//  helloworld.swift
//  Xchangerator
//
//  Created by Wenyue Deng on 2020-04-05.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation
import SwiftUI

struct HelloworldView: View {
    var body: some View {
        NavigationView{
            VStack{
                Text("Hello World")
            }
            .navigationBarTitle("Exchange Rates ")
        }
    }
}
