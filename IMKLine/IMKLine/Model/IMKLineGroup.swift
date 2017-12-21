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
    
    convenience init(datas: JSON) {
        self.init()
        var prevKline = IMKLine()
        for klineJson in datas["data"].arrayValue {
            let kline = IMKLine.init(json: klineJson)
            kline.prevKline = prevKline
            self.klineArray.insert(kline, at: 0)
            prevKline = kline
        }
    }
    
    func insert(klineGroup: IMKLineGroup) {
        self.klineArray.insert(contentsOf: klineGroup.klineArray, at: 0)
    }
    
}
