//
//  IMKLineGroup.swift
//  IMKLine
//
//  Created by 万涛 on 2017/12/20.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit
import SwiftyJSON

class IMKLineGroup: NSObject {

    var klineArray = [IMKLine]()
    
//    convenience init(datas: JSON) {
//        self.init()
//        for klineJson in datas["data"].arrayValue {
//            let kline = IMKLine.init(json: klineJson)
//            self.klineArray.insert(kline, at: 0)
//        }
//    }
    
    static func klineArray(datas: JSON) -> [IMKLine] {
        var klineArray = [IMKLine]()
        for klineJson in datas["data"].arrayValue {
            let kline = IMKLine.init(json: klineJson)
            klineArray.insert(kline, at: 0)
        }
        return klineArray
    }
    
    func insert(klineGroup: IMKLineGroup) {
        self.klineArray.insert(contentsOf: klineGroup.klineArray, at: 0)
        self.enumerateKlines()
    }
    
    func enumerateKlines() {
        if self.klineArray.count == 0 {
            return
        }
        var prevKline = self.klineArray[0]
        prevKline.index = -1
        for kline in self.klineArray {
            kline.klineGroup = self
            kline.reset(prevKline: prevKline)
            prevKline = kline
        }
    }
}
