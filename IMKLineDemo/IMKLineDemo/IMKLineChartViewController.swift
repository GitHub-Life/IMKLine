//
//  IMKLineChartViewController.swift
//  IMKLine
//
//  Created by iMoon on 2017/12/19.
//  Copyright © 2017年 iMoon. All rights reserved.
//

import UIKit
import IMKLine
import SwiftyJSON

class IMKLineChartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func awakeFromNib() {
        (UIApplication.shared.delegate as! AppDelegate).interfaceOrientation = .landscape
    }
    
    @IBOutlet weak var klineContainerView: IMKLineContainerView!
    @IBOutlet weak var timeFrameSetBtn: UIButton!
    @IBOutlet weak var MASetBtn: UIButton!
    @IBOutlet weak var accessorySetBtn: UIButton!
    @IBOutlet weak var klineStyleBtn: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getKlineDatas()
        self.klineContainerView.scrollView.loadMore = { [weak self] in
            self?.getKlineDatas()
        }
        self.klineStyleBtn.tag = IMKLineParamters.KLineStyle.rawValue
        self.klineStyleBtn.setImage(self.klineStyleImgs[self.klineStyleBtn.tag], for: .normal)
    }
    
    func getKlineDatas() {
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
    }
    
    @IBAction func MASetBtnClick(sender: UIButton) {
        self.MASetBtn.tag = (self.MASetBtn.tag + 1) % IMKLineMAType.RawValues.count
        self.MASetBtn.setTitle(IMKLineMAType.RawValues[self.MASetBtn.tag], for: .normal)
        IMKLineParamters.KLineMAType = IMKLineMAType.enumValue(index: self.MASetBtn.tag)
    }
    
    @IBAction func accessorySetBtnClick(sender: UIButton) {
        self.accessorySetBtn.tag = (self.accessorySetBtn.tag + 1) % IMKLineAccessoryType.RawValues.count
        self.accessorySetBtn.setTitle(IMKLineAccessoryType.RawValues[self.accessorySetBtn.tag], for: .normal)
        IMKLineParamters.AccessoryType = IMKLineAccessoryType.enumValue(index: self.accessorySetBtn.tag)
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
    
}
