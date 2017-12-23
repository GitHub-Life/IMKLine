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
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getKlineDatas()
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
}

