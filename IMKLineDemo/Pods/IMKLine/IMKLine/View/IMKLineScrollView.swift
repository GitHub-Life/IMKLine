//
//  IMKLineScrollView.swift
//  IMKLine
//
//  Created by iMoon on 2017/12/20.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit
import SnapKit

public protocol IMKLineScrollViewDelegate: NSObjectProtocol {
    func selectedKline(kline: IMKLine)
    func hideKlineInfo(lastKline: IMKLine)
}

public class IMKLineScrollView: UIScrollView {
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public weak var imDelegate: IMKLineScrollViewDelegate?
    public var loadMore: (()->())?
    
    public let klineView = IMKLineView()
    public let volumeView = IMKLineVolumeView()
    public let accessoryView = IMKLineAccessoryView()
    
    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.bounces = false
        self.delegate = self
        self.maximumZoomScale = 20
        self.minimumZoomScale = 1
        
        self.addSubview(self.klineView)
        self.klineView.superScrollView = self
        self.klineView.snp.makeConstraints { [weak self] (maker) in
            self?.setKLineViewConstraint(maker: maker)
        }
        
        let separator1 = UIView()
        separator1.backgroundColor = IMKLineTheme.BorderColor
        self.addSubview(separator1)
        separator1.snp.makeConstraints { [weak self] (maker) in
            maker.top.equalTo((self?.klineView.snp.bottom)!)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(1)
            maker.width.equalTo((self?.klineView.snp.width)!)
        }
        
        self.addSubview(self.volumeView)
        self.volumeView.klineView = self.klineView
        self.volumeView.snp.makeConstraints { [weak self] (maker) in
            self?.setVolumeViewConstraint(maker: maker)
        }
        
        let separator2 = UIView()
        separator2.backgroundColor = IMKLineTheme.BorderColor
        self.addSubview(separator2)
        separator2.snp.makeConstraints { [weak self] (maker) in
            maker.top.equalTo((self?.volumeView.snp.bottom)!)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(1)
            maker.width.equalTo((self?.klineView.snp.width)!)
        }
        
        self.addSubview(self.accessoryView)
        self.accessoryView.klineView = self.klineView
        self.accessoryView.snp.makeConstraints { [weak self] (maker) in
            maker.top.equalTo((self?.volumeView.snp.bottom)!).offset(17)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalToSuperview().multipliedBy(IMKLineConfig.AccessoryViewHeightRate()).offset(-(self?.showMAViewHeight)! * IMKLineConfig.AccessoryViewHeightRate())
            maker.width.equalTo((self?.klineView.snp.width)!)
        }
        
        let pinchGr = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchGrResponse(pinchGr:)))
        self.addGestureRecognizer(pinchGr)
    }
    
    public var showAccessory: Bool = IMKLineParamters.AccessoryType != .NONE {
        didSet {
            self.klineView.snp.remakeConstraints { [weak self] (maker) in
                self?.setKLineViewConstraint(maker: maker)
            }
            self.volumeView.snp.remakeConstraints { [weak self] (maker) in
                self?.setVolumeViewConstraint(maker: maker)
            }
        }
    }
    
    var oldScale = CGFloat(1)
    @objc func pinchGrResponse(pinchGr: UIPinchGestureRecognizer) {
        if pinchGr.numberOfTouches == 2 {
            let diff = pinchGr.scale - oldScale
            if abs(diff) > IMKLineConfig.ZoomScaleLimit {
                oldScale = pinchGr.scale
                let startIndex = Int((self.contentOffset.x - IMKLineConfig.KLineGap) / (IMKLineConfig.KLineGap + IMKLineConfig.KLineWidth))
                if IMKLineParamters.changeZoomScale(changeScale: diff > 0 ? IMKLineConfig.ZoomScaleFactor : -IMKLineConfig.ZoomScaleFactor) {
                    let startKlinePointX = CGFloat(startIndex) * (IMKLineConfig.KLineGap + IMKLineConfig.KLineWidth) + IMKLineConfig.KLineGap
                    self.klineView.updateViewWidth()
                    self.setContentOffset(CGPoint.init(x: startKlinePointX, y: 0), animated: false)
                    self.klineView.draw()
                }
            }
        }
    }
    
}

public extension IMKLineScrollView {
    
    private func setKLineViewConstraint(maker: ConstraintMaker) {
        maker.top.equalToSuperview()
        maker.leading.equalToSuperview()
        maker.trailing.equalToSuperview()
        maker.height.equalToSuperview().multipliedBy(IMKLineConfig.KLineViewHeightRate()).offset(-self.showMAViewHeight * IMKLineConfig.KLineViewHeightRate())
        maker.width.equalTo(self.klineView.viewWidth)
    }
    
    private func setVolumeViewConstraint(maker: ConstraintMaker) {
        maker.top.equalTo(self.klineView.snp.bottom).offset(17)
        maker.leading.equalToSuperview()
        maker.trailing.equalToSuperview()
        maker.width.equalTo(self.klineView.snp.width)
        maker.height.equalToSuperview().multipliedBy(IMKLineConfig.VolumeViewHeightRate()).offset(-self.showMAViewHeight * IMKLineConfig.VolumeViewHeightRate())
    }
    
    var showMAViewHeight: CGFloat {
        get {
            if IMKLineParamters.AccessoryType != .NONE {
                return CGFloat(36)
            } else {
                return CGFloat(18)
            }
        }
    }
}

extension IMKLineScrollView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.klineView.draw()
        if self.klineView.getKlineGroup().klineArray.count > 0 {
            self.imDelegate?.hideKlineInfo(lastKline: self.klineView.getKlineGroup().klineArray.last!)
        } else {
            self.imDelegate?.hideKlineInfo(lastKline: IMKLine())
        }
        if scrollView.contentOffset.x <= 0 {
            self.loadMore?()
        }
    }
}

extension IMKLineScrollView {
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self.klineView)
        if let selectedKline = self.klineView.getSelectedKline(touchPoint: point) {
            self.imDelegate?.selectedKline(kline: selectedKline)
        }
    }
    
}
