//
//  IMKLineGolbalParameters.swift
//  IMKLine
//
//  Created by iMoon on 2017/12/20.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

public struct IMKLineConfig {
    
    /// KLine 蜡烛初始默认宽度
    public static let KLineDefaultWidth = CGFloat(10)
    /// KLine 蜡烛宽度
    public static var KLineWidth: CGFloat {
        get {
            return KLineDefaultWidth * IMKLineParamters.getZoomScale()
        }
    }
    
    /// KLine 蜡烛 最小 高度
    public static let KLineMinHeight = CGFloat(1)
    /// KLine 蜡烛影线宽度
    public static let KLineHatchedWidth = CGFloat(1)
    /// KLine 蜡烛间隙
    public static let KLineGap = CGFloat(1)
    
    /// KLine 分时线宽度
    public static let LineWidth = CGFloat(1)
    
    /// KLine 缩放比 下限
    public static let ZoomScaleLowerLimit = CGFloat(0.2)
    /// KLine 缩放比 上线
    public static let ZoomScaleUpperLimit = CGFloat(2)
    /// kLine 缩放比变化阈值
    public static let ZoomScaleLimit = CGFloat(0.03)
    /// KLine 缩放因子
    public static let ZoomScaleFactor = CGFloat(0.1)
    
    /// KLine MA线宽
    public static let MALineWidth = CGFloat(1)
    /// MACD 柱状初始默认宽度
    public static let MACDDefaultWidth = CGFloat(5)
    /// MACD 柱状宽度
    public static var MACDWidth: CGFloat {
        get {
            return MACDDefaultWidth * IMKLineParamters.getZoomScale()
        }
    }
    
    /// K线图 右侧 Y轴视图宽度
    public static let RightYViewWidth = CGFloat(50)
    
    /// K线图 右侧 Y轴显示的坐标值数量
    public static let KLineViewRightYCount = 5
    /// 成交量图 右侧 Y轴显示的坐标值数量
    public static let VolumeViewRightYCount = 3
    /// 底部MACD/KDJ图 右侧 Y轴显示的坐标值数量
    public static let AccessoryViewRightYCount = 3
    
    
    /// K线图 占 K线图+成交量图+底部MACD/KDJ图总高度 之比
    ///
    /// - Returns: K线图 占 K线图+成交量图+底部MACD/KDJ图总高度 之比
    public static func KLineViewHeightRate() -> CGFloat {
        if IMKLineParamters.AccessoryType != .NONE {
            return CGFloat(0.6)
        } else {
            return CGFloat(0.75)
        }
    }
    
    /// 成交量图 占 K线图+成交量图+底部MACD/KDJ图总高度 之比
    ///
    /// - Returns: 成交量图 占 K线图+成交量图+底部MACD/KDJ图总高度 之比
    public static func VolumeViewHeightRate() -> CGFloat {
        if IMKLineParamters.AccessoryType != .NONE {
            return CGFloat(0.2)
        } else {
            return CGFloat(0.25)
        }
    }
    
    /// 底部MACD/KDJ图 占 K线图+成交量图+底部MACD/KDJ图总高度 之比
    ///
    /// - Returns: 底部MACD/KDJ图 占 K线图+成交量图+底部MACD/KDJ图总高度 之比
    public static func AccessoryViewHeightRate() -> CGFloat {
        return CGFloat(0.2)
    }
    
    /// 显示数据的最少有效位数 (亦可理解为最多小数位数)
    public static let DataDecimals = 6
    
    /// KLine 时段默认设置选项
    public static let KLineTimeFrames = [
        "1m",
        "5m",
        "15m",
        "30m",
        "1h",
        "2h",
        "4h",
        "1d",
        "3d",
        "5d",
        "1w"
    ]
    
    
}
