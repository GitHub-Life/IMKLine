//
//  IMKLineVolumeMAView.swift
//  IMKLine
//
//  Created by 万涛 on 2017/12/20.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

class IMKLineVolumeMAView: UIView {
    
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
        
        let volumeText = String.init(format: "量:%.3f", kline.volume)
        self.addLabel(index: 0, text: volumeText)
        
        var index = 1
        for key in kline.volumeMAs.keys.sorted() {
            let text = String.init(format: "MA\(key):%.3f", kline.volumeMAs[key]!)
            self.addLabel(index: index, text: text)
            index += 1
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
