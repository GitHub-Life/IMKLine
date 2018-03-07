//
//  IMKLineCrossLine.swift
//  IMKLine
//
//  Created by iMoon on 2017/12/21.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit
import SnapKit

enum LineOrientation: Int {
    case portrait, landscape
}

class IMKLineCrossLine: UIView {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = IMKLineTheme.TipTextColor
        label.font = UIFont.systemFont(ofSize: IMKLineTheme.TipTextFontSize)
        label.backgroundColor = IMKLineTheme.TipBgColor
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    lazy var line: UIView = {
        let line = UILabel()
        line.backgroundColor = IMKLineTheme.CrossLineColor
        return line
    }()
    
    private var orientation: LineOrientation!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    convenience init(orientation: LineOrientation) {
        self.init(frame: CGRect.zero)
        self.orientation = orientation
        self.setupView()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setupView() {
        self.addSubview(self.label)
        self.addSubview(self.line)
        if self.orientation == .portrait {
            self.label.snp.makeConstraints({ (maker) in
                maker.leading.equalToSuperview()
                maker.trailing.equalToSuperview()
                maker.bottom.equalToSuperview()
                maker.height.equalTo(IMKLineTheme.TipTextFontSize + 3)
            })
            self.line.snp.makeConstraints({ (maker) in
                maker.width.equalTo(1)
                maker.centerX.equalToSuperview()
                maker.top.equalToSuperview()
                maker.bottom.equalTo(self.label.snp.top)
            })
        } else {
            self.label.snp.makeConstraints({ (maker) in
                maker.trailing.equalToSuperview()
                maker.top.equalToSuperview()
                maker.bottom.equalToSuperview()
                maker.width.equalTo(IMKLineConfig.RightYViewWidth)
            })
            self.line.snp.makeConstraints({ (maker) in
                maker.height.equalTo(1)
                maker.centerY.equalToSuperview()
                maker.leading.equalToSuperview()
                maker.trailing.equalTo(self.label.snp.leading)
            })
        }
    }
    
    func update(value: String) {
        self.label.text = " \(value) "
    }
    
}
