//
//  IMKLineVolumeMAPainter.swift
//  IMKLine
//
//  Created by 万涛 on 2017/12/22.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

class IMKLineVolumeMAPainter: NSObject {
    
    var kline: IMKLine?
    var context: CGContext?
    
    convenience init(context: CGContext) {
        self.init()
        self.context = context
    }
    
    func draw() {
        if let kline = self.kline, let context = context {
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
    }
    
}
