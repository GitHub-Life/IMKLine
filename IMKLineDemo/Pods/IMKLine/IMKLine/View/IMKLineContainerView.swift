//
//  IMKLineContainerView.swift
//  IMKLine
//
//  Created by iMoon on 2017/12/20.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit
import SnapKit

public class IMKLineContainerView: UIView {
    
    public let scrollView = IMKLineScrollView()
    public let timeView = IMKLineTimeView()
    public let klineMAView = IMKLineMAView()
    public let klineValueView = IMKLineValueView()
    public let klineRightYView = IMKLineRightYView()
    public let volumeMAView = IMKLineVolumeMAView()
    public let volumeRightYView = IMKLineRightYView()
    public let accessoryMAView = IMKLineAccessoryMAView()
    public let accessoryRightYView = IMKLineRightYView()
    public let verticlalLine = IMKLineCrossLine.init(orientation: .portrait)
    public let horizontalLine = IMKLineCrossLine.init(orientation: .landscape)
    
    public var currentShowKline: IMKLine?
    
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
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    func setupUI() {
        self.registerOrResignNotificationObserver(isRegister: true)
        self.backgroundColor = IMKLineTheme.KLineChartBgColor
        
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
        
        self.scrollView.klineView.updateDelegate = self
        self.scrollView.volumeView.updateDelegate = self
        self.scrollView.accessoryView.updateDelegate = self
    }
    
    @objc func klineMATypeChanged() {
        self.scrollView.klineView.draw()
        if let kline = self.currentShowKline {
            self.showMA(kline: kline)
        }
    }
    
    public var showAccessory: Bool = IMKLineParamters.AccessoryType != .NONE {
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
        }
    }
    
    @objc func accessoryTypeChanged() {
        if IMKLineParamters.AccessoryType == .NONE {
            if self.showAccessory {
                self.showAccessory = false
            }
        } else {
            if !self.showAccessory {
                self.showAccessory = true
            }
            self.scrollView.accessoryView.draw(klineArray: self.scrollView.klineView.needDrawKlineArray)
        }
        if let kline = self.currentShowKline {
            self.showMA(kline: kline)
        }
    }
    
    @objc func klineStyleChanged() {
        self.scrollView.klineView.draw()
    }
    
    func registerOrResignNotificationObserver(isRegister: Bool) {
        if isRegister {
            NotificationCenter.default.addObserver(self, selector: #selector(klineMATypeChanged), name: IMKLineParamters.IMKLineMATypeChanged, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(accessoryTypeChanged), name: IMKLineParamters.IMKLineAccessoryTypeChanged, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(klineStyleChanged), name: IMKLineParamters.IMKLineStyleChanged, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self, name: IMKLineParamters.IMKLineMATypeChanged, object: nil)
            NotificationCenter.default.removeObserver(self, name: IMKLineParamters.IMKLineAccessoryTypeChanged, object: nil)
            NotificationCenter.default.removeObserver(self, name: IMKLineParamters.IMKLineStyleChanged, object: nil)
        }
    }
    
    deinit {
        self.registerOrResignNotificationObserver(isRegister: false)
    }
}

public extension IMKLineContainerView {
    
    private func setKLineRightYViewConstraint(maker: ConstraintMaker) {
        maker.top.equalTo(self.klineMAView.snp.bottom)
        maker.trailing.equalToSuperview()
        maker.width.equalTo(IMKLineConfig.RightYViewWidth)
        maker.height.equalToSuperview().multipliedBy(IMKLineConfig.KLineViewHeightRate()).offset(-IMKLineConfig.KLineViewHeightRate() * self.showMAViewHeight)
    }
    
    private func setVolumeRightYViewConstraint(maker: ConstraintMaker) {
        maker.top.equalTo(self.volumeMAView.snp.bottom)
        maker.trailing.equalToSuperview()
        maker.width.equalTo(IMKLineConfig.RightYViewWidth)
        maker.height.equalToSuperview().multipliedBy(IMKLineConfig.VolumeViewHeightRate()).offset(-IMKLineConfig.VolumeViewHeightRate() * self.showMAViewHeight)
    }
    
    public var showMAViewHeight: CGFloat {
        get {
            if showAccessory {
                return CGFloat(66)
            } else {
                return CGFloat(48)
            }
        }
    }
}

extension IMKLineContainerView: IMKLineViewUpdateDelegate {
    
    public func updateKlineRightYRange(min: Double, max: Double) {
        self.klineRightYView.set(max: max, min: min, segment: IMKLineConfig.KLineViewRightYCount, decimals: IMKLineParamters.KLineDataDecimals)
    }
    
    public func updateTimeRange(beginTimeStamp: TimeInterval, endTimeStamp: TimeInterval) {
        self.timeView.update(beginTimeStamp: beginTimeStamp, endTimeStamp: endTimeStamp)
    }
    
}

extension IMKLineContainerView: IMKLineVolumeViewUpdateDelegate {
    
    public func updateVolumeRightYRange(min: Double, max: Double) {
        self.volumeRightYView.set(max: max, min: min, segment: IMKLineConfig.VolumeViewRightYCount, decimals: IMKLineParamters.VolumeDataDecimals)
    }
    
}

extension IMKLineContainerView: IMKLineAccessoryViewUpdateDelegate {
    
    public func updateAccessoryRightYRange(min: Double, max: Double) {
        self.accessoryRightYView.set(max: max, min: min, segment: IMKLineConfig.VolumeViewRightYCount, decimals: IMKLineParamters.AccessoryDataDecimals)
    }
    
}

extension IMKLineContainerView: IMKLineScrollViewDelegate {
    
    public func selectedKline(kline: IMKLine) {
        self.showSelectedKlineInfo(kline: kline)
    }
    
    public func hideKlineInfo(lastKline: IMKLine) {
        self.klineValueView.alpha = 0
        self.horizontalLine.alpha = 0
        self.verticlalLine.alpha = 0
        
        self.showMA(kline: lastKline)
    }
    
}

public extension IMKLineContainerView {
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let selectedKline = self.scrollView.klineView.getSelectedKline(touchPoint: touches.first!.location(in: self.scrollView.klineView)) {
            self.showSelectedKlineInfo(kline: selectedKline)
        }
    }
    
    public func showSelectedKlineInfo(kline: IMKLine) {
        self.klineValueView.alpha = 1
        self.klineValueView.update(kline: kline)
        let point = self.scrollView.klineView.convert(kline.klinePosition.closePoint, to: self)
        self.horizontalLine.alpha = 1
        self.horizontalLine.update(value: String.init(format: "%.\(IMKLineParamters.KLineDataDecimals)f", kline.close))
        self.horizontalLine.snp.updateConstraints { (maker) in
            maker.centerY.equalTo(point.y)
        }
        
        self.verticlalLine.alpha = 1
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        self.verticlalLine.update(value: dateFormatter.string(from: Date.init(timeIntervalSince1970: kline.timeStamp)))
        self.verticlalLine.snp.updateConstraints { (maker) in
            maker.centerX.equalTo(point.x)
        }
        
        self.showMA(kline: kline)
    }
    
    
    public func showMA(kline: IMKLine) {
        self.currentShowKline = kline
        self.klineMAView.update(kline: kline)
        self.volumeMAView.update(kline: kline)
        self.accessoryMAView.update(kline: kline)
    }
}

// 对外公开的方法
public extension IMKLineContainerView {
    
    public func minTimeStamp() -> Double {
        return self.scrollView.klineView.getKlineGroup().minTimeStamp()
    }
    
    public func appendData(klineArray: [IMKLine]) {
        self.scrollView.klineView.appendData(klineArray: klineArray)
    }
    
    public func reloadData(klineArray: [IMKLine]) {
        self.scrollView.klineView.reloadData(klineArray: klineArray)
    }
    
    public func removeAllData() {
        self.scrollView.klineView.removeAllData()
    }
    
    public func getKlineArray() -> [IMKLine] {
        return self.scrollView.klineView.getKlineGroup().klineArray
    }
    
    public func redraw() {
        self.scrollView.klineView.draw()
    }
    
}
