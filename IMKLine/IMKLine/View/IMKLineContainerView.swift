//
//  IMKLineContainerView.swift
//  IMKLine
//
//  Created by 万涛 on 2017/12/20.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit
import SnapKit

class IMKLineContainerView: UIView {
    
    let scrollView = IMKLineScrollView()
    let timeView = IMKLineTimeView()
    let klineMAView = IMKLineMAView()
    let klineValueView = IMKLineValueView()
    let klineRightYView = IMKLineRightYView()
    let volumeMAView = IMKLineVolumeMAView()
    let volumeRightYView = IMKLineRightYView()
    let accessoryMAView = IMKLineAccessoryMAView()
    let accessoryRightYView = IMKLineRightYView()
    let verticlalLine = IMKLineCrossLine.init(orientation: .portrait)
    let horizontalLine = IMKLineCrossLine.init(orientation: .landscape)
    
    // 子视图 纵向 高度布局
    // ------- 15 -----
    // --- 3x -----
    // ---------1------
    // ------- 17 -----
    // --- 1x -----
    // ---------1------
    // ------- 17 -----
    // --- 1x -----
    // -------- 15 ----
    
    override func awakeFromNib() {
        
        self.addSubview(self.klineMAView)
        self.klineMAView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalTo(IMKLineConfig.RightYViewWidth)
            maker.height.equalTo(15)
        }
        
        self.addSubview(self.timeView)
        self.timeView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalTo(-IMKLineConfig.RightYViewWidth)
            maker.bottom.equalToSuperview()
            maker.height.equalTo(15)
        }
        
        self.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { [weak self] (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalTo(-IMKLineConfig.RightYViewWidth)
            maker.top.equalTo((self?.klineMAView.snp.bottom)!)
            maker.bottom.equalTo((self?.timeView.snp.top)!)
        }
        self.scrollView.layer.borderColor = IMKLineTheme.BorderColor.cgColor
        self.scrollView.layer.borderWidth = 1
        self.scrollView.imDelegate = self
        
        self.addSubview(self.klineRightYView)
        self.klineRightYView.snp.makeConstraints { [weak self] (maker) in
            self?.setKLineRightYViewConstraint(maker: maker)
        }
        
        self.addSubview(self.volumeMAView)
        self.volumeMAView.snp.makeConstraints { [weak self] (maker) in
            maker.leading.equalTo((self?.scrollView.snp.leading)!)
            maker.trailing.equalTo((self?.scrollView.snp.trailing)!)
            maker.height.equalTo(17)
            maker.top.equalTo((self?.klineRightYView.snp.bottom)!)
        }
        
        self.addSubview(self.volumeRightYView)
        self.volumeRightYView.snp.makeConstraints { [weak self] (maker) in
            self?.setVolumeRightYViewConstraint(maker: maker)
        }
        
        self.addSubview(self.accessoryMAView)
        self.accessoryMAView.snp.makeConstraints { [weak self] (maker) in
            maker.leading.equalTo((self?.scrollView.snp.leading)!)
            maker.trailing.equalTo((self?.scrollView.snp.trailing)!)
            maker.height.equalTo(17)
            maker.top.equalTo((self?.volumeRightYView.snp.bottom)!)
        }
        
        self.addSubview(self.accessoryRightYView)
        self.accessoryRightYView.snp.makeConstraints { [weak self] (maker) in
            maker.top.equalTo((self?.accessoryMAView.snp.bottom)!)
            maker.trailing.equalToSuperview()
            maker.width.equalTo(IMKLineConfig.RightYViewWidth)
            maker.height.equalToSuperview().multipliedBy(IMKLineConfig.AccessoryViewHeightRate()).offset(-IMKLineConfig.AccessoryViewHeightRate() * (self?.showMAViewHeight)!)
        }
        
        self.addSubview(self.horizontalLine)
        self.horizontalLine.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.centerY.equalTo(0)
        }
        self.horizontalLine.alpha = 0
        
        self.addSubview(self.verticlalLine)
        self.verticlalLine.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.scrollView.snp.top)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(IMKLineTheme.TipTextFontSize + 3)
            maker.centerX.equalTo(0)
        }
        self.verticlalLine.alpha = 0
        
        self.addSubview(self.klineValueView)
        self.klineValueView.snp.makeConstraints { [weak self] (maker) in
            maker.top.equalTo((self?.scrollView.snp.top)!)
            maker.leading.equalTo((self?.scrollView.snp.leading)!)
            maker.trailing.equalTo((self?.scrollView.snp.trailing)!)
            maker.height.equalTo(17)
        }
        self.klineValueView.alpha = 0
        
        self.scrollView.klineView.delegate = self
        self.scrollView.volumeView.delegate = self
        
//        self.klineMAView.update(values: [7:15738.872, 15:15612.543, 30:15550.8769, 5:15738.872, 20:15612.543, 60:15550.8769])
//        self.beginTimeLabel.text = "12-19 18:00"
//        self.endTimeLabel.text = "12-19 19:05"
//        self.klineValueView.update(values: [16100, 16199.35, 16100, 16196.52, 0.6])
//        self.volumeMAView.update(values: [0:33.68, 7:24.76, 15:26.16, 30:26.36, 6:24.76, 20:26.16, 60:26.36])
//        self.accessoryMAView.update(values: ["MACD(12,26,9)", "DIFF:33,040", "DEA:77.544", "MACD:-89.008", "MACD(12,26,9)", "DIFF:33,040", "DEA:77.544", "MACD:-89.008"])
//        self.klineRightYView.set(max: 18344.94, min: 16284.78, segment: 5, decimals: 3)
//        self.volumeRightYView.set(max: 74.014, min: 0, segment: 3, decimals: 3)
//        self.accessoryRightYView.set(max: 100.00, min: 0, segment: 3, decimals: 2)
    }
    
    var showAccessory: Bool = true {
        didSet {
            self.klineRightYView.snp.remakeConstraints { [weak self] (maker) in
                self?.setKLineRightYViewConstraint(maker: maker)
            }
            self.volumeRightYView.snp.remakeConstraints { [weak self] (maker) in
                self?.setVolumeRightYViewConstraint(maker: maker)
            }
            self.accessoryMAView.alpha = showAccessory ? 1 : 0
            self.accessoryRightYView.alpha = showAccessory ? 1 : 0
            self.scrollView.showAccessory = showAccessory
            self.layoutIfNeeded()
        }
    }
}

extension IMKLineContainerView {
    
    private func setKLineRightYViewConstraint(maker: ConstraintMaker) {
        maker.top.equalTo(self.klineMAView.snp.bottom)
        maker.trailing.equalToSuperview()
        maker.width.equalTo(IMKLineConfig.RightYViewWidth)
        maker.height.equalToSuperview().multipliedBy(IMKLineConfig.KLineViewHeightRate(showAccessory: self.showAccessory)).offset(-IMKLineConfig.KLineViewHeightRate(showAccessory: self.showAccessory) * self.showMAViewHeight)
    }
    
    private func setVolumeRightYViewConstraint(maker: ConstraintMaker) {
        maker.top.equalTo(self.volumeMAView.snp.bottom)
        maker.trailing.equalToSuperview()
        maker.width.equalTo(IMKLineConfig.RightYViewWidth)
        maker.height.equalToSuperview().multipliedBy(IMKLineConfig.VolumeViewHeightRate(showAccessory: self.showAccessory)).offset(-IMKLineConfig.VolumeViewHeightRate(showAccessory: self.showAccessory) * self.showMAViewHeight)
    }
    
    var showMAViewHeight: CGFloat {
        get {
            if showAccessory {
                return CGFloat(66)
            } else {
                return CGFloat(48)
            }
        }
    }
}

extension IMKLineContainerView: IMKLineViewDelegate {
    
    func updateKlineRightYRange(min: Double, max: Double) {
        self.klineRightYView.set(max: max, min: min, segment: IMKLineConfig.KLineViewRightYCount, decimals: 3)
    }
    
    func updateTimeRange(beginTimeStamp: TimeInterval, endTimeStamp: TimeInterval) {
        self.timeView.update(beginTimeStamp: beginTimeStamp, endTimeStamp: endTimeStamp)
    }
    
}

extension IMKLineContainerView: IMKLineVolumeViewDelegate {
    
    func updateVolumeRightYRange(min: Double, max: Double) {
        self.volumeRightYView.set(max: max, min: min, segment: IMKLineConfig.VolumeViewRightYCount, decimals: 3)
    }
    
}

extension IMKLineContainerView {
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let selectedKline = self.scrollView.klineView.getSelectedKline(touchPoint: touches.first!.location(in: self.scrollView.klineView))
        self.showSelectedKlineInfo(kline: selectedKline)
    }
    
    func showSelectedKlineInfo(kline: IMKLine) {
        self.klineValueView.alpha = 1
        self.klineValueView.update(kline: kline)
        let point = self.scrollView.klineView.convert(kline.klinePosition.closePoint, to: self)
        self.horizontalLine.alpha = 1
        self.horizontalLine.update(value: String.init(format: "%.3f", kline.close))
        self.horizontalLine.snp.updateConstraints { (maker) in
            maker.centerY.equalTo(point.y)
        }
        
        self.volumeMAView.update(values: [0:kline.vol])
        
        self.verticlalLine.alpha = 1
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        self.verticlalLine.update(value: dateFormatter.string(from: Date.init(timeIntervalSince1970: kline.timeStamp)))
        self.verticlalLine.snp.updateConstraints { (maker) in
            maker.centerX.equalTo(point.x)
        }
    }
}

extension IMKLineContainerView: IMKLineScrollViewDelegate {
    
    func selectedKline(kline: IMKLine) {
        self.showSelectedKlineInfo(kline: kline)
    }
    
    func hideKlineInfo() {
        self.klineValueView.alpha = 0
        self.horizontalLine.alpha = 0
        self.verticlalLine.alpha = 0
    }
    
}
