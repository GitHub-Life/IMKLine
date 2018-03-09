//
//  AppDelegate.swift
//  IMKLineDemo
//
//  Created by 万涛 on 2018/3/9.
//  Copyright © 2018年 iMoon. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var interfaceOrientation = UIInterfaceOrientationMask.landscape
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.interfaceOrientation
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        initAppService()
        
        return true
    }
    
}


import SwiftyBeaver

let log = SwiftyBeaver.self

extension AppDelegate {
    
    func initAppService() {
        let console = ConsoleDestination()  // log to Xcode Console
        let file = FileDestination()  // log to default swiftybeaver.log file
        log.addDestination(console)
        log.addDestination(file)
    }
    
}
