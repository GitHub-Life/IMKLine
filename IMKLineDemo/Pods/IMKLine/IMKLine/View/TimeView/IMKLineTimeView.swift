//
//  IMKLineTimeView.swift
//  IMKLine
//
//  Created by iMoon on 2017/12/21.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

public class IMKLineTimeView: UIView {
    
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
    
    public let beginTimeLabel = UILabel()
    public let endTimeLabel = UILabel()
    private func setupView() {
        self.addSubview(self.beginTimeLabel)
        self.beginTimeLabel.textColor = IMKLineTheme.AccessoryTextColor
        self.beginTimeLabel.font = UIFont.systemFont(ofSize: IMKLineTheme.AccessoryTextFontSize)
        self.beginTimeLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        
        self.addSubview(self.endTimeLabel)
        self.endTimeLabel.textColor = IMKLineTheme.AccessoryTextColor
        self.endTimeLabel.font = UIFont.systemFont(ofSize: IMKLineTheme.AccessoryTextFontSize)
        self.endTimeLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
    
    public func update(beginTimeStamp: TimeInterval, endTimeStamp: TimeInterval) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        self.beginTimeLabel.text = dateFormatter.string(from: Date.init(timeIntervalSince1970: beginTimeStamp))
        self.endTimeLabel.text = dateFormatter.string(from: Date.init(timeIntervalSince1970: endTimeStamp))
    }

}
