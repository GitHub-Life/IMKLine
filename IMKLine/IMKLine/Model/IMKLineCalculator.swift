//
//  IMKLineCalculator.swift
//  IMKLine
//
//  Created by 万涛 on 2017/12/22.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

extension IMKLine {
    // 重置并计算
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
        self.calculateKlineMACD()
        self.calculateKlineKDJ()
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

// MARK: - MACD值计算
extension IMKLine {
    func calculateKlineMACD() {
        self.klineMACD.EMA1 = self.klineMACD_EMA1(n: IMKLineParamters.KLineMACDPramas[0])
        self.klineMACD.EMA2 = self.klineMACD_EMA2(n: IMKLineParamters.KLineMACDPramas[1])
        self.klineMACD.DIFF = self.klineMACD.EMA1 - self.klineMACD.EMA2
        self.klineMACD.DEA = self.klineDEA(n: IMKLineParamters.KLineMACDPramas[2])
        self.klineMACD.BAR = (self.klineMACD.DIFF - self.klineMACD.DEA) * 2
    }
    
    // EMA(today) = α * Price(today) + (1 - α) * EMA(yesterday)
    // α = 2 / (N + 1)
    // EMA(today) = α * (Price(today) - EMA(yesterday)) + EMA(yesterday);
    func klineDEA(n: Int) -> Double {
        if self.index > 0 {
            return Double(2) / Double(n + 1) * (self.klineMACD.DIFF - self.prevKline.klineMACD.DEA) + self.prevKline.klineMACD.DEA
        } else {
            return self.klineMACD.DIFF
        }
    }
    
    func klineMACD_EMA1(n: Int) -> Double {
        if self.index > 0 {
            return Double(2) / Double(n + 1) * (self.close - self.prevKline.klineMACD.EMA1) + self.prevKline.klineMACD.EMA1
        } else {
            return self.close
        }
    }
    
    func klineMACD_EMA2(n: Int) -> Double {
        if self.index > 0 {
            return Double(2) / Double(n + 1) * (self.close - self.prevKline.klineMACD.EMA2) + self.prevKline.klineMACD.EMA2
        } else {
            return self.close
        }
    }
}

extension IMKLine {
    func calculateKlineKDJ() {
        let k = Double(IMKLineParamters.KLineKDJPramas[0])
        let d = Double(IMKLineParamters.KLineKDJPramas[1])
        let j = IMKLineParamters.KLineKDJPramas[2]
        let lowHigh = self.beforeMin(n: j)
        let rsv = (self.close - lowHigh.low) / (lowHigh.high - lowHigh.low) * 100
        self.klineKDJ.k = (rsv + (k - 1) * self.prevKline.klineKDJ.k) / k
        self.klineKDJ.d = (self.klineKDJ.k + (d - 1) * self.prevKline.klineKDJ.d) / d
        self.klineKDJ.j = 3 * self.klineKDJ.k - 2 * self.klineKDJ.d
    }
    
    func beforeMin(n: Int) -> (low: Double, high: Double) {
        var minIndex = self.index - (n - 1)
        if minIndex < 0 {
            minIndex = 0
        }
        var low = self.low
        var high = self.high
        for index in minIndex..<self.index {
            if self.klineGroup.klineArray[index].low < low {
                low = self.klineGroup.klineArray[index].low
            }
            if self.klineGroup.klineArray[index].high > high {
                high = self.klineGroup.klineArray[index].high
            }
        }
        return (low, high)
    }
}
