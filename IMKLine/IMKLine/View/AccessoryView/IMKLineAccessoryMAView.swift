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
    
    var values = [String]()
    
    func update(values: [String]) {
        self.values = values
        for subv in self.subviews {
            subv.removeFromSuperview()
        }
        for index in 0..<values.count {
            let label = UILabel()
            label.textColor = IMKLineTheme.MAColors[index]
            label.font = UIFont.systemFont(ofSize: IMKLineTheme.AccessoryTextFontSize)
            label.text = values[index]
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

}
