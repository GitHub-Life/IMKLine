//
//  IMKLine.swift
//  IMKLine
//
//  Created by 万涛 on 2017/12/20.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit
import SwiftyJSON

class IMKLine: NSObject {
    
    var timeStamp: Double = Double(0)
    var open: Double = Double(0)
    var close: Double = Double(0)
    var low: Double = Double(0)
    var high: Double = Double(0)
    var volume: Double = Double(0)
    
    /* 此方法在项目中根据返回的数据结构实现
    convenience init(json: JSON) {
        self.init()
        self.timeStamp = json["timestamp"].doubleValue
        self.open = json["open"].doubleValue
        self.close = json["close"].doubleValue
        self.low = json["low"].doubleValue
        self.high = json["high"].doubleValue
        self.volume = json["volume"].doubleValue
    }
     */
    
    var prevKline: IMKLine!
    var index = 0
    weak var klineGroup: IMKLineGroup!
    
    var sumLastClose = Double(0)
    var sumLastVolume = Double(0)
    var klineMAs = [Int : Double]()
    var volumeMAs = [Int : Double]()
    var klineEMAs = [Int : Double]()
    
    var klinePosition = IMKLinePosition()
    var volumePosition = IMKLineVolumePosition()
    var klineMAPositions = [Int : CGPoint]()
    var volumeMAPositions = [Int : CGPoint]()
    var klineEMAPositions = [Int : CGPoint]()
    
    var klineBoll: IMKLineBoll?
    var sumC_MA_Square = Double(0)
    
    var klineMACD = IMKLineMACD()
    
    var klineKDJ = IMKLineKDJ()
    
    var klineRSI = IMKLineRSI()
}
