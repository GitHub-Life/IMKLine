//
//  IMKLineVolumePainter.swift
//  IMKLine
//
//  Created by 万涛 on 2017/12/21.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

class IMKLineVolumePainter: NSObject {
    
    func draw(context: CGContext, kline: IMKLine, color: UIColor) {
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(IMKLineConfig.KLineWidth)
        context.strokeLineSegments(between: [kline.volumePosition.zeroPoint, kline.volumePosition.volumePoint])
    }
}
