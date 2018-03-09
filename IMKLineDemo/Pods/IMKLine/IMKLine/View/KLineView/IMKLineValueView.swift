//
//  IMKLineValueView.swift
//  IMKLine
//
//  Created by iMoon on 2017/12/20.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

public class IMKLineValueView: UIView {
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    private func setupView() {
        self.backgroundColor = IMKLineTheme.KLineValueBgColor
        for index in 0..<self.valueTips.count {
            let label = UILabel()
            label.textColor = IMKLineTheme.TipTextColor
            label.font = UIFont.systemFont(ofSize: IMKLineTheme.TipTextFontSize)
            label.text = "\(self.valueTips[index])--"
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
        }
    }
    //
    public let valueTips = ["Open ", "High ", "Low ", "Close ", "Percent "]
    public var kline = IMKLine()
    
    public func update(kline: IMKLine) {
        self.kline = kline
        
        (self.subviews[0] as! UILabel).text = String.init(format: "\(self.valueTips[0])%.\(IMKLineParamters.KLineDataDecimals)f", kline.open)
        (self.subviews[1] as! UILabel).text = String.init(format: "\(self.valueTips[1])%.\(IMKLineParamters.KLineDataDecimals)f", kline.high)
        (self.subviews[2] as! UILabel).text = String.init(format: "\(self.valueTips[2])%.\(IMKLineParamters.KLineDataDecimals)f", kline.low)
        (self.subviews[3] as! UILabel).text = String.init(format: "\(self.valueTips[3])%.\(IMKLineParamters.KLineDataDecimals)f", kline.close)
        
        let percent = (kline.close - kline.open) / kline.open * 100
        let percentStr = String.init(format: "\(valueTips.last!)\((percent < 0 ? "" : "+"))%.2f%%", percent)
        (self.subviews.last as! UILabel).text = percentStr
    }

}
