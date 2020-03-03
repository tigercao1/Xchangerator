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
        NavigationView{
            Text("Something about this app").edgesIgnoringSafeArea(.top)
            .navigationBarTitle("About")
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
