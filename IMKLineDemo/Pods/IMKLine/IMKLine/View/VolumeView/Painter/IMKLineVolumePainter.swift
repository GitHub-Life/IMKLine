//
//  IMKLineVolumePainter.swift
//  IMKLine
//
//  Created by iMoon on 2017/12/21.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

class IMKLineVolumePainter: NSObject {
    
    public func draw(context: CGContext, kline: IMKLine) {
        let paintColor = kline.close < kline.open ? IMKLineTheme.DownColor : IMKLineTheme.RiseColor
        context.setStrokeColor(paintColor.cgColor)
        context.setLineWidth(IMKLineConfig.KLineWidth)
        context.strokeLineSegments(between: [kline.volumePosition.zeroPoint, kline.volumePosition.volumePoint])
    }
}
