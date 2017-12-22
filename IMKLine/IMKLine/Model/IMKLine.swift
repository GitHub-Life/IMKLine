//
//  IMKLine.swift
//  IMKLine
//
//  Created by 万涛 on 2017/12/20.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit
import SwiftyJSON

struct IMKLinePosition {
    var openPoint: CGPoint = CGPoint.zero
    var closePoint: CGPoint = CGPoint.zero
    var highPoint: CGPoint = CGPoint.zero
    var lowPoint: CGPoint = CGPoint.zero
}

struct IMKLineVolumePosition {
    var zeroPoint: CGPoint = CGPoint.zero
    var volumePoint: CGPoint = CGPoint.zero
}

class IMKLine: NSObject {
    
    var id: Double = Double(0)
    var timeStamp: Double = Double(0)
    var open: Double = Double(0)
    var close: Double = Double(0)
    var low: Double = Double(0)
    var high: Double = Double(0)
    var amount: Double = Double(0)
    var volume: Double = Double(0)
    var count: Double = Double(0)
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].doubleValue
        self.timeStamp = self.id
        self.open = json["open"].doubleValue
        self.close = json["close"].doubleValue
        self.low = json["low"].doubleValue
        self.high = json["high"].doubleValue
        self.amount = json["amount"].doubleValue
        self.volume = json["vol"].doubleValue
        self.count = json["count"].doubleValue
    }
    
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
    
    func reset(prevKline: IMKLine) {
        self.prevKline = prevKline
        self.index = prevKline.index + 1
        self.sumLastClose = self.close + self.prevKline.sumLastClose
        self.sumLastVolume = self.volume + self.prevKline.sumLastVolume
        self.klineMAs.removeAll()
        for ma in IMKLineConfig.KLineMAs {
            self.klineMAs[ma] = self.klineMA(n: ma)
            self.volumeMAs[ma] = self.volumeMA(n: ma)
        }
        for ema in IMKLineConfig.KLineEMAs {
            self.klineEMAs[ema] = self.klineEMA(n: ema)
        }
    }
    
    func klineMA(n: Int) -> Double {
        if self.index > n - 1 {
            return (self.sumLastClose - self.klineGroup.klineArray[self.index - n].sumLastClose) / Double(n)
        } else if self.index == n - 1 {
            return self.sumLastClose / Double(n)
        }
        return Double(-1)
    }
    
    func volumeMA(n: Int) -> Double {
        if self.index > n - 1 {
            return (self.sumLastVolume - self.klineGroup.klineArray[self.index - n].sumLastVolume) / Double(n)
        } else if self.index == n - 1 {
            return self.sumLastVolume / Double(n)
        }
        return Double(-1)
    }
    
    // EMA(today) = α * Price(today) + (1 - α) * EMA(yesterday)
    // α = 2 / (N + 1)
    // EMA(today) = α * (Price(today) - EMA(yesterday)) + EMA(yesterday);
    func klineEMA(n: Int) -> Double {
        if self.index > 0 {
            return Double(2) / Double(n + 1) * (self.close - self.prevKline.klineEMAs[n]!) + self.prevKline.klineEMAs[n]!
        } else {
            return self.close
        }
    }
}
