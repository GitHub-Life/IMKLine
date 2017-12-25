//
//  IMKLineIndexSetContainerView.swift
//  IMKLine
//
//  Created by 万涛 on 2017/12/25.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit

enum IndexSetType: Int {
    case TimeFrame, MA, Accessory
}

protocol IMKLineIndexSetContainerViewDelegate: NSObjectProtocol {
    func setBtnClick(indexSetType: IndexSetType, selectedIndex: Int)
}

class IMKLineIndexSetContainerView: UIView {
    
    var timeFrameSetViewOrigin = CGPoint.zero {
        didSet {
            self.timeFrameSetView.snp.updateConstraints { (maker) in
                maker.top.equalTo(self.timeFrameSetViewOrigin.y)
                maker.leading.equalTo(self.timeFrameSetViewOrigin.x)
            }
        }
    }
    var maSetViewOrigin = CGPoint.zero {
        didSet {
            self.maSetView.snp.updateConstraints { (maker) in
                maker.top.equalTo(self.maSetViewOrigin.y)
                maker.leading.equalTo(self.maSetViewOrigin.x)
            }
        }
    }
    var accessorySetViewOrigin = CGPoint.zero {
        didSet {
            self.accessorySetView.snp.updateConstraints { (maker) in
                maker.top.equalTo(self.accessorySetViewOrigin.y)
                maker.leading.equalTo(self.accessorySetViewOrigin.x)
            }
        }
    }
    
    weak var delegate: IMKLineIndexSetContainerViewDelegate?
    
    let timeFrameSetView = IMKLineTimeFrameSetView()
    let maSetView = IMKLineMASetView()
    let accessorySetView = IMKLineAccessorySetView()
    
    override func awakeFromNib() {
        self.addSubview(self.timeFrameSetView)
        self.timeFrameSetView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.timeFrameSetViewOrigin.y)
            maker.leading.equalTo(self.timeFrameSetViewOrigin.x)
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        self.timeFrameSetView.btnClickResponse = { [weak self] (selectedIndex) in
            self?.delegate?.setBtnClick(indexSetType: (self?.currentIndexSetType)!, selectedIndex: selectedIndex)
            self?.hide()
        }
        
        self.addSubview(self.maSetView)
        self.maSetView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.maSetViewOrigin.y)
            maker.leading.equalTo(self.maSetViewOrigin.x)
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        self.maSetView.btnClickResponse = { [weak self] (selectedIndex) in
            self?.delegate?.setBtnClick(indexSetType: (self?.currentIndexSetType)!, selectedIndex: selectedIndex)
            self?.hide()
        }
        
        self.addSubview(self.accessorySetView)
        self.accessorySetView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.accessorySetViewOrigin.y)
            maker.leading.equalTo(self.accessorySetViewOrigin.x)
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        self.accessorySetView.btnClickResponse = { [weak self] (selectedIndex) in
            self?.delegate?.setBtnClick(indexSetType: (self?.currentIndexSetType)!, selectedIndex: selectedIndex)
            self?.hide()
        }
    }
    
    var currentIndexSetType: IndexSetType = .TimeFrame
    func showIndexSetView(indexSetType: IndexSetType, selectedIndex: Int) {
        self.currentIndexSetType = indexSetType
        self.alpha = 1
        switch indexSetType {
        case .TimeFrame:
            self.timeFrameSetView.alpha = 1
            self.timeFrameSetView.show(selectedIndex: selectedIndex)
            self.maSetView.alpha = 0
            self.accessorySetView.alpha = 0
        case .MA:
            self.timeFrameSetView.alpha = 0
            self.maSetView.alpha = 1
            self.maSetView.show(selectedIndex: selectedIndex)
            self.accessorySetView.alpha = 0
        case .Accessory:
            self.timeFrameSetView.alpha = 0
            self.maSetView.alpha = 0
            self.accessorySetView.alpha = 1
            self.accessorySetView.show(selectedIndex: selectedIndex)
        }
    }
    
    func hide() {
        self.alpha = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hide()
    }
 
}
