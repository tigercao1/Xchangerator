//
//  AboutView.swift
//  Xchangerator
//
//  Created by Wenyue Deng on 2020-03-02.
//  Copyright © 2020 YYES. All rights reserved.
//

import SwiftUI

struct AboutView: View {
//    let links = ["LinkedIn", "Twitter"]

    var body: some View {
            VStack{
                CardView(image: "cover", category: Constant.xDesc, heading: "Xchangerator", author: "Exchange rate reminder - version 0.1")

                HStack{
                    Spacer(minLength: screenWidth*0.1)
                    Button(action: {
                          let url = URL(string: Constant.xLinkedIn)!
                          UIApplication.shared.open(url)
                         }) {
                            Text("LinkedIn").font(.subheadline)
                            
                    }.padding()
                    Spacer(minLength: screenWidth*0.1)
                    Button(action: {
                        let url = URL(string: Constant.xTwitter)!
                        UIApplication.shared.open(url)
                       }) {
                        Text("Twitter").font(.subheadline)
                        
                    }.padding()
                    Spacer(minLength: screenWidth*0.1)
                        
                }
                HStack(alignment: .center){
                    Text("Build by YYES. with")
                        .fontWeight(.regular)
                        .foregroundColor(Color.blue)
                    Image(systemName:"heart.circle").foregroundColor(Color.blue)
                }.padding(.bottom,20)

            }.navigationBarTitle(Text("About"), displayMode: .inline)
    }
    
}


struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
