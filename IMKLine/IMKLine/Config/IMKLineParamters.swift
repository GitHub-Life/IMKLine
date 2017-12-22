//
//  IMKLineParamters.swift
//  IMKLine
//
//  Created by 万涛 on 2017/12/22.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

enum IMKLineMAType: String {
    case NONE = "", MA = "MA", EMA = "EMA", BOLL = "BOLL"
}

class IMKLineParamters: NSObject {
    
    // MARK: - 缩放比
    /// KLine 缩放比
    private static var ZoomScale = CGFloat(1)
    static func changeZoomScale(changeScale: CGFloat) -> Bool {
        let zoomScale = ZoomScale + changeScale
        if zoomScale > IMKLineConfig.ZoomScaleUpperLimit || zoomScale < IMKLineConfig.ZoomScaleLowerLimit {
            return false
        }
        ZoomScale = zoomScale
        return true
    }
    static func setZoomScale(scale: CGFloat) {
        if scale > IMKLineConfig.ZoomScaleUpperLimit || scale < IMKLineConfig.ZoomScaleLowerLimit {
            return
        }
        ZoomScale = scale
    }
    static func getZoomScale() -> CGFloat {
        return ZoomScale
    }
    
    // MARK: - KLine 显示的 MA 类型
    static var klineMAType: IMKLineMAType = .BOLL
    
    // MARK: - 复位
    static func reset() {
        ZoomScale = CGFloat(1)
        klineMAType = .MA
    }
    
}
