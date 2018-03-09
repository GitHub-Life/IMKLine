//
//  IMKLineAccessoryView.swift
//  IMKLine
//
//  Created by iMoon on 2017/12/20.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit
import SnapKit

public protocol IMKLineAccessoryViewUpdateDelegate: NSObjectProtocol {
    func updateAccessoryRightYRange(min: Double, max: Double)
}

public class IMKLineAccessoryView: UIView {
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public weak var updateDelegate: IMKLineAccessoryViewUpdateDelegate?
    public weak var klineView: IMKLineView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
        self.layer.isOpaque = false
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()!
        context.clear(rect)
        if self.klineArray.count == 0 {
            return
        }
        
        // 绘制 Y轴参考虚线
        let referenceLineCount = IMKLineConfig.AccessoryViewRightYCount - 2
        let step = rect.height / CGFloat(referenceLineCount + 1)
        context.setLineWidth(1)
        context.setStrokeColor(IMKLineTheme.BorderColor.cgColor)
        context.setLineDash(phase: 0, lengths: [1, 1])
        for index in 1...referenceLineCount {
            context.strokeLineSegments(between: [CGPoint.init(x: 0, y: CGFloat(index) * step), CGPoint.init(x: rect.width, y: CGFloat(index) * step)])
        }
        context.setLineDash(phase: 0, lengths: [])
        
        // 绘制
        let accessoryPainter = IMKLineAccessoryPainter()
        accessoryPainter.draw(context: context, klineArray: self.klineArray)
    }
    
    public var klineArray = [IMKLine]()
    
    public func draw(klineArray: [IMKLine]) {
        self.klineArray = klineArray
        self.setKlineAccesstoryPosition()
        self.setNeedsDisplay()
    }
    
    // MARK: - 设置数据在画布上的Position
    private func setKlineAccesstoryPosition() {
        if self.klineArray.count == 0 {
            return
        }
        
        var maxValue = Double(0)
        var minValue = Double(0)
        let minY = CGFloat(0)
        let maxY = self.frame.height
        switch IMKLineParamters.AccessoryType {
        case .MACD:
            let firstKline = self.klineArray[0]
            maxValue = max(firstKline.klineMACD.BAR, firstKline.klineMACD.DIFF, firstKline.klineMACD.DEA)
            minValue = min(firstKline.klineMACD.BAR, firstKline.klineMACD.DIFF, firstKline.klineMACD.DEA)
            for kline in self.klineArray {
                maxValue = max(kline.klineMACD.BAR, kline.klineMACD.DIFF, kline.klineMACD.DEA, maxValue)
                minValue = min(kline.klineMACD.BAR, kline.klineMACD.DIFF, kline.klineMACD.DEA, minValue)
            }
            // 上下留点margin
            maxValue *= 1.01
            minValue *= 0.99
            IMKLineParamters.setAccessoryDataDecimals(maxValue, minValue)
            let unitValue = (maxValue - minValue) / Double(maxY - minY)
            for index in 0..<self.klineArray.count {
                let kline = self.klineArray[index]
                let xPosition = CGFloat(self.klineView.startXPosition) + CGFloat(index) * (IMKLineConfig.KLineGap + IMKLineConfig.KLineWidth)
                kline.klineMACD.zeroPoint = CGPoint.init(x: xPosition, y: maxY - CGFloat(abs(minValue / unitValue)))
                kline.klineMACD.DIFFPoint = CGPoint.init(x: xPosition, y: maxY - CGFloat((kline.klineMACD.DIFF - minValue) / unitValue))
                kline.klineMACD.DEAPoint = CGPoint.init(x: xPosition, y: maxY - CGFloat((kline.klineMACD.DEA - minValue) / unitValue))
                kline.klineMACD.BARPoint = CGPoint.init(x: xPosition, y: maxY - CGFloat((kline.klineMACD.BAR - minValue) / unitValue))
            }
        case .KDJ:
            let firstKline = self.klineArray[0]
            maxValue = max(firstKline.klineKDJ.k, firstKline.klineKDJ.d, firstKline.klineKDJ.j)
            minValue = min(firstKline.klineKDJ.k, firstKline.klineKDJ.d, firstKline.klineKDJ.j)
            for kline in self.klineArray {
                maxValue = max(kline.klineKDJ.k, kline.klineKDJ.d, kline.klineKDJ.j, maxValue)
                minValue = min(kline.klineKDJ.k, kline.klineKDJ.d, kline.klineKDJ.j, minValue)
            }
            // 上下留点margin
            maxValue *= 1.01
            minValue *= 0.99
            IMKLineParamters.setAccessoryDataDecimals(maxValue, minValue)
            let unitValue = (maxValue - minValue) / Double(maxY - minY)
            for index in 0..<self.klineArray.count {
                let kline = self.klineArray[index]
                let xPosition = CGFloat(self.klineView.startXPosition) + CGFloat(index) * (IMKLineConfig.KLineGap + IMKLineConfig.KLineWidth)
                kline.klineKDJ.kPoint = CGPoint.init(x: xPosition, y: maxY - CGFloat((kline.klineKDJ.k - minValue) / unitValue))
                kline.klineKDJ.dPoint = CGPoint.init(x: xPosition, y: maxY - CGFloat((kline.klineKDJ.d - minValue) / unitValue))
                kline.klineKDJ.jPoint = CGPoint.init(x: xPosition, y: maxY - CGFloat((kline.klineKDJ.j - minValue) / unitValue))
            }
        case .RSI:
            var bothValues = self.klineArray[0].klineRSI.bothRSI
            for kline in self.klineArray {
                if let both = bothValues {
                    bothValues = (min(both.low, (kline.klineRSI.bothRSI?.low)!), max(both.high, (kline.klineRSI.bothRSI?.high)!))
                }
            }
            if let bothValues = bothValues {
                minValue = bothValues.low
                maxValue = bothValues.high
                // 上下留点margin
                maxValue *= 1.01
                minValue *= 0.99
                IMKLineParamters.setAccessoryDataDecimals(maxValue, minValue)
                let unitValue = (maxValue - minValue) / Double(maxY - minY)
                for index in 0..<self.klineArray.count {
                    let xPosition = CGFloat(self.klineView.startXPosition) + CGFloat(index) * (IMKLineConfig.KLineGap + IMKLineConfig.KLineWidth)
                    let kline = self.klineArray[index]
                    kline.klineRSI.klineRSIPositions.removeAll()
                    for key in kline.klineRSI.klineRSIs.keys.sorted() {
                        kline.klineRSI.klineRSIPositions[key] = CGPoint.init(x: xPosition, y: maxY - CGFloat((kline.klineRSI.klineRSIs[key]! - minValue) / unitValue))
                    }
                }
            }
        default: break
        }
    
        self.updateDelegate?.updateAccessoryRightYRange(min: minValue, max: maxValue)
    }
}
