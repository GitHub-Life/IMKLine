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
    var vol: Double = Double(0)
    var count: Double = Double(0)
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].doubleValue
        self.timeStamp = json["id"].doubleValue
        self.open = json["open"].doubleValue
        self.close = json["close"].doubleValue
        self.low = json["low"].doubleValue
        self.high = json["high"].doubleValue
        self.amount = json["amount"].doubleValue
        self.vol = json["vol"].doubleValue
        self.count = json["count"].doubleValue
    }
    
    var prevKline: IMKLine?
    
    var klinePosition = IMKLinePosition()
    
    var volumePosition = IMKLineVolumePosition()
}
