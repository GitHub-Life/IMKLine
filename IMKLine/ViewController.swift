//
//  ViewController.swift
//  IMKLine
//
//  Created by 万涛 on 2017/12/19.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBOutlet weak var klineContainerView: IMKLineContainerView!
    @IBOutlet weak var indexSetContainerView: IMKLineIndexSetContainerView!
    @IBOutlet weak var timeFrameSetBtn: UIButton!
    @IBOutlet weak var MASetBtn: UIButton!
    @IBOutlet weak var accessorySetBtn: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getKlineDatas()
        self.indexSetContainerView.delegate = self
        self.indexSetContainerView.timeFrameSetViewOrigin = CGPoint.init(x: 0, y: 40)
        self.indexSetContainerView.maSetViewOrigin = CGPoint.init(x: 0, y: 40)
        self.indexSetContainerView.accessorySetViewOrigin = CGPoint.init(x: 0, y: 40)
    }
    
    func getKlineDatas() {
        DispatchQueue.global().async {
            let dataJsonPath = Bundle.main.path(forResource: "data", ofType: "json")!
            let data = FileManager.default.contents(atPath: dataJsonPath)!
            do {
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                let json = JSON(jsonObj)
                DispatchQueue.main.async(execute: {
                    let klineGroup = IMKLineGroup()
                    klineGroup.klineArray = IMKLineGroup.klineArray(datas: json)
                    self.klineContainerView.scrollView.klineView.add(klineGroup: klineGroup)
                })
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func timeFrameSetBtnClick(sender: UIButton) {
        self.indexSetContainerView.showIndexSetView(indexSetType: .TimeFrame, selectedIndex: sender.tag)
    }
    
    @IBAction func MASetBtnClick(sender: UIButton) {
        self.indexSetContainerView.showIndexSetView(indexSetType: .MA, selectedIndex: sender.tag)
    }
    
    @IBAction func accessorySetBtnClick(sender: UIButton) {
        self.indexSetContainerView.showIndexSetView(indexSetType: .Accessory, selectedIndex: sender.tag)
    }
    
}

extension ViewController: IMKLineIndexSetContainerViewDelegate {
    
    func setBtnClick(indexSetType: IndexSetType, selectedIndex: Int) {
        switch indexSetType {
        case .TimeFrame:
            self.timeFrameSetBtn.tag = selectedIndex
            self.timeFrameSetBtn.setTitle(IMKLineParamters.KLineMATimeFrames[selectedIndex], for: .normal)
        case .MA:
            self.MASetBtn.tag = selectedIndex
            self.MASetBtn.setTitle(IMKLineMAType.RawValues[selectedIndex], for: .normal)
            IMKLineParamters.KLineMAType = IMKLineMAType.enumValue(index: selectedIndex)
        case .Accessory:
            self.accessorySetBtn.tag = selectedIndex
            self.accessorySetBtn.setTitle(IMKLineAccessoryType.RawValues[selectedIndex], for: .normal)
            IMKLineParamters.AccessoryType = IMKLineAccessoryType.enumValue(index: selectedIndex)
        }
    }
    
}

