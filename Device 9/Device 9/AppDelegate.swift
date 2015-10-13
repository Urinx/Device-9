//
//  AppDelegate.swift
//  Device 9
//
//  Created by Eular on 9/17/15.
//  Copyright © 2015 Eular. All rights reserved.
//

import UIKit
import WatchConnectivity

let WXCode = "wx6349772cbf442ce6"
let AppDownload = "http://pre.im/cctv"
let ArticleLink = "http://github.com/urinx"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        WXApi.registerApp(WXCode)
        
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
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        let msg = message as! [String: String]
        
        if msg["msg"] == "get" {
            let defaults = NSUserDefaults(suiteName: "group.device9SharedDefaults")!
            let cellularUsed = defaults.doubleForKey("CellularUsed")
            let wifiUsed = defaults.doubleForKey("WiFiUsed")
            let cellularLeft = defaults.doubleForKey("CellularTotal") - cellularUsed
            
            replyHandler(["msg": "data", "cellularUsed": "\(cellularUsed.MB.afterPoint(1)) MB", "cellularLeft": "\(cellularLeft.MB.afterPoint(1)) MB", "wifiUsed": wifiUsed.GB > 1 ? "\(wifiUsed.GB.afterPoint(1)) GB":"\(Int(wifiUsed.MB)) MB"])
            
        } else if msg["share"] == "wechat" {
            // Create a local notification
            let localNf = UILocalNotification()
            localNf.alertBody = "Share to friends by Wechat"
            localNf.alertTitle = "Device 9"
            localNf.alertAction = "alertAction"
            localNf.fireDate = NSDate()
            
            UIApplication.sharedApplication().scheduleLocalNotification(localNf)
            
            NSNotificationCenter.defaultCenter().postNotificationName("shareToTimeline", object: nil)
        }
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: Bool -> Void) {
        
        let notification = shortcutItem.userInfo!["info"] as! String
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: nil)
        
        completionHandler(true)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
