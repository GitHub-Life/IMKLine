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

enum IMKLineAccessoryType: Int {
    case NONE, MACD, KDJ, RSI
}

class IMKLineParamters: NSObject {
    
    /// 需要显示的 MA值
    static var KLineMAs = [7, 15, 30]
    /// 需要显示的 EMS值
    static var KLineEMAs = [7, 25, 99]
    /// 需要显示的 BOLL线的参数值
    static var KLineBollPramas = ["N":20, "P":2]
    /// 需要显示的 MACD图的参数值
    static var KLineMACDPramas = [12, 26, 9]
    
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
    static var klineMAType: IMKLineMAType = .EMA
    
    // MARK: - KLine 底部MACD/KDJ图 显示类型
    static var AccessoryType: IMKLineAccessoryType = .MACD
    
    // MARK: - 复位
    static func reset() {
        ZoomScale = CGFloat(1)
        klineMAType = .MA
    }
    
}
