//
//  IMKLineChartViewController.swift
//  IMKLine
//
//  Created by 万涛 on 2017/12/19.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class IMKLineChartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func awakeFromNib() {
        (UIApplication.shared.delegate as! AppDelegate).interfaceOrientation = .landscape
    }
    
    @IBOutlet weak var klineContainerView: IMKLineContainerView!
    @IBOutlet weak var indexSetContainerView: IMKLineIndexSetContainerView!
    @IBOutlet weak var timeFrameSetBtn: UIButton!
    @IBOutlet weak var MASetBtn: UIButton!
    @IBOutlet weak var accessorySetBtn: UIButton!
    @IBOutlet weak var klineStyleBtn: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getKlineDatas()
        self.indexSetContainerView.delegate = self
        self.indexSetContainerView.timeFrameSetViewOrigin = CGPoint.init(x: 50, y: 0)
        self.indexSetContainerView.maSetViewOrigin = CGPoint.init(x: 50, y: 40)
        self.indexSetContainerView.accessorySetViewOrigin = CGPoint.init(x: 50, y: 80)
        self.klineContainerView.scrollView.loadMore = { [weak self] in
            self?.getKlineDatas()
        }
        self.klineStyleBtn.tag = IMKLineParamters.KLineStyle.rawValue
        self.klineStyleBtn.setImage(self.klineStyleImgs[self.klineStyleBtn.tag], for: .normal)
    }
    
    func getKlineDatas() {
//        let params = ["symbol":"btcusdt", "period":"1min","size":"60"]
//        Alamofire.request("https://api.huobi.pro/market/history/kline", parameters: params).responseData { [weak self] (response) in
//            let result = response.result
//            if result.isSuccess {
//                do {
//                    let jsonObj = try JSONSerialization.jsonObject(with: result.value!, options: .mutableLeaves)
//                    let json = JSON(jsonObj)
//                    if json["status"].stringValue == "ok" {
//                        self?.klineGroup = IMKLineGroup.init(datas: json)
//                        self?.showKline()
//                    }
//                } catch {
//                    print(error)
//                }
//            }
//        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let dataJsonPath = Bundle.main.path(forResource: "data", ofType: "json")!
            let data = FileManager.default.contents(atPath: dataJsonPath)!
            do {
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                let json = JSON(jsonObj)
                DispatchQueue.main.async(execute: {
                    let klineGroup = IMKLineGroup()
                    klineGroup.klineArray = IMKLineGroup.klineArray(klineJsonArray: json["data"].arrayValue)
                    self.klineContainerView.appendData(klineArray: klineGroup.klineArray)
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
    
    let klineStyleImgs = [
        R.image.kline_standard(),
        R.image.kline_hollow(),
        R.image.kline_line(),
        R.image.kline_curve()
    ]
    @IBAction func klineStyleBtnClick(_ sender: UIButton) {
        sender.tag = (sender.tag + 1) % 4
        sender.setImage(self.klineStyleImgs[sender.tag], for: .normal)
        IMKLineParamters.KLineStyle = IMKLineStyle.enumValue(sender.tag)
    }
    
    @IBAction func back() {
        (UIApplication.shared.delegate as! AppDelegate).interfaceOrientation = .portrait
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension IMKLineChartViewController: IMKLineIndexSetContainerViewDelegate {
    
    func setBtnClick(indexSetType: IndexSetType, selectedIndex: Int) {
        switch indexSetType {
        case .TimeFrame:
            self.timeFrameSetBtn.tag = selectedIndex
            self.timeFrameSetBtn.setTitle(IMKLineParamters.KLineTimeFrames[selectedIndex], for: .normal)
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
