//
//  IMKLinePainter.swift
//  IMKLine
//
//  Created by iMoon on 2017/12/20.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

class IMKLinePainter: NSObject {
    
    func draw(context: CGContext, klineArray: [IMKLine], size: CGSize) {
        if klineArray.count == 0 {
            return
        }
        switch IMKLineParamters.KLineStyle {
        case .curve:
            let path = UIBezierPath()
            var start = false
            for kline in klineArray {
                if !start {
                    path.move(to: kline.klinePosition.closePoint)
                    start = true
                } else {
                    // 折线
                    path.addLine(to: kline.klinePosition.closePoint)
                    // 曲线
//                    let pointMid = CGPoint.midPoint(p1: kline.klinePosition.closePoint, p2: kline.prevKline.klinePosition.closePoint)
//                    path.addCurve(to: kline.klinePosition.closePoint, controlPoint1: CGPoint.init(x: pointMid.x, y: kline.prevKline.klinePosition.closePoint.y), controlPoint2: CGPoint.init(x: pointMid.x, y: kline.klinePosition.closePoint.y))
                }
            }
            context.setLineWidth(IMKLineConfig.LineWidth)
            context.setStrokeColor(IMKLineTheme.LineColor.cgColor)
            path.stroke()
            path.addLine(to: CGPoint.init(x: klineArray.last!.klinePosition.closePoint.x, y: size.height))
            path.addLine(to: CGPoint.init(x: klineArray.first!.klinePosition.closePoint.x, y: size.height))
            path.close()
            context.addPath(path.cgPath)
            context.clip()
            
            //使用rgb颜色空间
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            //颜色数组（这里使用三组颜色作为渐变）fc6820
            let startCompoents = UIColor.init(rgbaHex: 0x0000ff55).cgColor.components!
            let endCompoents = UIColor.init(rgbaHex: 0x0000ff00).cgColor.components!
            //没组颜色所在位置（范围0~1)
            let locations:[CGFloat] = [0,1]
            //生成渐变色（count参数表示渐变个数）
            let gradient = CGGradient(colorSpace: colorSpace, colorComponents: startCompoents + endCompoents,
                                      locations: locations, count: locations.count)!
            
            //渐变开始位置
            let startPoint = CGPoint(x: 0, y: 0)
            //渐变结束位置
            let endPoint = CGPoint(x: 0, y: size.height)
            //绘制渐变
            context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: .drawsBeforeStartLocation)
        default:
            for kline in klineArray {
                self.draw(context: context, kline: kline)
            }
        }
    }
    
    private func draw(context: CGContext, kline: IMKLine) {
        let paintColor = kline.close < kline.open ? IMKLineTheme.DownColor : IMKLineTheme.RiseColor
        context.setStrokeColor(paintColor.cgColor)
        switch IMKLineParamters.KLineStyle {
        case .standard:
            // 画 实体线(蜡烛)
            context.setLineWidth(IMKLineConfig.KLineWidth)
            context.strokeLineSegments(between: [kline.klinePosition.openPoint, kline.klinePosition.closePoint])
            // 画 上下影线
            context.setLineWidth(IMKLineConfig.KLineHatchedWidth)
            context.strokeLineSegments(between: [kline.klinePosition.highPoint, kline.klinePosition.lowPoint])
        case .hollow:
            // 画 空心线(蜡烛)
            if kline.open < kline.close {
                context.stroke(CGRect.init(x: kline.klinePosition.openPoint.x - IMKLineConfig.KLineWidth / 2 + IMKLineConfig.KLineGap / 2, y: kline.close < kline.open ? kline.klinePosition.openPoint.y : kline.klinePosition.closePoint.y, width: IMKLineConfig.KLineWidth - IMKLineConfig.KLineGap, height: abs(kline.klinePosition.openPoint.y - kline.klinePosition.closePoint.y)), width: IMKLineConfig.KLineHatchedWidth)
            } else {
                context.setLineWidth(IMKLineConfig.KLineWidth)
                context.strokeLineSegments(between: [kline.klinePosition.openPoint, kline.klinePosition.closePoint])
            }
            // 画 上下影线
            context.setLineWidth(IMKLineConfig.KLineHatchedWidth)
            context.strokeLineSegments(between: [kline.klinePosition.highPoint, kline.close < kline.open ? kline.klinePosition.openPoint : kline.klinePosition.closePoint])
            context.strokeLineSegments(between: [kline.close < kline.open ? kline.klinePosition.closePoint : kline.klinePosition.openPoint, kline.klinePosition.lowPoint])
        case .line:
            // 画 简易折线
            context.setLineWidth(IMKLineConfig.KLineHatchedWidth)
            context.strokeLineSegments(between: [CGPoint.init(x: kline.klinePosition.openPoint.x - IMKLineConfig.KLineWidth / 2, y: kline.klinePosition.openPoint.y), kline.klinePosition.openPoint])
            context.strokeLineSegments(between: [kline.klinePosition.closePoint, CGPoint.init(x: kline.klinePosition.closePoint.x + IMKLineConfig.KLineWidth / 2, y: kline.klinePosition.closePoint.y)])
            // 画 上下影线
            context.strokeLineSegments(between: [kline.klinePosition.highPoint, kline.klinePosition.lowPoint])
        default:
            break
        }
    }
    
}
