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
    @State private var  disabled = false
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
            
            if (show) {
                VStack(){
                    Text("Notify me when: ")
                        .fontWeight(.bold)
                       .font(Font.title)
                       .multilineTextAlignment(.center)
                       .animation(.easeInOut)
                       .cornerRadius(0)
                       .lineLimit(.none)
                        
                    CountryHeadlineCardView(country:country1 ,number: 100, showFromParent: $show)
                    
                    Image(systemName: conditionOperator == "LT" ? "less" : "greaterthan").foregroundColor(.white)
                    CountryHeadlineCardView(country:country2 ,number: numBar, showFromParent: $show)
                }
                .foregroundColor(Color.gray)
                .animation(.easeInOut)
            } else {
                HStack{
                    CountryHeadlineCardView(country:country1 ,number: 100, showFromParent: $show)
                    Image(systemName: conditionOperator == "LT" ? "less" : "greaterthan").foregroundColor(.white)
                    CountryHeadlineCardView(country:country2 ,number: numBar, showFromParent: $show)
                }.animation(.easeInOut)

            }
        
            HStack{
                Button(action: {
                    self.disabled.toggle()
                }) {
                    HStack {
                        Image(systemName: disabled ? "bell.slash" : "bell.fill").foregroundColor(Color(hue: 0.498, saturation: 0.609, brightness: 1.0))
                            .font(Font.title.weight(.semibold))
                            .imageScale(.small)
                       Text(disabled ? "Disable" : "Activate")
                        .foregroundColor(Color(hue: 0.498, saturation: 0.609, brightness: 1.0))
                            .fontWeight(.bold)
                            .font(show ? Font.title : Font.headline)
                            .cornerRadius(5)
                    }
                }
                .padding(.bottom, show ? 20 : 15)
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
                
        }
        .padding()
        .padding(.top, 15)
        .frame(width: show ? screenWidth*0.9 : screenWidth*0.85, height: show ? screenHeight*0.3 : screenHeight*0.1)
        .background(disabled ? Color.gray : Color.blue)
        .cornerRadius(25)
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
struct CountryHeadlineCardView: View {
    var country: Country
    var number: Float
    @Binding var showFromParent:Bool
    var body: some View {
            HStack(){
                Text(country.flag)
                        .font( showFromParent ? Font.largeTitle : Font.subheadline)
                        .frame(height: 15)
                        .padding()
                Text(String(format: "%.2f", number))                      .font( showFromParent ? Font.title : Font.subheadline)
//                         .fixedSize()
                Text(country.unit)
                        .fontWeight(.bold)
                        .font( showFromParent ? Font.title : Font.subheadline)
//                        .frame(width: screenWidth*0.2, height: 15)
                }.foregroundColor(.white)
                .frame(width: showFromParent ? screenWidth*0.6 : screenWidth*0.4, alignment: .leading)
                .padding(.top, showFromParent ? 5 : 0)
                .padding(.bottom, showFromParent ? 5 : 0)
                .layoutPriority(100)
    }
}
