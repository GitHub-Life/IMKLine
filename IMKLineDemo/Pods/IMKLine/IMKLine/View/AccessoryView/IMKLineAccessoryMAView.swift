//
//  IMKLineAccessoryMAView.swift
//  IMKLine
//
//  Created by iMoon on 2017/12/20.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

public class IMKLineAccessoryMAView: UIView {
    
    public func update(kline: IMKLine) {
        for subv in self.subviews {
            subv.removeFromSuperview()
        }
        switch IMKLineParamters.AccessoryType {
        case .MACD:
            let text0 = "MACD(\(IMKLineParamters.KLineMACDPramas[0]),\(IMKLineParamters.KLineMACDPramas[1]),\(IMKLineParamters.KLineMACDPramas[2]))"
            self.addLabel(index: 0, text: text0)
            let text1 = String.init(format: "DIFF:%.\(IMKLineParamters.AccessoryDataDecimals)f", kline.klineMACD.DIFF)
            self.addLabel(index: 1, text: text1)
            let text2 = String.init(format: "DEA:%.\(IMKLineParamters.AccessoryDataDecimals)f", kline.klineMACD.DEA)
            self.addLabel(index: 2, text: text2)
            let text3 = String.init(format: "MACD:%.\(IMKLineParamters.AccessoryDataDecimals)f", abs(kline.klineMACD.BAR))
            self.addLabel(index: 3, text: text3, textColor: kline.klineMACD.BAR > 0 ? IMKLineTheme.RiseColor : IMKLineTheme.DownColor)
        case .KDJ:
            let text0 = "KDJ(\(IMKLineParamters.KLineKDJPramas[0]),\(IMKLineParamters.KLineKDJPramas[1]),\(IMKLineParamters.KLineKDJPramas[2]))"
            self.addLabel(index: 0, text: text0)
            let text1 = String.init(format: "K:%.\(IMKLineParamters.AccessoryDataDecimals)f", kline.klineKDJ.k)
            self.addLabel(index: 1, text: text1)
            let text2 = String.init(format: "D:%.\(IMKLineParamters.AccessoryDataDecimals)f", kline.klineKDJ.d)
            self.addLabel(index: 2, text: text2)
            let text3 = String.init(format: "J:%.\(IMKLineParamters.AccessoryDataDecimals)f", kline.klineKDJ.j)
            self.addLabel(index: 3, text: text3)
        case .RSI:
            let text0 = NSMutableString.init(string: "RSI(")
            for n in IMKLineParamters.KLineRSIPramas {
                text0.append("\(n),")
            }
            self.addLabel(index: 0, text: text0.substring(to: text0.length - 1) + ")")
            var index = 1
            for n in IMKLineParamters.KLineRSIPramas {
                let text = String.init(format: "RSI\(n):%.\(IMKLineParamters.AccessoryDataDecimals)f", kline.klineRSI.klineRSIs[n] ?? "0")
                self.addLabel(index: index, text: text)
                index += 1
            }
        default: break
        }
    }
    
    public func addLabel(index: Int, text: String, offset: Int = 0, textColor: UIColor? = nil) {
        let label = UILabel()
        label.textColor = textColor ?? IMKLineTheme.MAColors[index + offset]
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
