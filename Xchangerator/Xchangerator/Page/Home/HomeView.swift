//
//  HomeView.swift
//  Xchangerator
//
//  Created by Yizhang Cao on 2020-01-28.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @State private var baseCurrencyAmt: String = "100"
    @State private var baseCurrencyUnit: String = "CAD"
    
    func convert(_ targetCurrencyUnit: String) -> String {
        let amount = Double(baseCurrencyAmt) ?? 0
        // To be replaced by generic converter
        let convertedAmount = String(round(amount * 0.76 * 100)/100)
        // end of to be replaced
        return convertedAmount
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Text("🇨🇦")
                    .padding([.leading], 50)
                    .font(.largeTitle)
                TextField("Amount", text: $baseCurrencyAmt)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .fixedSize()
                    .frame(width: 170)
                Text(baseCurrencyUnit).padding(.trailing, 50)
            }
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.black, lineWidth: 0.5)
                ).padding()
            HStack {
                Text("🇺🇸")
                    .padding(.leading, 50)
                    .font(.largeTitle)
                Text(self.convert("USD"))
                    .frame(width: 170)
                    .multilineTextAlignment(.trailing)

                Text("USD").padding(.trailing, 50)
            }
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.black, lineWidth: 0.5)
                ).padding()
            
        }
    }
}
