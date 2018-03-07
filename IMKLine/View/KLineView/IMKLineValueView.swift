//
//  IMKLineValueView.swift
//  IMKLine
//
//  Created by iMoon on 2017/12/20.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

class IMKLineValueView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
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
    let valueTips = ["\(IMLangHelper.getString("kline_opening")) ", "\(IMLangHelper.getString("kline_high")) ", "\(IMLangHelper.getString("kline_low")) ", "\(IMLangHelper.getString("kline_closing")) ", "\(IMLangHelper.getString("kline_percent")) "]
    var kline = IMKLine()
    
    func update(kline: IMKLine) {
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
