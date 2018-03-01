//
//  VerificationCodeCreator.swift
//  X-Token
//
//  Created by 万涛 on 2018/2/7.
//  Copyright © 2018年 iMoon. All rights reserved.
//

import Foundation

struct VerificationCodeCreator {
    
    static func letterAndNumber(charCount: Int) -> String {
        let ms = NSMutableString()
        for _ in 0..<charCount {
            let r1 = arc4random() % 3
            var r2 = 48
            switch r1 {
            case 0:
                r2 = Int(arc4random()) % 10 + 48
            case 1:
                r2 = Int(arc4random()) % 26 + 65
            case 2:
                r2 = Int(arc4random()) % 26 + 97
            default:
                break
            }
            ms.append(String(Character(Unicode.Scalar(r2)!)))
        }
        return ms as String
    }
    
}
