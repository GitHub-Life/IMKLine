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
            return KLineDefaultWidth * IMKLineParamters.getZoomScale()
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
    
    /// KLine 缩放比 下限
    static let ZoomScaleLowerLimit = CGFloat(0.2)
    /// KLine 缩放比 上线
    static let ZoomScaleUpperLimit = CGFloat(2)
    /// kLine 缩放比变化阈值
    static let ZoomScaleLimit = CGFloat(0.03)
    /// KLine 缩放因子
    static let ZoomScaleFactor = CGFloat(0.03)
    
    /// KLine MA线宽
    static let MALineWidth = CGFloat(1)
    
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
    
    /// 需要显示的 MA值 
    static let KLineMAs = [7, 15, 30]
    /// 需要显示的 EMS值
    static let KLineEMAs = [7, 25, 99]
    
}
