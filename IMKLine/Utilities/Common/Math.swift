//
//  XTMath.swift
//  XToken
//
//  Created by 万涛 on 2017/12/16.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

class Math: NSObject {
    
    /// 最小公倍数
    ///
    /// - Parameters:
    ///   - num1:
    ///   - num2:
    /// - Returns: 最小公倍数
    static func leastCommonMultiple(num1: Int, num2: Int) -> Int {
        let maxNum = max(num1, num2)
        if maxNum % num1 == 0 && maxNum % num2 == 0 {
            return maxNum
        }
        var lcm = maxNum
        repeat {
            lcm += maxNum
        } while (lcm % num1 != 0 || lcm % num2 != 0)
        return lcm
    }
}
