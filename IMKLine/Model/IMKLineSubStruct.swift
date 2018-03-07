//
//  IMKLineSubStruct.swift
//  IMKLine
//
//  Created by iMoon on 2017/12/22.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

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
    var MB = Double(0)
    var UP = Double(0)
    var DN = Double(0)
    var MBPoint = CGPoint.zero
    var UPPoint = CGPoint.zero
    var DNPoint = CGPoint.zero
    
    init(MB: Double, UP: Double, DN: Double) {
        self.MB = MB
        self.UP = UP
        self.DN = DN
    }
}

struct IMKLineMACD {
    var EMA1 = Double(0)
    var EMA2 = Double(0)
    var DIFF = Double(0)
    var DEA = Double(0)
    var BAR = Double(0)
    var zeroPoint = CGPoint.zero
    var DIFFPoint = CGPoint.zero
    var DEAPoint = CGPoint.zero
    var BARPoint = CGPoint.zero
}

struct IMKLineKDJ {
    var k = Double(50)
    var d = Double(50)
    var j = Double(0)
    var kPoint = CGPoint.zero
    var dPoint = CGPoint.zero
    var jPoint = CGPoint.zero
}

struct IMKLineRSI {
    var klineRSIs = [Int : Double]()
    var bothRSI: (low: Double, high: Double)?
    var klineRSIPositions = [Int : CGPoint]()
}
