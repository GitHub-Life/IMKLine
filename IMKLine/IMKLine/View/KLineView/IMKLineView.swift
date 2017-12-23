//
//  IMKLineView.swift
//  IMKLine
//
//  Created by 万涛 on 2017/12/19.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit
import SnapKit

protocol IMKLineViewDelegate: NSObjectProtocol {
    func updateKlineRightYRange(min: Double, max: Double)
    func updateTimeRange(beginTimeStamp: TimeInterval, endTimeStamp: TimeInterval)
}

class IMKLineView: UIView {
    
    weak var superScrollView: IMKLineScrollView!
    override func didMoveToWindow() {
        self.superScrollView = self.superview as! IMKLineScrollView
        super.didMoveToWindow()
    }
    
    weak var delegate: IMKLineViewDelegate?

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()!
        context.clear(rect)
        if self.needDrawKlineArray.count == 0 {
            return
        }
        
        // 绘制 Y轴参考虚线
        let referenceLineCount = IMKLineConfig.KLineViewRightYCount - 2
        let step = rect.height / CGFloat(referenceLineCount + 1)
        context.setLineWidth(1)
        context.setStrokeColor(IMKLineTheme.BorderColor.cgColor)
        context.setLineDash(phase: 0, lengths: [1, 1])
        for index in 0...referenceLineCount {
            context.strokeLineSegments(between: [CGPoint.init(x: 0, y: CGFloat(index) * step), CGPoint.init(x: rect.width, y: CGFloat(index) * step)])
        }
        
        // 绘制 k线 / MA线
        context.setLineDash(phase: 0, lengths: [])
        var colors = [UIColor]()
        let klinePainter = IMKLinePainter()
        let klineMaPainter = IMKLineMAPainter()
        for kline in self.needDrawKlineArray {
            colors.append(klinePainter.draw(context: context, kline: kline))
            klineMaPainter.draw(context: context, kline: kline)
        }
        
        // 绘制 最小值 指示文字
        let lowPoint = self.minKline.klinePosition.lowPoint
        if self.minKline.klinePosition.lowPoint.x - self.superScrollView.contentOffset.x > self.superScrollView.frame.width / 2 {
            let ocStr = "\(self.minKline.low)→" as NSString
            let textW = ocStr.size(withAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: IMKLineTheme.TipTextFontSize)]).width
            ocStr.draw(at: CGPoint.init(x: lowPoint.x - textW, y: lowPoint.y - IMKLineTheme.TipTextFontSize - 2), withAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: IMKLineTheme.TipTextFontSize), NSAttributedStringKey.foregroundColor:IMKLineTheme.TipTextColor])
        } else {
            ("←\(self.minKline.low)" as NSString).draw(at: CGPoint.init(x: lowPoint.x, y: lowPoint.y - IMKLineTheme.TipTextFontSize - 2), withAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: IMKLineTheme.TipTextFontSize), NSAttributedStringKey.foregroundColor:IMKLineTheme.TipTextColor])
        }
        // 绘制 最大值 指示文字
        let highPoint = self.maxKline.klinePosition.highPoint
        if self.maxKline.klinePosition.lowPoint.x - self.superScrollView.contentOffset.x > self.superScrollView.frame.width / 2 {
            let ocStr = "\(self.maxKline.high)→" as NSString
            let textW = ocStr.size(withAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: IMKLineTheme.TipTextFontSize)]).width
            ocStr.draw(at: CGPoint.init(x: highPoint.x - textW, y: 0), withAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: IMKLineTheme.TipTextFontSize), NSAttributedStringKey.foregroundColor:IMKLineTheme.TipTextColor])
        } else {
            ("←\(self.minKline.high)" as NSString).draw(at: CGPoint.init(x: highPoint.x, y: 0), withAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: IMKLineTheme.TipTextFontSize), NSAttributedStringKey.foregroundColor:IMKLineTheme.TipTextColor])
        }
        
        self.superScrollView.volumeView.draw(klineArray: self.needDrawKlineArray, colors: colors)
    }
    
    private var klineGroup = IMKLineGroup()
    func getKlineGroup() -> IMKLineGroup {
        return klineGroup
    }
    
    func add(klineGroup: IMKLineGroup) {
        let isFirst = self.klineGroup.klineArray.count == 0
        self.klineGroup.insert(klineGroup: klineGroup)
        let offsetX = self.superScrollView.contentOffset.x
        self.updateViewWidth()
        if isFirst {
            if self.viewWidth > self.superScrollView.frame.width {
                self.superScrollView.setContentOffset(CGPoint.init(x: self.viewWidth - self.superScrollView.frame.width, y: 0), animated: false)
            } else {
                self.superScrollView.setContentOffset(CGPoint.zero, animated: false)
            }
        } else {
            let addedWidth = CGFloat(klineGroup.klineArray.count) * (IMKLineConfig.KLineGap + IMKLineConfig.KLineWidth)
            self.superScrollView.setContentOffset(CGPoint.init(x: addedWidth + offsetX, y: 0), animated: false)
        }
        self.draw()
    }
    
    var viewWidth = CGFloat(0)
    func updateViewWidth() {
        let klineViewWidth = CGFloat(self.klineGroup.klineArray.count) * (IMKLineConfig.KLineGap + IMKLineConfig.KLineWidth) + IMKLineConfig.KLineGap
        self.viewWidth = klineViewWidth
        self.snp.updateConstraints { (maker) in
            maker.width.equalTo(klineViewWidth)
        }
    }
    
    var needDrawKlineArray = [IMKLine]()
    
    func draw() {
        self.extractNeedDrawKlineArray()
        self.setKlinePosition()
        self.setNeedsDisplay()
    }
    
    var needDrawStartIndex: Int {
        get {
            let scrollViewOffsetX = self.superScrollView.contentOffset.x < 0 ? 0 : self.superScrollView.contentOffset.x;
            return Int(abs((scrollViewOffsetX - IMKLineConfig.KLineGap) / (IMKLineConfig.KLineWidth + IMKLineConfig.KLineGap)))
        }
    }
    
    var startXPosition: CGFloat {
        return CGFloat(self.needDrawStartIndex + 1) * IMKLineConfig.KLineGap + CGFloat(self.needDrawStartIndex) * IMKLineConfig.KLineWidth + IMKLineConfig.KLineWidth / 2
    }
    
    // MARK: - 提取需要绘制的数据
    private func extractNeedDrawKlineArray() {
        let klineWidth = IMKLineConfig.KLineWidth
        let klineGap = IMKLineConfig.KLineGap
        let needDrawCount = Int((self.superScrollView.frame.width - klineGap) / (klineWidth + klineGap))
        //起始位置
        let needDrawKlineStartIndex: Int
        needDrawKlineStartIndex = self.needDrawStartIndex
        self.needDrawKlineArray.removeAll()
        if needDrawKlineStartIndex < self.klineGroup.klineArray.count {
            if needDrawKlineStartIndex + needDrawCount < self.klineGroup.klineArray.count {
                self.needDrawKlineArray += self.klineGroup.klineArray[needDrawKlineStartIndex...(needDrawKlineStartIndex + needDrawCount)]
            } else {
                self.needDrawKlineArray += self.klineGroup.klineArray[needDrawKlineStartIndex...(self.klineGroup.klineArray.count - 1)]
            }
        }
        self.delegate?.updateTimeRange(beginTimeStamp: self.needDrawKlineArray.first!.timeStamp, endTimeStamp: self.needDrawKlineArray.last!.timeStamp)
    }
    
    var minKline = IMKLine()
    var maxKline = IMKLine()
    
    // MARK: - 设置数据在画布上的Position
    private func setKlinePosition() {
        if self.needDrawKlineArray.count == 0 {
            return
        }
        self.minKline = self.needDrawKlineArray[0]
        self.maxKline = self.needDrawKlineArray[0]
        for kline in self.needDrawKlineArray {
            if kline.high > self.maxKline.high {
                self.maxKline = kline
            }
            if kline.low < self.minKline.low {
                self.minKline = kline
            }
        }
        let maxValue = self.maxKline.high
        let minValue = self.minKline.low
        let minY = CGFloat(0)
        let maxY = self.frame.height
        let unitValue = (maxValue - minValue) / Double(maxY - minY)
        for index in 0..<self.needDrawKlineArray.count {
            let kline = self.needDrawKlineArray[index]
            let xPosition = self.startXPosition + CGFloat(index) * (IMKLineConfig.KLineGap + IMKLineConfig.KLineWidth)
            
            kline.klinePosition.highPoint = CGPoint.init(x: xPosition, y: maxY - CGFloat((kline.high - minValue) / unitValue))
            kline.klinePosition.lowPoint = CGPoint.init(x: xPosition, y: maxY - CGFloat((kline.low - minValue) / unitValue))
            var openPoint = CGPoint.init(x: xPosition, y: maxY - CGFloat((kline.open - minValue) / unitValue))
            var closePoint = CGPoint.init(x: xPosition, y: maxY - CGFloat((kline.close - minValue) / unitValue))
            if abs(openPoint.y - closePoint.y) < IMKLineConfig.KLineMinHeight {
                if openPoint.y > closePoint.y {
                    openPoint.y = closePoint.y + IMKLineConfig.KLineMinHeight
                } else if openPoint.y < closePoint.y {
                    closePoint.y = openPoint.y + IMKLineConfig.KLineMinHeight
                } else {
                    if index > 0 {
                        let prevKline = self.needDrawKlineArray[index - 1]
                        if kline.open > prevKline.close {
                            openPoint.y = closePoint.y + IMKLineConfig.KLineMinHeight
                        } else {
                            closePoint.y = openPoint.y + IMKLineConfig.KLineMinHeight
                        }
                    } else if index + 1 < self.needDrawKlineArray.count {
                        let nextKline = self.needDrawKlineArray[index + 1]
                        if kline.close < nextKline.open {
                            openPoint.y = closePoint.y + IMKLineConfig.KLineMinHeight
                        } else {
                            closePoint.y = openPoint.y + IMKLineConfig.KLineMinHeight
                        }
                    }
                }
            }
            kline.klinePosition.openPoint = openPoint
            kline.klinePosition.closePoint = closePoint
            
            kline.klineMAPositions.removeAll()
            for key in kline.klineMAs.keys.sorted() {
                kline.klineMAPositions[key] = CGPoint.init(x: xPosition, y: maxY - CGFloat((kline.klineMAs[key]! - minValue) / unitValue))
            }
            
            kline.klineEMAPositions.removeAll()
            for key in kline.klineEMAs.keys.sorted() {
                kline.klineEMAPositions[key] = CGPoint.init(x: xPosition, y: maxY - CGFloat((kline.klineEMAs[key]! - minValue) / unitValue))
            }
            
            if var klineBoll = kline.klineBoll {
                klineBoll.MBPoint = CGPoint.init(x: xPosition, y: maxY - CGFloat((klineBoll.MB - minValue) / unitValue))
                klineBoll.UPPoint = CGPoint.init(x: xPosition, y: maxY - CGFloat((klineBoll.UP - minValue) / unitValue))
                klineBoll.DNPoint = CGPoint.init(x: xPosition, y: maxY - CGFloat((klineBoll.DN - minValue) / unitValue))
                kline.klineBoll = klineBoll
            }
        }
        
        self.delegate?.updateKlineRightYRange(min: minValue, max: maxValue)
    }
}

extension IMKLineView {
    
    func getSelectedKline(touchPoint: CGPoint) -> IMKLine {
        var index = Int((touchPoint.x - IMKLineConfig.KLineGap) / (IMKLineConfig.KLineGap + IMKLineConfig.KLineWidth))
        if index < 0 {
            index = 0
        }
        if index > self.klineGroup.klineArray.count - 1 {
            index = self.klineGroup.klineArray.count - 1
        }
        let selectedKline = self.klineGroup.klineArray[index]
        return selectedKline
    }
    
}
