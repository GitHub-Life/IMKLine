//
//  IMKLineVolumePainter.swift
//  IMKLine
//
//  Created by 万涛 on 2017/12/21.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

class IMKLineVolumePainter: NSObject {
    
    var kline: IMKLine?
    var context: CGContext?
    
    convenience init(context: CGContext) {
        self.init()
        self.context = context
    }
    
    func draw(color: UIColor) {
        if let kline = self.kline, let context = context {
            context.setStrokeColor(color.cgColor)
            context.setLineWidth(IMKLineConfig.KLineWidth)
            context.strokeLineSegments(between: [kline.volumePosition.zeroPoint, kline.volumePosition.volumePoint])
        }
    }
}
