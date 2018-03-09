//
//  IMKLineMAPainter.swift
//  IMKLine
//
//  Created by iMoon on 2017/12/22.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

class IMKLineMAPainter: NSObject {
    
    /*
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
    */
    
    public func draw(context: CGContext, klineArray: [IMKLine]) {
        if IMKLineParamters.KLineStyle == .curve || klineArray.count == 0 {
            return
        }
        context.setLineWidth(IMKLineConfig.MALineWidth)
        switch IMKLineParamters.KLineMAType {
        case .MA:
            var index = 0
            for ma in klineArray[0].klineMAPositions.keys.sorted() {
                let path = UIBezierPath()
                var start = false
                for kline in klineArray {
                    if let position = kline.klineMAPositions[ma], let maValue = kline.klineMAs[ma] {
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
        case .EMA:
            var index = 0
            for ema in klineArray[0].klineEMAPositions.keys.sorted() {
                let path = UIBezierPath()
                var start = false
                for kline in klineArray {
                    if let position = kline.klineEMAPositions[ema], let emaValue = kline.klineEMAs[ema] {
                        if emaValue < 0 {
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
        case .BOLL:
            let mbPath = UIBezierPath()
            let upPath = UIBezierPath()
            let dnPath = UIBezierPath()
            var mbStart = false
            var upStart = false
            var dnStart = false
            for kline in klineArray {
                if let klineBoll = kline.klineBoll {
                    if !mbStart {
                        mbPath.move(to: klineBoll.MBPoint)
                        mbStart = true
                    } else {
                        mbPath.addLine(to: klineBoll.MBPoint)
                    }
                    if !upStart {
                        upPath.move(to: klineBoll.UPPoint)
                        upStart = true
                    } else {
                        upPath.addLine(to: klineBoll.UPPoint)
                    }
                    if !dnStart {
                        dnPath.move(to: klineBoll.DNPoint)
                        dnStart = true
                    } else {
                        dnPath.addLine(to: klineBoll.DNPoint)
                    }
                }
            }
            if mbStart {
                context.setStrokeColor(IMKLineTheme.MAColors[1].cgColor)
                context.addPath(mbPath.cgPath)
                context.drawPath(using: CGPathDrawingMode.stroke)
            }
            if upStart {
                context.setStrokeColor(IMKLineTheme.MAColors[2].cgColor)
                context.addPath(upPath.cgPath)
                context.drawPath(using: CGPathDrawingMode.stroke)
            }
            if dnStart {
                context.setStrokeColor(IMKLineTheme.MAColors[3].cgColor)
                context.addPath(dnPath.cgPath)
                context.drawPath(using: CGPathDrawingMode.stroke)
            }
        default: break
        }
    }

}
