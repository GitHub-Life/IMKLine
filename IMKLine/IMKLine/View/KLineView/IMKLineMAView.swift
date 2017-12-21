//
//  IMKLineMAView.swift
//  IMKLine
//
//  Created by 万涛 on 2017/12/20.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

class IMKLineMAView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    var values = [Int : Double]()
    
    func update(values: [Int : Double]) {
        self.values = values
        for subv in self.subviews {
            subv.removeFromSuperview()
        }
        let keys = values.keys.sorted()
        for index in 0..<values.count {
            let label = UILabel()
            label.textColor = IMKLineTheme.MAColors[index + 1]
            label.font = UIFont.systemFont(ofSize: IMKLineTheme.AccessoryTextFontSize)
            label.text = String.init(format: "MA\(keys[index]):%.2f", values[keys[index]]!)
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
