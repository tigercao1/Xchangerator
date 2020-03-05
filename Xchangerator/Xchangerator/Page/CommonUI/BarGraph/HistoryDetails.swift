//
//  HistoryDetails.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-03-05.
//  Copyright © 2020 YYES. All rights reserved.
//


import SwiftUI

struct HistoryDetail: View {
    let history: HistoryCell
    
    @State var dataToShow = \HistoryCell.Observation.week
    
    var buttons = [
        ("Weekly", \HistoryCell.Observation.week),
        ("Monthly", \HistoryCell.Observation.month),
        ("Annual", \HistoryCell.Observation.year),
    ]
    
    var body: some View {
        return VStack {
            HistoryGraph(history: history, path: dataToShow)
                .frame(height: screenHeight*0.11)
            
            HStack(spacing: 25) {
                ForEach(buttons, id: \.0) { value in
                    Button(action: {
                        self.dataToShow = value.1
                    }) {
                        Text(value.0)
                            .font(.system(size: 15))
                            .foregroundColor(value.1 == self.dataToShow
                                ? Color.gray
                                : Color.accentColor)
                            .animation(nil)
                    }
                }
            }.frame(height: 20)
        }
    }
}

struct HistoryDetail_Previews: PreviewProvider {
    static var previews: some View {
        HistoryDetail(history: historyData[0])
    }
}

