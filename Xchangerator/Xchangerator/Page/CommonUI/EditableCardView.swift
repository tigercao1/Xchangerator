//
//  SwiftUIView.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-03-03.
//  Copyright © 2020 YYES. All rights reserved.
//

import SwiftUI

struct EditableCardView: View {
    @State private var  show = false
    var country1: Country
    var country2: Country
    var conditionOperator: String
    var numBar: Float
    
//    private func convert(_ targetCurrencyUnit: String) -> String {
//        let amount = 1.0
//        let converter = Converter(stateStore.countries)
//        let convertedAmount = converter.convert(targetCurrencyUnit, amount)
//        return String(format:"%.2f",convertedAmount)
//    }
//
    
    var body: some View {
        VStack() {
            HStack(){
                Text(country1.flag)
                    .font(.largeTitle)
                    .frame(width: 50, height: 15)
                    .fixedSize()
                    .padding()
                Text("100")
                     .fixedSize()
                Text(country1.unit)
                    .frame(width: 50, alignment: .leading)
                    .font(.headline)
                    .fixedSize()
            }.foregroundColor(.white)
            .padding(.top, show ? 20 : 10)
            .padding(.bottom, show ? 10 : 0)
            .layoutPriority(100)
            
            Image(systemName: "arrow.up.arrow.down.circle").foregroundColor(.white)
                //                .aspectRatio(contentMode: .fit)
                
            HStack{
                Text(country2.flag)
                   .fontWeight(.bold)
                   .font(.largeTitle)
                    .padding()
                Text("1003")
                    .fixedSize()
                Text(country2.unit)
                    .frame(width: 50, alignment: .leading)
                    .font(.headline)
                    .fixedSize()
            }.foregroundColor(.white)
                .padding(.top, show ? 10 : 0)
                .padding(.bottom, show ? 20 : 0)
                .layoutPriority(100)
            
//            Divider()
             Text("Notify me when > 100 ")
                .font(show ? Font.title : Font.headline)
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
                    Image(systemName: show ? "slash.circle.fill" : "slash.circle").foregroundColor(Color(hue: 0.498, saturation: 0.609, brightness: 1.0))
                        .font(Font.title.weight(.semibold))
                        .imageScale(.small)
                   Text(show ? "Done" : "Edit")
                    .foregroundColor(Color(hue: 0.498, saturation: 0.609, brightness: 1.0))
                        .fontWeight(.bold)
                        .font(show ? Font.title : Font.headline)
                        .cornerRadius(5)
                }
            }
            .padding(.bottom, show ? 20 : 15)
                
            }
            .padding()
            .padding(.top, 15)
       .frame(width: show ? screenWidth*0.8 : screenWidth*0.7, height: show ? 420 : 300)
            .background(Color.blue)
            .cornerRadius(30)
            .animation(.spring())
        }
    
}

#if DEBUG
struct EditableCardView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(selection:2).environmentObject(ReduxRootStateStore())
    }
}
#endif
