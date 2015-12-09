//
//  AppDelegate.swift
//  Device 9
//
//  Created by Eular on 9/17/15.
//  Copyright © 2015 Eular. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Weixin SDK
        WXApi.registerApp(WXCode)
        
        // Pre SDK
        let config = PreToolsConfig.defaultConfig()
        config.enabledShakeReport = true
        PreTools.init(PreAppKey, channel: "", config: config)
        
        // Active session
        if WCSession.isSupported() {
            let watchSession = WCSession.defaultSession()
            watchSession.delegate = self
            watchSession.activateSession()
        }
        
        // Register notification
        let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType(arrayLiteral: .Alert, .Badge, .Sound), categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        return true
    }
    
    // Apple Watch Connect
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        let msg = message as! [String: String]
        
        if msg["msg"] == "get" {
            // get the data from user default
            let defaults = NSUserDefaults(suiteName: UserDefaultSuiteName)!
            let cellularUsed = defaults.doubleForKey("CellularUsed")
            let wifiUsed = defaults.doubleForKey("WiFiUsed")
            let cellularLeft = defaults.doubleForKey("CellularTotal") - cellularUsed
            
            // return the data
            replyHandler(["msg": "data", "cellularUsed": "\(cellularUsed.MB.afterPoint(1)) MB", "cellularLeft": "\(cellularLeft.MB.afterPoint(1)) MB", "wifiUsed": wifiUsed.GB > 1 ? "\(wifiUsed.GB.afterPoint(1)) GB":"\(Int(wifiUsed.MB)) MB"])
            
        } else if msg["share"] == "wechat" {
            // Create a local notification
            let localNf = UILocalNotification()
            localNf.alertBody = "Share to friends by Wechat"
            localNf.alertTitle = "Device 9"
            localNf.alertAction = "alertAction"
            localNf.fireDate = NSDate()
            UIApplication.sharedApplication().scheduleLocalNotification(localNf)
            NSNotificationCenter.defaultCenter().postNotificationName(ShareTimelineNotif, object: nil)
        }
    }
    
    // 3D Touch Handler
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: Bool -> Void) {
        
        let notification = shortcutItem.userInfo!["info"] as! String
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: nil)
        
        completionHandler(true)
    }

}
