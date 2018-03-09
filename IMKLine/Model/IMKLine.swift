//
//  IMKLine.swift
//  IMKLine
//
//  Created by iMoon on 2017/12/20.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

public class IMKLine: NSObject {
    
    public var timeStamp: Double = Double(0)
    public var open: Double = Double(0)
    public var close: Double = Double(0)
    public var low: Double = Double(0)
    public var high: Double = Double(0)
    public var volume: Double = Double(0)
    
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
    
    public var prevKline: IMKLine!
    public var index = 0
    public weak var klineGroup: IMKLineGroup!
    
    public var sumLastClose = Double(0)
    public var sumLastVolume = Double(0)
    public var klineMAs = [Int : Double]()
    public var volumeMAs = [Int : Double]()
    public var klineEMAs = [Int : Double]()
    
    public var klinePosition = IMKLinePosition()
    public var volumePosition = IMKLineVolumePosition()
    public var klineMAPositions = [Int : CGPoint]()
    public var volumeMAPositions = [Int : CGPoint]()
    public var klineEMAPositions = [Int : CGPoint]()
    
    public var klineBoll: IMKLineBoll?
    public var sumC_MA_Square = Double(0)
    
    public var klineMACD = IMKLineMACD()
    
    public var klineKDJ = IMKLineKDJ()
    
    public var klineRSI = IMKLineRSI()
}
