//
//  IMKLineVolumeView.swift
//  IMKLine
//
//  Created by iMoon on 2017/12/20.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit
import SnapKit

public protocol IMKLineVolumeViewUpdateDelegate: NSObjectProtocol {
    func updateVolumeRightYRange(min: Double, max: Double)
}

public class IMKLineVolumeView: UIView {
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public weak var updateDelegate: IMKLineVolumeViewUpdateDelegate?
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
            self.klineView.superScrollView.accessoryView.draw(klineArray: self.klineArray)
            return
        }
        
        // 绘制 Y轴参考虚线
        let referenceLineCount = IMKLineConfig.VolumeViewRightYCount - 2
        let step = rect.height / CGFloat(referenceLineCount + 1)
        context.setLineWidth(1)
        context.setStrokeColor(IMKLineTheme.BorderColor.cgColor)
        context.setLineDash(phase: 0, lengths: [1, 1])
        for index in 1...referenceLineCount {
            context.strokeLineSegments(between: [CGPoint.init(x: 0, y: CGFloat(index) * step), CGPoint.init(x: rect.width, y: CGFloat(index) * step)])
        }
        context.setLineDash(phase: 0, lengths: [])
        
        // 绘制 成交量柱状线 / MA线
        let volumePainter = IMKLineVolumePainter()
        for kline in self.klineArray {
            volumePainter.draw(context: context, kline: kline)
        }
        
        // 绘制 成交量 MA线
        let volumeMaPainter = IMKLineVolumeMAPainter()
        if IMKLineParamters.KLineMAType != .NONE {
            volumeMaPainter.draw(context: context, klineArray: self.klineArray)
        }
        
        self.klineView.superScrollView.accessoryView.draw(klineArray: self.klineArray)
    }
    
    public var klineArray = [IMKLine]()
    
    public func draw(klineArray: [IMKLine]) {
        self.klineArray = klineArray
        self.setKlineVolumePosition()
        self.setNeedsDisplay()
    }
    
    // MARK: - 设置数据在画布上的Position
    private func setKlineVolumePosition() {
        if self.klineArray.count == 0 {
            return
        }
        var maxVolume = self.klineArray[0].volume
        for kline in self.klineArray {
            if kline.volume > maxVolume {
                maxVolume = kline.volume
            }
        }
        // 顶部留点margin
        maxVolume *= 1.05
        IMKLineParamters.setVolumeDataDecimals(maxVolume, 0)
        let minY = CGFloat(0)
        let maxY = self.frame.height
        let unitValue = maxVolume / Double(maxY - minY)
        for index in 0..<self.klineArray.count {
            let kline = self.klineArray[index]
            let xPosition = CGFloat(self.klineView.startXPosition) + CGFloat(index) * (IMKLineConfig.KLineGap + IMKLineConfig.KLineWidth)
            kline.volumePosition.zeroPoint = CGPoint.init(x: xPosition, y: maxY)
            kline.volumePosition.volumePoint = CGPoint.init(x: xPosition, y: maxY - CGFloat(kline.volume / unitValue))
            
            kline.volumeMAPositions.removeAll()
            for key in kline.volumeMAs.keys.sorted() {
                kline.volumeMAPositions[key] = CGPoint.init(x: xPosition, y: maxY - CGFloat(kline.volumeMAs[key]! / unitValue))
            }
        }
        
        self.updateDelegate?.updateVolumeRightYRange(min: 0, max: maxVolume)
    }
}
