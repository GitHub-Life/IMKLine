//
//  IMKLineTool.swift
//  XToken
//
//  Created by iMoon on 2017/12/30.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import Foundation

struct IMKLineTool {
    
    static func dataDecimals(_ v1: Double, _ v2: Double) -> Int {
        let mv = (v1 + v2) / 2
        if mv < 1 {
            return IMKLineConfig.DataDecimals
        } else if mv < 10 && IMKLineConfig.DataDecimals > 1 {
            return IMKLineConfig.DataDecimals - 1
        } else if mv < 100 && IMKLineConfig.DataDecimals > 2 {
            return IMKLineConfig.DataDecimals - 2
        } else if mv < 1000 && IMKLineConfig.DataDecimals > 3 {
            return IMKLineConfig.DataDecimals - 3
        } else if mv < 10000 && IMKLineConfig.DataDecimals > 4 {
            return IMKLineConfig.DataDecimals - 4
        } else if mv < 100000 && IMKLineConfig.DataDecimals > 5 {
            return IMKLineConfig.DataDecimals - 5
        } else if mv < 1000000 && IMKLineConfig.DataDecimals > 6 {
            return IMKLineConfig.DataDecimals - 6
        }
        return 0
    }
    
}
