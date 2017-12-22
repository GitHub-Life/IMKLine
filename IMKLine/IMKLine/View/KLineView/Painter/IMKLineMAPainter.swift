//
//  IMKLineMAPainter.swift
//  IMKLine
//
//  Created by 万涛 on 2017/12/22.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

class IMKLineMAPainter: NSObject {
    
    var kline: IMKLine?
    var context: CGContext?
    
    convenience init(context: CGContext) {
        self.init()
        self.context = context
    }
    
    func draw() {
        if let kline = self.kline, let context = context {
            var positions = [Int : CGPoint]()
            var prevPositions = [Int : CGPoint]()
            if IMKLineParamters.klineMAType == .EMA {
                
            } else {
                positions = kline.klineMAPositions
                prevPositions = kline.prevKline.klineMAPositions
            }
            context.setLineWidth(IMKLineConfig.MALineWidth)
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
        }
    }

}
