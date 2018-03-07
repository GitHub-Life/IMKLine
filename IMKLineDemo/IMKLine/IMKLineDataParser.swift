//
//  IMKLineDataParser.swift
//  X-Token
//
//  Created by iMoon on 2018/3/3.
//  Copyright © 2018年 iMoon. All rights reserved.
//

import Foundation
import SwiftyJSON

extension IMKLine {
    
    convenience init(json: JSON) {
        self.init()
        self.timeStamp = json["timestamp"].doubleValue
        self.open = json["open"].doubleValue
        self.close = json["close"].doubleValue
        self.low = json["low"].doubleValue
        self.high = json["high"].doubleValue
        self.volume = json["volume"].doubleValue
    }
    
}

extension IMKLineGroup {
    
    static func klineArray(klineJsonArray: [JSON]) -> [IMKLine] {
        var klineArray = [IMKLine]()
        for klineJson in klineJsonArray {
            let kline = IMKLine.init(json: klineJson)
            klineArray.insert(kline, at: 0)
        }
        return klineArray
    }
    
}
