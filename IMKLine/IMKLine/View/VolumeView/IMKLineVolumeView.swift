//
//  IMKLineVolumeView.swift
//  IMKLine
//
//  Created by 万涛 on 2017/12/20.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit
import SnapKit

protocol IMKLineVolumeViewDelegate: NSObjectProtocol {
    func updateVolumeRightYRange(min: Double, max: Double)
}

class IMKLineVolumeView: UIView {
    
    weak var delegate: IMKLineVolumeViewDelegate?
    weak var klineView: IMKLineView!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()!
        context.clear(rect)
        
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
        
        if self.klineArray.count != self.colors.count {
            return
        }
        
        // 绘制 成交量柱状线 / MA线
        let volumePainter = IMKLineVolumePainter.init(context: context)
        let volumeMaPainter = IMKLineVolumeMAPainter.init(context: context)
        var index = 0
        for kline in self.klineArray {
            volumePainter.kline = kline
            volumePainter.draw(color: self.colors[index])
            volumeMaPainter.kline = kline
            volumeMaPainter.draw()
            index += 1
        }
    }
    
    var colors = [UIColor]()
    var klineArray = [IMKLine]()
    
    func draw(klineArray: [IMKLine], colors: [UIColor]) {
        self.klineArray = klineArray
        self.colors = colors
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
        
        self.delegate?.updateVolumeRightYRange(min: 0, max: maxVolume)
    }
}
