//
//  IMKLineMASetView.swift
//  IMKLine
//
//  Created by 万涛 on 2017/12/23.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

class IMKLineMASetView: UIView {
    
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
    
//    override func awakeFromNib() {
//        self.setupView()
//    }
    
    let NumOfRow = 5
    let BtnWidth = 50
    let BtnHeight = 40
    var btnClickResponse: ((Int) -> ())?
    
    func setupView() {
        var index = 0
        for text in IMKLineMAType.RawValues {
            let btn = UIButton()
            btn.tag = index
            btn.setTitle(text, for: .normal)
            btn.setTitleColor(IMKLineTheme.BtnNormalColor, for: .normal)
            btn.setTitleColor(IMKLineTheme.BtnSelectedColor, for: .selected)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: IMKLineTheme.BtnFontSize)
            btn.backgroundColor = IMKLineTheme.IndexSetBgColor
            self.addSubview(btn)
            btn.snp.makeConstraints({ (maker) in
                maker.size.equalTo(CGSize.init(width: BtnWidth, height: BtnHeight))
                maker.top.equalTo(index / NumOfRow * BtnHeight)
                maker.leading.equalTo(index % NumOfRow * BtnWidth)
            })
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            
            index += 1
        }
    }
    
    @objc func btnClick(btn: UIButton) {
        self.btnClickResponse?(btn.tag)
    }
    
    func show(selectedIndex: Int) {
        if selectedIndex < 0 || selectedIndex > self.subviews.count {
            self.alpha = 0
        } else {
            for v in self.subviews {
                let btn = v as! UIButton
                btn.isSelected = (btn.tag == selectedIndex)
            }
            self.alpha = 1
        }
    }

}
