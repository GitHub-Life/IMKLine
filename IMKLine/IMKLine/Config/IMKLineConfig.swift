//
//  IMKLineGolbalParameters.swift
//  IMKLine
//
//  Created by 万涛 on 2017/12/20.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

struct IMKLineConfig {
    
    /// KLine 蜡烛宽度
    static var KLineWidth: CGFloat {
        get {
            return KLineDefaultWidth * ZoomScale
        }
    }
    /// KLine 蜡烛初始默认宽度
    static let KLineDefaultWidth = CGFloat(10)
    /// KLine 蜡烛 最小 高度
    static let KLineMinHeight = CGFloat(1)
    /// KLine 蜡烛影线宽度
    static let KLineHatchedWidth = CGFloat(1)
    /// KLine 蜡烛间隙
    static let KLineGap = CGFloat(1)
    
    /// KLine 缩放比
    private static var ZoomScale = CGFloat(1)
    static func changeZoomScale(changeScale: CGFloat) -> Bool {
        let zoomScale = ZoomScale + changeScale
        if zoomScale > ZoomScaleUpperLimit || zoomScale < ZoomScaleLowerLimit {
            return false
        }
        ZoomScale = zoomScale
        return true
    }
    static func setZoomScale(scale: CGFloat) {
        if scale > ZoomScaleUpperLimit || scale < ZoomScaleLowerLimit {
            return
        }
        ZoomScale = scale
    }
    static func getZoomScale() -> CGFloat {
        return ZoomScale
    }
    /// KLine 缩放比 下限
    static let ZoomScaleLowerLimit = CGFloat(0.2)
    /// KLine 缩放比 上线
    static let ZoomScaleUpperLimit = CGFloat(2)
    /// kLine 缩放比变化阈值
    static let ZoomScaleLimit = CGFloat(0.03)
    /// KLine 缩放因子
    static let ZoomScaleFactor = CGFloat(0.03)
    
    
    /// K线图 右侧 Y轴视图宽度
    static let RightYViewWidth = CGFloat(50)
    
    /// K线图 右侧 Y轴显示的坐标值数量
    static let KLineViewRightYCount = 5
    /// 成交量图 右侧 Y轴显示的坐标值数量
    static let VolumeViewRightYCount = 3
    /// 底部MACD/KDJ图 右侧 Y轴显示的坐标值数量
    static let AccessoryViewRightYCount = 3
    
    
    
    /// K线图 占 K线图+成交量图+底部MACD/KDJ图总高度 之比
    ///
    /// - Parameter showAccessory: 是否显示 底部MACD/KDJ图
    /// - Returns: K线图 占 K线图+成交量图+底部MACD/KDJ图总高度 之比
    static func KLineViewHeightRate(showAccessory: Bool) -> CGFloat {
        if showAccessory {
            return CGFloat(0.6)
        } else {
            return CGFloat(0.75)
        }
    }
    
    /// 成交量图 占 K线图+成交量图+底部MACD/KDJ图总高度 之比
    ///
    /// - Parameter showAccessory: 是否显示 底部MACD/KDJ图
    /// - Returns: 成交量图 占 K线图+成交量图+底部MACD/KDJ图总高度 之比
    static func VolumeViewHeightRate(showAccessory: Bool) -> CGFloat {
        if showAccessory {
            return CGFloat(0.2)
        } else {
            return CGFloat(0.25)
        }
    }
    
    /// 底部MACD/KDJ图 占 K线图+成交量图+底部MACD/KDJ图总高度 之比
    ///
    /// - Returns: 底部MACD/KDJ图 占 K线图+成交量图+底部MACD/KDJ图总高度 之比
    static func AccessoryViewHeightRate() -> CGFloat {
        return CGFloat(0.2)
    }
    
}
