//
//  IMKLineVolumeMAPainter.swift
//  IMKLine
//
//  Created by iMoon on 2017/12/22.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

class IMKLineVolumeMAPainter: NSObject {

    /*
    func draw(context: CGContext, kline: IMKLine) {
        context.setLineWidth(IMKLineConfig.MALineWidth)
        var index = -1
        for ma in kline.volumeMAPositions.keys.sorted() {
            index += 1
            if let prevPosition = kline.prevKline.volumeMAPositions[ma] {
                if kline.prevKline.volumeMAs[ma]! < 0 {
                    continue
                }
                context.setStrokeColor(IMKLineTheme.MAColors[index + 1].cgColor)
                context.strokeLineSegments(between: [prevPosition, kline.volumeMAPositions[ma]!])
            }
        }
    }
 */
    
    public func draw(context: CGContext, klineArray: [IMKLine]) {
        if klineArray.count == 0 {
            return
        }
        context.setLineWidth(IMKLineConfig.MALineWidth)
        var index = 0
        for ma in klineArray[0].volumeMAPositions.keys.sorted() {
            let path = UIBezierPath()
            var start = false
            for kline in klineArray {
                if let position = kline.volumeMAPositions[ma], let maValue = kline.volumeMAs[ma] {
                    if maValue < 0 {
                        continue
                    }
                    if !start {
                        path.move(to: position)
                        start = true
                    } else {
                        path.addLine(to: position)
                    }
                }
            }
            if start {
                context.setStrokeColor(IMKLineTheme.MAColors[index + 1].cgColor)
                context.addPath(path.cgPath)
                context.drawPath(using: CGPathDrawingMode.stroke)
            }
            index += 1
        }
    }
    
}
