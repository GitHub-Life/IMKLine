//
//  IMKLineSubStruct.swift
//  IMKLine
//
//  Created by iMoon on 2017/12/22.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

public struct IMKLinePosition {
    public var openPoint = CGPoint.zero
    public var closePoint = CGPoint.zero
    public var highPoint = CGPoint.zero
    public var lowPoint = CGPoint.zero
}

public struct IMKLineVolumePosition {
    var zeroPoint = CGPoint.zero
    var volumePoint = CGPoint.zero
}

public struct IMKLineBoll {
    public var MB = Double(0)
    public var UP = Double(0)
    public var DN = Double(0)
    public var MBPoint = CGPoint.zero
    public var UPPoint = CGPoint.zero
    public var DNPoint = CGPoint.zero
    
    public init(MB: Double, UP: Double, DN: Double) {
        self.MB = MB
        self.UP = UP
        self.DN = DN
    }
}

public struct IMKLineMACD {
    public var EMA1 = Double(0)
    public var EMA2 = Double(0)
    public var DIFF = Double(0)
    public var DEA = Double(0)
    public var BAR = Double(0)
    public var zeroPoint = CGPoint.zero
    public var DIFFPoint = CGPoint.zero
    public var DEAPoint = CGPoint.zero
    public var BARPoint = CGPoint.zero
}

public struct IMKLineKDJ {
    var k = Double(50)
    var d = Double(50)
    var j = Double(0)
    var kPoint = CGPoint.zero
    var dPoint = CGPoint.zero
    var jPoint = CGPoint.zero
}

public struct IMKLineRSI {
    var klineRSIs = [Int : Double]()
    var bothRSI: (low: Double, high: Double)?
    var klineRSIPositions = [Int : CGPoint]()
}
