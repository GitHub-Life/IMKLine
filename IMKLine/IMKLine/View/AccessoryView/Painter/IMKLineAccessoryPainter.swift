//
//  IMKLineAccessoryPainter.swift
//  IMKLine
//
//  Created by 万涛 on 2017/12/23.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

class IMKLineAccessoryPainter: NSObject {
    
    func draw(context: CGContext, kline: IMKLine) {
        switch IMKLineParamters.AccessoryType {
        case .MACD:
            context.setStrokeColor(IMKLineTheme.MAColors[1].cgColor)
            context.strokeLineSegments(between: [kline.prevKline.klineMACD.DIFFPoint, kline.klineMACD.DIFFPoint])
            context.setStrokeColor(IMKLineTheme.MAColors[2].cgColor)
            context.strokeLineSegments(between: [kline.prevKline.klineMACD.DEAPoint, kline.klineMACD.DEAPoint])
            context.setStrokeColor(kline.klineMACD.BAR > 0 ? IMKLineTheme.RiseColor.cgColor : IMKLineTheme.DownColor.cgColor)
            context.strokeLineSegments(between: [kline.klineMACD.zeroPoint, kline.klineMACD.BARPoint])
        case .KDJ:
            context.setStrokeColor(IMKLineTheme.MAColors[1].cgColor)
            context.strokeLineSegments(between: [kline.prevKline.klineKDJ.kPoint, kline.klineKDJ.kPoint])
            context.setStrokeColor(IMKLineTheme.MAColors[2].cgColor)
            context.strokeLineSegments(between: [kline.prevKline.klineKDJ.dPoint, kline.klineKDJ.dPoint])
            context.setStrokeColor(IMKLineTheme.MAColors[3].cgColor)
            context.strokeLineSegments(between: [kline.prevKline.klineKDJ.jPoint, kline.klineKDJ.jPoint])
        case .RSI:
            var index = 0
            for key in kline.klineRSI.klineRSIPositions.keys.sorted() {
                if let prevPoint = kline.prevKline.klineRSI.klineRSIPositions[key] {
                    context.setStrokeColor(IMKLineTheme.MAColors[index + 1].cgColor)
                    context.strokeLineSegments(between: [prevPoint, kline.klineRSI.klineRSIPositions[key]!])
                }
                index += 1
            }
        default: break
        }
    }

}
