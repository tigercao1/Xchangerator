//
//  HistoryGraph.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-03-05.
//  Copyright © 2020 YYES. All rights reserved.
//
import SwiftUI

let historyData: [HistoryCell] = JSONLoader("historyData.json")

func rangeOfRanges<C: Collection>(_ ranges: C) -> Range<Double>
    where C.Element == Range<Double> {
    guard !ranges.isEmpty else { return 0 ..< 0 }
    let low = ranges.lazy.map { $0.lowerBound }.min()!
    let high = ranges.lazy.map { $0.upperBound }.max()!
    return low ..< high
}

func magnitude(of range: Range<Double>) -> Double {
    return range.upperBound - range.lowerBound
}

extension Animation {
    static func ripple(index: Int) -> Animation {
        Animation.spring(dampingFraction: 0.5)
            .speed(2)
            .delay(0.03 * Double(index))
    }
}

struct HistoryGraph: View {
    var history: HistoryCell
    var path: KeyPath<HistoryCell.Observation, Range<Double>>

    var color: Color {
        switch path {
        case \.month:
            return Color(UIColor(Constant.cardHighlight))
        case \.week:
            return Color(hue: 0, saturation: 0.5, brightness: 0.7)
        case \.year:
            return Color(hue: 0.7, saturation: 0.4, brightness: 0.7)
        default:
            return .black
        }
    }

    var body: some View {
        let data = history.observations
        let overallRange = rangeOfRanges(data.lazy.map { $0[keyPath: self.path] })
        let maxMagnitude = data.map { magnitude(of: $0[keyPath: path]) }.max()!
        let heightRatio = (1 - CGFloat(maxMagnitude / magnitude(of: overallRange))) / 2

        return GeometryReader { proxy in
            HStack(alignment: .bottom, spacing: proxy.size.width / 120) {
                ForEach(data.indices) { index in
                    GraphCapsule(
                        index: index,
                        height: proxy.size.height,
                        range: data[index][keyPath: self.path],
                        overallRange: overallRange
                    )
                    .colorMultiply(self.color)
                    .transition(.slide)
                    .animation(.ripple(index: index))
                }
                .offset(x: 0, y: proxy.size.height * heightRatio)
            }
        }
    }
}

struct HistoryGraph_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HistoryGraph(history: historyData[0], path: \.month)
                .frame(height: 200)
            HistoryGraph(history: historyData[0], path: \.week)
                .frame(height: 200)
            HistoryGraph(history: historyData[0], path: \.year)
                .frame(height: 200)
        }
    }
}
