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
    var openPoint = CGPoint.zero
    var closePoint = CGPoint.zero
    var highPoint = CGPoint.zero
    var lowPoint = CGPoint.zero
}

struct IMKLineVolumePosition {
    var zeroPoint = CGPoint.zero
    var volumePoint = CGPoint.zero
}

struct IMKLineBoll {
    var MB: Double = Double(0)
    var UP: Double = Double(0)
    var DN: Double = Double(0)
    var MBPoint = CGPoint.zero
    var UPPoint = CGPoint.zero
    var DNPoint = CGPoint.zero
    
    init(MB: Double, UP: Double, DN: Double) {
        self.MB = MB
        self.UP = UP
        self.DN = DN
    }
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
    
    var klineBoll: IMKLineBoll?
    var sumC_MA_Square = Double(0)
}

extension IMKLine {
    func reset(prevKline: IMKLine) {
        self.prevKline = prevKline
        self.index = prevKline.index + 1
        self.sumLastClose = self.close + self.prevKline.sumLastClose
        self.sumLastVolume = self.volume + self.prevKline.sumLastVolume
        self.klineMAs.removeAll()
        for ma in IMKLineParamters.KLineMAs {
            self.klineMAs[ma] = self.klineMA(n: ma) ?? Double(-1)
            self.volumeMAs[ma] = self.volumeMA(n: ma) ?? Double(-1)
        }
        for ema in IMKLineParamters.KLineEMAs {
            self.klineEMAs[ema] = self.klineEMA(n: ema)
        }
        self.calculateKlineBoll()
    }
}

// MARK: - 普通均值计算
extension IMKLine {
    /// KLine MA
    func klineMA(n: Int) -> Double? {
        if self.index > n - 1 {
            return (self.sumLastClose - self.klineGroup.klineArray[self.index - n].sumLastClose) / Double(n)
        } else if self.index == n - 1 {
            return self.sumLastClose / Double(n)
        }
        return nil
    }
    /// Volume MA
    func volumeMA(n: Int) -> Double? {
        if self.index > n - 1 {
            return (self.sumLastVolume - self.klineGroup.klineArray[self.index - n].sumLastVolume) / Double(n)
        } else if self.index == n - 1 {
            return self.sumLastVolume / Double(n)
        }
        return nil
    }
}

// MARK: - EMA值计算
extension IMKLine {
    
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

// MARK: - BOLL值计算
extension IMKLine {
    
    func calculateKlineBoll() {
        let n = IMKLineParamters.KLineBollPramas["N"]!
        let p = IMKLineParamters.KLineBollPramas["P"]!
        self.calculateSumC_MA_Square(n: n)
        if self.index >= n {
            let MB = self.klineMA(n: n - 1)!
            let MD = sqrt((self.sumC_MA_Square - self.klineGroup.klineArray[self.index - n].sumC_MA_Square) / Double(n))
            let UP = MB + Double(p) * MD
            let DN = MB - Double(p) * MD
            self.klineBoll = IMKLineBoll.init(MB: MB, UP: UP, DN: DN)
        }
    }
    
    func calculateSumC_MA_Square(n: Int) {
        if let MA = self.klineMA(n: n) {
            let C_MA = self.close - MA
            let C_MA_Square = C_MA * C_MA
            self.sumC_MA_Square = C_MA_Square + self.prevKline.sumC_MA_Square
        }
    }
    
}
