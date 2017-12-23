//
//  IMKLineMAPainter.swift
//  IMKLine
//
//  Created by 万涛 on 2017/12/22.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

class IMKLineMAPainter: NSObject {
    
    func draw(context: CGContext, kline: IMKLine) {
        context.setLineWidth(IMKLineConfig.MALineWidth)
        switch IMKLineParamters.KLineMAType {
        case .MA:
            let positions = kline.klineMAPositions
            let prevPositions = kline.prevKline.klineMAPositions
            var index = 0
            for ma in positions.keys.sorted() {
                if let prevPosition = prevPositions[ma] {
                    if kline.prevKline.klineMAs[ma]! < 0 {
                        continue
                    }
                    context.setStrokeColor(IMKLineTheme.MAColors[index + 1].cgColor)
                    context.strokeLineSegments(between: [prevPosition, positions[ma]!])
                }
                index += 1
            }
        case .EMA:
            let positions = kline.klineEMAPositions
            let prevPositions = kline.prevKline.klineEMAPositions
            var index = 0
            for ma in positions.keys.sorted() {
                if let prevPosition = prevPositions[ma] {
                    if IMKLineParamters.KLineMAType == .MA && kline.prevKline.klineMAs[ma]! < 0 {
                        continue
                    }
                    context.setStrokeColor(IMKLineTheme.MAColors[index + 1].cgColor)
                    context.strokeLineSegments(between: [prevPosition, positions[ma]!])
                }
                index += 1
            }
        case .BOLL:
            if let klineBoll = kline.klineBoll, let prevKlineBoll = kline.prevKline.klineBoll {
                context.setStrokeColor(IMKLineTheme.MAColors[1].cgColor)
                context.strokeLineSegments(between: [prevKlineBoll.MBPoint, klineBoll.MBPoint])
                context.setStrokeColor(IMKLineTheme.MAColors[2].cgColor)
                context.strokeLineSegments(between: [prevKlineBoll.UPPoint, klineBoll.UPPoint])
                context.setStrokeColor(IMKLineTheme.MAColors[3].cgColor)
                context.strokeLineSegments(between: [prevKlineBoll.DNPoint, klineBoll.DNPoint])
            }
        default: break
        }
    }

}
