//
//  IMKLineAccessoryMAView.swift
//  IMKLine
//
//  Created by 万涛 on 2017/12/20.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

class IMKLineAccessoryMAView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func update(kline: IMKLine) {
        for subv in self.subviews {
            subv.removeFromSuperview()
        }
        switch IMKLineParamters.AccessoryType {
        case .MACD:
            let text0 = "MACD(\(IMKLineParamters.KLineMACDPramas[0]),\(IMKLineParamters.KLineMACDPramas[1]),\(IMKLineParamters.KLineMACDPramas[2]))"
            self.addLabel(index: 0, text: text0)
            let text1 = String.init(format: "DIFF:%.3f", kline.klineMACD.DIFF)
            self.addLabel(index: 1, text: text1)
            let text2 = String.init(format: "DEA:%.3f", kline.klineMACD.DEA)
            self.addLabel(index: 2, text: text2)
            let text3 = String.init(format: "MACD:%.3f", kline.klineMACD.BAR)
            self.addLabel(index: 3, text: text3)
//        case .KDJ:
//        case .RSI:
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
