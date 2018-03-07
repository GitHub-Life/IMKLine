//
//  IMLangHelper.swift
//  IMKLine
//
//  Created by iMoon on 2018/3/7.
//  Copyright © 2018年 iMoon. All rights reserved.
//

import UIKit

enum IMLanguage: String {
    case cn = "zh-Hans", en = "en"
}

class IMLangHelper: NSObject {
    
    private let UserLanguage = "UserLanguage"
    private let AppleLanguage = "AppleLanguages"
    
    private static let sharedInstance = IMLangHelper.init()
    static var shared: IMLangHelper {
        return sharedInstance
    }
    private override init() {
        super.init()
        // APP内自定义语言环境
        //        let userDefaults = UserDefaults.standard
        //        var string = userDefaults.string(forKey: UserLanguage) ?? ""
        //        if string == "" {
        //            if let languages = userDefaults.array(forKey: AppleLanguage), languages.count > 0 {
        //                if let currentLanguage = languages.first as? String {
        //                    string = currentLanguage
        //                    userDefaults.set(currentLanguage, forKey: UserLanguage)
        //                    userDefaults.synchronize()
        //                }
        //            }
        //        }
        //        string = string.replacingOccurrences(of: "-CN", with: "")
        //        string = string.replacingOccurrences(of: "-US", with: "")
        //        let path = Bundle.main.path(forResource: string, ofType: "lproj") ?? Bundle.main.path(forResource: Language.cn.rawValue, ofType: "lproj")!
        //        self.bundle = Bundle.init(path: path)
        // 跟随系统语言环境
        let userDefaults = UserDefaults.standard
        var string = userDefaults.array(forKey: AppleLanguage)![0] as! String
        string = string.replacingOccurrences(of: "-CN", with: "")
        string = string.replacingOccurrences(of: "-US", with: "")
        userDefaults.set(string, forKey: UserLanguage)
        userDefaults.synchronize()
        let path = Bundle.main.path(forResource: string, ofType: "lproj") ?? Bundle.main.path(forResource: IMLanguage.cn.rawValue, ofType: "lproj")!
        self.bundle = Bundle.init(path: path)
    }
    
    private var currentLanguage: IMLanguage?
    var language: IMLanguage {
        set {
            currentLanguage = newValue
            // APP内自定义语言环境
            //            let path = Bundle.main.path(forResource: currentLanguage!.rawValue, ofType: "lproj")!
            //            self.bundle = Bundle.init(path: path)
            //            UserDefaults.standard.set(currentLanguage!.rawValue, forKey: UserLanguage);
            //            UserDefaults.standard.set([currentLanguage!.rawValue], forKey: AppleLanguage);
            //            UserDefaults.standard.synchronize()
            //            NotificationCenter.default.post(name: XTNotificationKey.LanguageChanged, object: nil)
            //            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //            appDelegate.window?.rootViewController = R.storyboard.tabBar.xtNavigationController()!
            //            appDelegate.window?.makeKeyAndVisible()
        }
        get {
            if currentLanguage == nil {
                currentLanguage = IMLanguage.init(rawValue: UserDefaults.standard.string(forKey: UserLanguage) ?? IMLanguage.cn.rawValue) ?? IMLanguage.cn
            }
            return currentLanguage!
        }
    }
    
    private var bundle: Bundle?
    
    static func getString(_ key: String) -> String {
        if let bundle = IMLangHelper.shared.bundle {
            return bundle.localizedString(forKey: key, value: nil, table: nil)
        }
        return ""
    }
    
}

