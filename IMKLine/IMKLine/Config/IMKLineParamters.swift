//
//  IMKLineParamters.swift
//  IMKLine
//
//  Created by 万涛 on 2017/12/22.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

/// KLine MA 类型设置选项
enum IMKLineMAType: String {
    case NONE = "Close", MA = "MA", EMA = "EMA", BOLL = "BOLL"
    static let RawValues = ["MA", "EMA", "BOLL", "Close"]
    static func enumValue(index: Int) -> IMKLineMAType {
        return IMKLineMAType.init(rawValue: RawValues[index])!
    }
}

/// KLine 底部MACD/KDJ图 类型设置选项
enum IMKLineAccessoryType: String {
    case NONE = "Close", MACD = "MACD", KDJ = "KDJ", RSI = "RSI"
    static let RawValues = ["MACD", "KDJ", "RSI", "Close"]
    static func enumValue(index: Int) -> IMKLineAccessoryType {
        return IMKLineAccessoryType.init(rawValue: RawValues[index])!
    }
}

/// KLine 风格设置选项
enum IMKLineStyle: Int {
    case standard = 0, hollow = 1, line = 2, curve = 3
    static func enumValue(_ rawValue: Int) -> IMKLineStyle {
        return IMKLineStyle.init(rawValue: rawValue)!
    }
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
    /// 需要显示的 KDJ图的参数值
    static var KLineKDJPramas = [3, 3, 9]
    /// 需要显示的 RSI图的参数值
    static var KLineRSIPramas = [6, 12, 24]
    
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
    
    /// KLine 显示的 MA 类型
    static var KLineMAType: IMKLineMAType = .MA {
        willSet {
            klineMATypeChanged =  newValue != KLineMAType
        }
        didSet {
            if klineMATypeChanged {
                NotificationCenter.default.post(name: IMKLineMATypeChanged, object: nil)
            }
        }
    }
    private static var klineMATypeChanged = false
    static let IMKLineMATypeChanged = NSNotification.Name.init("IMKLineMATypeChanged")
    
    /// KLine 底部MACD/KDJ图 显示类型
    static var AccessoryType: IMKLineAccessoryType = .MACD {
        willSet {
            accessoryTypeChanged =  newValue != AccessoryType
        }
        didSet {
            if accessoryTypeChanged {
                NotificationCenter.default.post(name: IMKLineAccessoryTypeChanged, object: nil)
            }
        }
    }
    private static var accessoryTypeChanged = false
    static let IMKLineAccessoryTypeChanged = NSNotification.Name.init("IMKLineAccessoryTypeChanged")
    
    /// KLine 显示风格
    static var KLineStyle: IMKLineStyle = .standard {
        willSet {
            kLineStyleChanged =  newValue != KLineStyle
        }
        didSet {
            if kLineStyleChanged {
                NotificationCenter.default.post(name: IMKLineStyleChanged, object: nil)
            }
        }
    }
    private static var kLineStyleChanged = false
    static let IMKLineStyleChanged = NSNotification.Name.init("IMKLineStyleChanged")
    
    /// 时间帧 集合 【用于显示】
    static var KLineTimeFrames = [String]()
    
    /// KLine 数据保留的小数位数
    static var KLineDataDecimals = 6
    static func setKLineDataDecimals(_ v1: Double, _ v2: Double) {
        KLineDataDecimals = IMKLineTool.dataDecimals(v1, v2)
    }
    /// KLine Volume 数据保留的小数位数
    static var VolumeDataDecimals = 6
    static func setVolumeDataDecimals(_ v1: Double, _ v2: Double) {
        VolumeDataDecimals = IMKLineTool.dataDecimals(v1, v2)
    }
    /// KLine 底部MACD/KDJ图 数据保留的小数位数
    static var AccessoryDataDecimals = 6
    static func setAccessoryDataDecimals(_ v1: Double, _ v2: Double) {
        AccessoryDataDecimals = IMKLineTool.dataDecimals(v1, v2)
    }
    
    // MARK: - 复位
    static func reset() {
        ZoomScale = CGFloat(1)
        KLineMAType = .MA
        AccessoryType = .MACD
    }
    
}
