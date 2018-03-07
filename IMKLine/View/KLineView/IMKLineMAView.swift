//
//  IMKLineMAView.swift
//  IMKLine
//
//  Created by iMoon on 2017/12/20.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

class IMKLineMAView: UIView {
    
    func update(kline: IMKLine) {
        for subv in self.subviews {
            subv.removeFromSuperview()
        }
        switch IMKLineParamters.KLineMAType {
        case .MA:
            var index = 0
            for key in kline.klineMAs.keys.sorted() {
                let text = String.init(format: "MA\(key):%.\(IMKLineParamters.KLineDataDecimals)f", kline.klineMAs[key]!)
                self.addLabel(index: index, text: text, offset: 1)
                index += 1
            }
        case .EMA:
            var index = 0
            for key in kline.klineEMAs.keys.sorted() {
                let text = String.init(format: "EMA\(key):%.\(IMKLineParamters.KLineDataDecimals)f", kline.klineEMAs[key]!)
                self.addLabel(index: index, text: text, offset: 1)
                index += 1
            }
        case .BOLL:
            let bollText = "BOLL(\(IMKLineParamters.KLineBollPramas["N"]!), \(IMKLineParamters.KLineBollPramas["P"]!))"
            self.addLabel(index: 0, text: bollText)
            if let klineBoll = kline.klineBoll {
                let midText = String.init(format: "MID:%.\(IMKLineParamters.KLineDataDecimals)f", klineBoll.MB)
                self.addLabel(index: 1, text: midText)
                let upperText = String.init(format: "UPPER:%.\(IMKLineParamters.KLineDataDecimals)f", klineBoll.UP)
                self.addLabel(index: 2, text: upperText)
                let lowerText = String.init(format: "LOWER:%.\(IMKLineParamters.KLineDataDecimals)f", klineBoll.DN)
                self.addLabel(index: 3, text: lowerText)
            }
        default: break
        }
    }
    
    func addLabel(index: Int, text: String, offset: Int = 0) {
        let label = UILabel()
        label.textColor = IMKLineTheme.MAColors[index + offset]
        label.font = UIFont.systemFont(ofSize: IMKLineTheme.AccessoryTextFontSize)
        self.addSubview(label)
        label.snp.makeConstraints({ [weak self] (maker) in
            if index == 0 {
                maker.leading.equalToSuperview().offset(1)
            } else {
                maker.leading.equalTo((self?.subviews[index - 1].snp.trailing)!).offset(5)
            }
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
        })
        label.text = text
    }
}
