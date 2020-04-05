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
    @State var conditionOperator: String
    @State var numBar: String
    @State var disabled: Bool

    
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
                    Text("Notify Me When: ")
                        .fontWeight(.bold)
                        .padding(.top,3)
                       .font(Font.title)
                       .multilineTextAlignment(.center)
                       .animation(.spring())
                       .cornerRadius(0)
                       .lineLimit(.none)
                        
                    CountryHeadlineCardView(
                        country:country1 ,
                        isEditable: false,
                        showFromParent: $show ,
                        barNumFromParent: $numBar
                    )
                    Button(action: {
                        self.conditionOperator = self.conditionOperator == "LT" ? "GT" : "LT"
                             }){
                            Image(systemName: conditionOperator == "LT" ? "lessthan.circle.fill": "greaterthan.circle.fill")

                        .foregroundColor(.lightBlue).layoutPriority(200)
                    }.animation(.spring())

                    CountryHeadlineCardView(
                        country:country2 ,
                        isEditable: true,
                        showFromParent: $show,
                        barNumFromParent: $numBar
                    )
                }
                .foregroundColor(Color.white)
                .animation(.easeInOut)
            } else {
                ZStack{
                    HStack{
                        CountryHeadlineCardView(
                            country:country1 ,
                            isEditable: false,
                            showFromParent: $show ,
                            barNumFromParent: $numBar
                        )

                        CountryHeadlineCardView(
                            country:country2 ,
                            isEditable: true,
                            showFromParent: $show,
                            barNumFromParent: $numBar
                        )
                    }
                    Image(systemName: conditionOperator == "LT" ? "lessthan" : "greaterthan")
                        .foregroundColor(Color.white)
                        .frame(width: 15, height: 15)
                        .padding()
                        .layoutPriority(500)
                }.animation(.easeInOut)

            }
        
            HStack{
                Spacer()
                Button(action: {
                    self.disabled.toggle()
                }) {
                    HStack {
                        Image(systemName: disabled ? "bell.slash" : "bell.fill").foregroundColor(disabled ? Color.white: Color.lightBlue)
                            .font(Font.title.weight(.semibold))
                            .imageScale(.small)
                       Text(disabled ? "Disabled" : "Active")
                        .foregroundColor(disabled ? Color.white: Color(hue: 0.498, saturation: 0.609, brightness: 1.0))
                            .fontWeight(.bold)
                            .font(show ? Font.title : Font.headline)
                            .cornerRadius(5)
                    }
                }
                .padding(.bottom, show ? 20 : 15)
                Spacer()
                Button(action: {
                    self.show.toggle()
                }) {
                    HStack {
                        Image(systemName: show ? "slash.circle.fill" : "slash.circle")
                            .foregroundColor(Color.lightBlue)
                            .font(Font.title.weight(.semibold))
                            .imageScale(.small)
                       Text(show ? "Done" : "Edit")
                        .foregroundColor(Color.lightBlue)
                        .fontWeight(.bold)
                        .font(show ? Font.title : Font.headline)
                        .cornerRadius(5)
                    }
                }
                .padding(.bottom, show ? 20 : 15)
                Spacer()
            }
                
        }
        .padding()
        .padding(.top, 15)
        .frame(width: show ? screenWidth*0.85 : screenWidth*0.88, height: show ? 350 : 100)
        .background(disabled ? Color.gray : Color.blue)
        .cornerRadius(25)
        .animation(.spring())
    }
    
}


struct CountryHeadlineCardView: View {
    var country: Country
//    var number: Float
    var isEditable : Bool
    @Binding var showFromParent:Bool
    @Binding var barNumFromParent:String 

    var body: some View {
            HStack(){
                Text(country.flag)
                    .font( showFromParent ? Font.largeTitle : Font.subheadline)
                    .multilineTextAlignment(.center)
                    .frame(width: !showFromParent ? 20 : 40, height: 15)
                    .padding()
      
                if ( isEditable ){
                    TextField("Amount", text: $barNumFromParent)
//                            .underline(showFromParent)
                        .disabled(!showFromParent)
                        .font( showFromParent ? Font.title: Font.headline)
                        .frame(width: showFromParent ?   screenWidth*0.3 : 60)
                        .foregroundColor(showFromParent ? Color.lightBlue : Color.white )
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.leading)
                } else {
                    Text(String(100))
                        .font( showFromParent ? Font.title: Font.headline)
                        .frame(width: showFromParent ?   screenWidth*0.3 : 30)
                }
                Text(country.unit)
                    .fontWeight(.bold)
                    .font( showFromParent ? Font.title : Font.subheadline)
            }.foregroundColor(.white)
                .frame(width: showFromParent ? screenWidth*0.8 : screenWidth*0.40, alignment: .leading)
                .padding(.top, showFromParent ? 5 : 0)
                .padding(.bottom, showFromParent ? 5 : 0)
                .layoutPriority(100)
    }
}

extension Color {
    static let lightBlue =  Color(hue: 0.498, saturation: 0.609, brightness: 1.0)
}


#if DEBUG
struct EditableCardView_Previews : PreviewProvider {
    static var previews: some View {
          ForEach(["iPhone SE", "iPhone 11 Pro Max"],id: \.self) { deviceName in ContentView(selection:2).environmentObject(ReduxRootStateStore()).previewDevice(PreviewDevice(rawValue: deviceName))
          .previewDisplayName(deviceName)
        }
    }
}
#endif
