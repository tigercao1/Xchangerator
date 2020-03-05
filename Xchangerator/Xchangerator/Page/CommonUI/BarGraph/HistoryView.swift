//
//  HistoryView.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-03-05.
//  Copyright © 2020 YYES. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
    var history: HistoryCell
    @EnvironmentObject var stateStore: ReduxRootStateStore
    
    @State private var showDetail = false
    @State var isHide = false

    
    var transition: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        let removal = AnyTransition.scale
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    var body: some View {
        Group{
            if (!self.isHide){
                VStack {
                        HStack {

                            Button(action: {
                                withAnimation {
                                    self.isHide.toggle()
                                }
                            }){
                                Image(systemName: "star.fill").foregroundColor(Color.yellow)
                                .imageScale(.large)
                                .rotationEffect(.degrees(isHide ? 90 : 0))
                                .scaleEffect(!isHide ? 1.5 : 0)
                            }.padding()
                            VStack(alignment: .leading) {
                                CountryHeadlineReadOnlyView(
                                            country: self.stateStore.countries.getModel()[history.id-1000] ,
                                            isEditable: false,
                                            showFromParent: false,
                                            barNumFromParent: "100"
                                        )
                            
                                CountryHeadlineReadOnlyView(
                                    country: self.stateStore.countries.getModel()[history.id-998] ,
                                    isEditable: false,
                                    showFromParent: false,
                                    barNumFromParent:String(history.distance*10)
                                )

                            }
                            
                            Spacer()
                            HistoryGraph(history: history, path: \.week)
                                .frame(width: 45, height: 30)
                                .animation(nil)
                            Button(action: {
                                withAnimation {
                                    self.showDetail.toggle()
                                }
                            }) {
                                Image(systemName: "chevron.right.circle")
                                    .imageScale(.large)
                                    .rotationEffect(.degrees(self.showDetail ? 90 : 0))
                                    .scaleEffect(showDetail ? 1.5 : 1)
                                    .padding()
                            }
                        }
                        //.padding(10)

                        if showDetail {
                            HistoryDetail(history: history)
                                .transition(transition)
                            }
                    
                }
            } else {
            }
        }
    }
}





struct CountryHeadlineReadOnlyView: View {
    var country: Country
//    var number: Float
    var isEditable : Bool
    var showFromParent:Bool
    var barNumFromParent:String

    var body: some View {
            HStack(){
                Text(country.flag)
                    .font( showFromParent ? Font.largeTitle : Font.subheadline)
                    .multilineTextAlignment(.center)
                    .frame(width: !showFromParent ? 15 : 40)
                    .padding()

                Text(barNumFromParent)
                    .font( showFromParent ? Font.title: Font.headline)
                    .frame(width: showFromParent ?   screenWidth*0.3 : 60)
            
                Text(country.unit)
                    .fontWeight(.bold)
                    .font( showFromParent ? Font.title : Font.subheadline)
            }
                .frame(width: showFromParent ? screenWidth*0.8 : screenWidth*0.2, alignment: .leading)
                .padding(.top, showFromParent ? 5 : 0)
                .padding(.bottom, showFromParent ? 5 : 0)
                .layoutPriority(100)
    }
}
struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE", "iPhone 11 Pro Max"],id: \.self) { deviceName in ContentView(selection:1).environmentObject(ReduxRootStateStore()).previewDevice(PreviewDevice(rawValue: deviceName))
        .previewDisplayName(deviceName)
        }
    }
}
